package com.example.ekyc_flutter_sdk;

import android.graphics.Point;
import android.graphics.PointF;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

public class UtilsFace {
    public static List<Anchor> getAnchors(AnchorOption options) {
        List<Anchor> _anchors = new ArrayList<>();
        if (options.getStridesSize() != options.numLayers) {
            // print('strides_size and num_layers must be equal.');
            return new ArrayList<>();
        }
        int layerID = 0;
        while (layerID < options.getStridesSize()) {
            List<Float> anchorHeight = new ArrayList<>();
            List<Float> anchorWidth = new ArrayList<>();
            List<Float> aspectRatios = new ArrayList<>();
            List<Float> scales = new ArrayList<>();

            int lastSameStrideLayer = layerID;
            while (lastSameStrideLayer < options.getStridesSize() &&
                    options.strides.get(lastSameStrideLayer).equals(options.strides.get(layerID))) {
                float scale = options.minScale +
                        (options.maxScale - options.minScale) *
                                1.0f *
                                lastSameStrideLayer /
                                (options.getStridesSize() - 1.0f);
                if (lastSameStrideLayer == 0 && options.reduceBoxesInLowestLayer) {
                    aspectRatios.add(1.0f);
                    aspectRatios.add(2.0f);
                    aspectRatios.add(0.5f);
                    scales.add(0.1f);
                    scales.add(scale);
                    scales.add(scale);
                } else {
                    for (int i = 0; i < options.aspectRatios.size(); i++) {
                        aspectRatios.add(options.aspectRatios.get(i));
                        scales.add(scale);
                    }

                    if (options.interpolatedScaleAspectRatio > 0.0) {
                        float scaleNext = 0.0f;
                        if (lastSameStrideLayer == options.getStridesSize() - 1) {
                            scaleNext = 1.0f;
                        } else {
                            scaleNext = options.minScale +
                                    (options.maxScale - options.minScale) *
                                            1.0f *
                                            (lastSameStrideLayer + 1) /
                                            (options.getStridesSize() - 1.0f);
                        }
                        scales.add((float) Math.sqrt(scale * scaleNext));
                        aspectRatios.add(options.interpolatedScaleAspectRatio);
                    }
                }
                lastSameStrideLayer++;
            }
            for (int i = 0; i < aspectRatios.size(); i++) {
                double ratioSQRT = Math.sqrt(aspectRatios.get(i));
                anchorHeight.add((float) (scales.get(i) / ratioSQRT));
                anchorWidth.add((float) (scales.get(i) * ratioSQRT));
            }
            int featureMapHeight = 0;
            int featureMapWidth = 0;
            if (options.getFeatureMapHeightSize() > 0) {
                featureMapHeight = options.featureMapHeight.get(layerID);
                featureMapWidth = options.featureMapWidth.get(layerID);
            } else {
                int stride = options.strides.get(layerID);
                featureMapHeight = (int) Math.ceil(1.0 * options.inputSizeHeight / stride);
                featureMapWidth = (int) Math.ceil(1.0 * options.inputSizeWidth / stride);
            }

            for (int y = 0; y < featureMapHeight; y++) {
                for (int x = 0; x < featureMapWidth; x++) {
                    for (int anchorID = 0; anchorID < anchorHeight.size(); anchorID++) {
                        float xCenter = (x + options.anchorOffsetX) * 1.0f / featureMapWidth;
                        float yCenter = (y + options.anchorOffsetY) * 1.0f / featureMapHeight;
                        float w = 0;
                        float h = 0;
                        if (options.fixedAnchorSize) {
                            w = 1.0f;
                            h = 1.0f;
                        } else {
                            w = anchorWidth.get(anchorID);
                            h = anchorHeight.get(anchorID);
                        }
                        _anchors.add(new Anchor(xCenter, yCenter, h, w));
                    }
                }
            }
            layerID = lastSameStrideLayer;
        }
        return _anchors;
    }

    static final double minPositive = 5e-324;

    public static List<Detection> process(OptionsFace options,
            float[] rawScores,
            float[] rawBoxes,
            List<Anchor> anchors) {
        List<Float> detectionScores = new ArrayList<>();
        List<Integer> detectionClasses = new ArrayList<>();

        int boxes = options.numBoxes;
        for (int i = 0; i < boxes; i++) {
            int classId = -1;
            float maxScore = (float) minPositive;
            for (int scoreIdx = 0; scoreIdx < options.numClasses; scoreIdx++) {
                float score = rawScores[i * options.numClasses + scoreIdx];
                if (options.sigmoidScore) {
                    if (options.scoreClippingThresh > 0) {
                        if (score < -options.scoreClippingThresh)
                            score = -options.scoreClippingThresh;
                        if (score > options.scoreClippingThresh)
                            score = options.scoreClippingThresh;
                        score = (float) (1.0f / (1.0f + Math.exp(-score)));
                        if (maxScore < score) {
                            maxScore = score;
                            classId = scoreIdx;
                        }
                    }
                }
            }
            detectionClasses.add(classId);
            detectionScores.add(maxScore);
        }
        List<Detection> detections = convertToDetections(rawBoxes, anchors, detectionScores, detectionClasses, options);
        return detections;
    }

    public static List<Detection> convertToDetections(
            float[] rawBoxes,
            List<Anchor> anchors,
            List<Float> detectionScores,
            List<Integer> detectionClasses,
            OptionsFace options) {
        List<Detection> _outputDetections = new ArrayList<>();
        for (int i = 0; i < options.numBoxes; i++) {
            if (detectionScores.get(i) < options.minScoreThresh)
                continue;
            int boxOffset = 0;
            List<Float> boxData = decodeBox(rawBoxes, i, anchors, options);
            PointF[] landmarks = new PointF[options.numKeypoints];
            for (int k = 0; k < options.numKeypoints; k++) {
                float x = boxData.get(boxOffset + 4 + k * 2);
                float y;
                if (options.flipVertically) {
                    y = 1 - boxData.get(boxOffset + 4 + k * 2 + 1);
                } else {
                    y = boxData.get(boxOffset + 4 + k * 2 + 1);
                }
                PointF tmpLand = new PointF(x, y);
                landmarks[k] = tmpLand;
            }
            Detection detection = convertToDetection(
                    boxData.get(boxOffset),
                    boxData.get(boxOffset + 1),
                    boxData.get(boxOffset + 2),
                    boxData.get(boxOffset + 3),
                    detectionScores.get(i),
                    detectionClasses.get(i),
                    options.flipVertically,
                    landmarks);
            _outputDetections.add(detection);
        }
        return _outputDetections;
    }

    public static List<Float> decodeBox(
            float[] rawBoxes,
            int i,
            List<Anchor> anchors,
            OptionsFace options) {
        List<Float> boxData = new ArrayList<>();
        for (int j = 0; j < options.numCoords; j++) {
            boxData.add(0.0f);
        }
        int boxOffset = i * options.numCoords + options.boxCoordOffset;
        float yCenter = rawBoxes[boxOffset];
        float xCenter = rawBoxes[boxOffset + 1];
        float h = rawBoxes[boxOffset + 2];
        float w = rawBoxes[boxOffset + 3];
        if (options.reverseOutputOrder) {
            xCenter = rawBoxes[boxOffset];
            yCenter = rawBoxes[boxOffset + 1];
            w = rawBoxes[boxOffset + 2];
            h = rawBoxes[boxOffset + 3];
        }

        xCenter = xCenter / options.xScale * anchors.get(i).w + anchors.get(i).x_center;
        yCenter = yCenter / options.yScale * anchors.get(i).h + anchors.get(i).y_center;

        if (options.applyExponentialOnBoxSize) {
            h = (float) (Math.exp(h / options.hScale) * anchors.get(i).h);
            w = (float) (Math.exp(w / options.wScale) * anchors.get(i).w);
        } else {
            h = h / options.hScale * anchors.get(i).h;
            w = w / options.wScale * anchors.get(i).w;
        }

        float yMin = yCenter - h / 2.0f;
        float xMin = xCenter - w / 2.0f;
        float yMax = yCenter + h / 2.0f;
        float xMax = xCenter + w / 2.0f;

        boxData.set(0, yMin);
        boxData.set(1, xMin);
        boxData.set(2, yMax);
        boxData.set(3, xMax);

        if (options.numKeypoints > 0) {
            for (int k = 0; k < options.numKeypoints; k++) {
                int offset = i * options.numCoords +
                        options.keypointCoordOffset +
                        k * options.numValuesPerKeypoint;
                float keyPointY = rawBoxes[offset];
                float keyPointX = rawBoxes[offset + 1];

                if (options.reverseOutputOrder) {
                    keyPointX = rawBoxes[offset];
                    keyPointY = rawBoxes[offset + 1];
                }
                boxData.set(4 + k * options.numValuesPerKeypoint,
                        keyPointX / options.xScale * anchors.get(i).w + anchors.get(i).x_center);

                boxData.set(4 + k * options.numValuesPerKeypoint + 1,
                        keyPointY / options.yScale * anchors.get(i).h + anchors.get(i).y_center);
            }
        }
        return boxData;
    }

    public static Detection convertToDetection(float boxYMin, float boxXMin, float boxYMax,
            float boxXMax, float score, int classID, boolean flipVertically, PointF[] landmarks) {
        float _yMin;
        if (flipVertically)
            _yMin = 1.0f - boxYMax;
        else
            _yMin = boxYMin;
        return new Detection(score, classID, boxXMin, _yMin, (boxXMax - boxXMin),
                (boxYMax - boxYMin), landmarks, boxXMax, boxYMax);
    }

    public static List<Detection> origNms(List<Detection> detections, float threshold, int img_width, int img_height)
            throws Exception {
        if (detections.size() <= 0)
            return new ArrayList<>();
        List<Float> x1 = new ArrayList<>();
        List<Float> x2 = new ArrayList<>();
        List<Float> y1 = new ArrayList<>();
        List<Float> y2 = new ArrayList<>();
        List<Float> s = new ArrayList<>();

        for (Detection detection : detections) {
            x1.add(detection.xMin * img_width);
            x2.add((detection.xMin + detection.width) * img_width);
            y1.add(detection.yMin * img_height);
            y2.add((detection.yMin + detection.height) * img_height);
            s.add(detection.score);
        }

        List<Float> _x1 = new ArrayList<>(x1);
        List<Float> _x2 = new ArrayList<>(x2);
        List<Float> _y1 = new ArrayList<>(y1);
        List<Float> _y2 = new ArrayList<>(y2);
        List<Float> area = multipliedFloatList(subtract(_x2, _x1), subtract(_y2, _y1));
        List<Float> I = _quickSort(s);

        List<Integer> pick = new ArrayList<>();
        List<Integer> positions = new ArrayList<>();
        for (Float element : I) {
            positions.add(s.indexOf(element));
        }
        while (positions.size() > 0) {
            List<Integer> ind0 = positions.subList(positions.size() - 1, positions.size());
            List<Integer> ind1 = positions.subList(0, positions.size() - 1);
            List<Float> xx1 = _maximum(_itemIndex(_x1, ind0).get(0), _itemIndex(_x1, ind1));
            List<Float> yy1 = _maximum(_itemIndex(_y1, ind0).get(0), _itemIndex(_y1, ind1));
            List<Float> xx2 = _minimum(_itemIndex(_x2, ind0).get(0), _itemIndex(_x2, ind1));

            List<Float> yy2 = _minimum(_itemIndex(_y2, ind0).get(0), _itemIndex(_y2, ind1));
            List<Float> w = _maximum(0.0f, subtract(xx2, xx1));
            List<Float> h = _maximum(0.0f, subtract(yy2, yy1));
            List<Float> inter = multipliedFloatList(w, h);
            List<Float> m = (subtract(_sum(_itemIndex(area, ind0).get(0), _itemIndex(area, ind1)), inter));
            List<Float> o = divideFloatList(inter, m);
            pick.add(ind0.get(0));
            List<Integer> _inCorrectIndex = inCorrectIndex(positions, o, threshold);
            positions = removeInCorrectIndex(positions, _inCorrectIndex);
        }
        List<Detection> _detections = new ArrayList<>();
        for (Integer element : pick) {
            _detections.add(detections.get(element));
        }
        return _detections;
    }

    public static List<Float> _sum(float a, List<Float> b) {
        List<Float> _temp = new ArrayList<>();
        for (Float element : b) {
            _temp.add(a + element);
        }
        return new ArrayList(_temp);
    }

    public static List<Float> _maximum(Float value, List<Float> itemIndex) {
        List<Float> _temp = new ArrayList<>();
        for (Float element : itemIndex) {
            if (value > element)
                _temp.add(value);
            else
                _temp.add(element);
        }
        return new ArrayList(_temp);
    }

    public static List<Float> _itemIndex(List<Float> item, List<Integer> positions) {
        List<Float> _temp = new ArrayList<>();
        for (Integer element : positions) {
            _temp.add(item.get(element));
        }
        return new ArrayList<>(_temp);
    }

    public static List<Float> _quickSort(List<Float> a) {
        if (a.size() <= 1)
            return a;

        Float pivot = a.get(0);
        List<Float> less = new ArrayList<>();
        List<Float> more = new ArrayList<>();
        List<Float> pivotList = new ArrayList<>();

        for (Float i : a) {
            if (i.compareTo(pivot) < 0) {
                less.add(i);
            } else if (i.compareTo(pivot) > 0) {
                more.add(i);
            } else {
                pivotList.add(i);
            }
        }

        less = _quickSort(less);
        more = _quickSort(more);

        less.addAll(pivotList);
        less.addAll(more);
        return less;
    }

    // public static <T> ArrayList<T> subtract(List<T> alpha, List<T> beta) {
    // ArrayList<T> gamma = new ArrayList<T>();
    // for (T n: alpha) {
    // if (!beta.contains(n)) gamma.add(n);
    // }
    // return gamma;
    // }

    private static List<Float> subtract(List<Float> intList1, List<Float> intList2) throws Exception {
        List<Float> multipliedList = new ArrayList<>();
        int num = intList2.size();
        if (intList1.size() != intList2.size()) {
            throw new Exception();
        }
        for (int i = 0; i < num; i++) {
            multipliedList.add(intList1.get(i) - intList2.get(i));
        }
        return multipliedList;
    }

    private static List<Float> multipliedFloatList(List<Float> intList1, List<Float> intList2) throws Exception {
        List<Float> multipliedList = new ArrayList<>();
        int num = intList1.size();
        if (intList1.size() != intList2.size()) {
            throw new Exception();
        }
        for (int i = 0; i < num; i++) {
            multipliedList.add(intList1.get(i) * intList2.get(i));
        }
        return multipliedList;
    }

    public static List<Float> divideFloatList(List<Float> intList1, List<Float> intList2) throws Exception {
        List<Float> multipliedList = new ArrayList<>();
        int num = intList1.size();
        if (intList1.size() != intList2.size()) {
            throw new Exception();
        }
        for (int i = 0; i < num; i++) {
            multipliedList.add(intList1.get(i) / intList2.get(i));
        }
        return multipliedList;
    }

    private static List<Float> plusValue(List<Float> intList1, Float value) throws Exception {
        List<Float> multipliedList = new ArrayList<>();
        for (int i = 0; i < intList1.size(); i++) {
            multipliedList.add(intList1.get(i) + value);
        }
        return multipliedList;
    }

    public static List<Float> _minimum(Float value, List<Float> itemIndex) {
        List<Float> _temp = new ArrayList<>();
        for (Float element : itemIndex) {
            if (value < element)
                _temp.add(value);
            else
                _temp.add(element);
        }
        return _temp;
    }

    public static List<Integer> removeInCorrectIndex(List<Integer> positions, List<Integer> inCorrectIndex) {
        positions.remove(positions.size() - 1);
        for (Integer element : inCorrectIndex) {
            positions.remove(element);
        }
        return positions;
    }

    static List<Integer> inCorrectIndex(List<Integer> positions, List<Float> o, double threshold) {
        List<Integer> _index = new ArrayList<>();
        for (int i = 0; i < o.size(); i++) {
            if (o.get(i) > threshold) {
                _index.add(positions.get(i));
            }
        }
        return _index;
    }

}
