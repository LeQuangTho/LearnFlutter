/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

package com.example.ekyc_flutter_sdk;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.RectF;
import android.os.SystemClock;
import android.os.Trace;
import android.util.Log;

import org.tensorflow.lite.DataType;
import org.tensorflow.lite.Interpreter;

import org.tensorflow.lite.nnapi.NnApiDelegate;
import org.tensorflow.lite.support.common.FileUtil;
import org.tensorflow.lite.support.common.TensorOperator;
import org.tensorflow.lite.support.common.TensorProcessor;
import org.tensorflow.lite.support.image.ImageProcessor;
import org.tensorflow.lite.support.image.TensorImage;
import org.tensorflow.lite.support.image.ops.ResizeOp;
import org.tensorflow.lite.support.image.ops.ResizeOp.ResizeMethod;
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer;

import java.io.IOException;
import java.nio.BufferUnderflowException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.PriorityQueue;

/**
 * A classifier specialized to label images using TensorFlow Lite.
 */
public abstract class Classifier {
    private static String path;

    /**
     * The model type used for classification.
     */
    public enum Model {
        CARD_LIVENESSNET,
        FACE_LIVENESSNET,
        FACE_DETECTION,
    }

    /**
     * The runtime device type used for executing classification.
     */
    public enum Device {
        CPU,
        NNAPI
    }

    /**
     * Number of results to show in the UI.
     */
    private static final int MAX_RESULTS = 3;

    /**
     * The loaded TensorFlow Lite model.
     */
    private MappedByteBuffer tfliteModel;

    /**
     * Image size along the x axis.
     */
    private final int imageSizeX;

    /**
     * Image size along the y axis.
     */
    private final int imageSizeY;

    /**
     * Optional NNAPI delegate for accleration.
     */
    private NnApiDelegate nnApiDelegate = null;

    /**
     * An instance of the driver class to run model inference with Tensorflow Lite.
     */
    public Interpreter tflite;

    /**
     * Options for configuring the Interpreter.
     */
    private final Interpreter.Options tfliteOptions = new Interpreter.Options();
    /**
     * Labels corresponding to the output of the vision model.
     */
    private List<String> labels;

    /**
     * Input image TensorBuffer.
     */
    protected TensorImage inputImageBuffer;

    /**
     * Output probability TensorBuffer.
     */
    protected final TensorBuffer outputProbabilityBuffer;

    /**
     * Processer to apply post processing of the output probability.
     */
    private final TensorProcessor probabilityProcessor;

    /**
     * Creates a classifier with the provided configuration.
     *
     * @param activity   The current Activity.
     * @param model      The model to use for classification.
     * @param device     The device to use for classification.
     * @param numThreads The number of threads to use for classification.
     * @return A classifier with the desired configuration.
     */

    /**
     * Initializes a {@code Classifier}.
     */
    protected Classifier(MappedByteBuffer buffer, Device device, int numThreads) throws IOException {
        tfliteModel = buffer;
        // CompatibilityList compatList = CompatibilityList();
        switch (device) {
            case NNAPI:
                nnApiDelegate = new NnApiDelegate();
                tfliteOptions.addDelegate(nnApiDelegate);
                break;
            case CPU:
                break;
        }
        tfliteOptions.setNumThreads(numThreads);
        tflite = new Interpreter(tfliteModel, tfliteOptions);

        // Reads type and shape of input and output tensors, respectively.
        int imageTensorIndex = 0;
        int[] imageShape = tflite.getInputTensor(imageTensorIndex).shape(); // {1, height, width, 3}
        imageSizeY = imageShape[1];
        imageSizeX = imageShape[2];
        DataType imageDataType = tflite.getInputTensor(imageTensorIndex).dataType();
        int probabilityTensorIndex = 0;
        int[] probabilityShape = tflite.getOutputTensor(probabilityTensorIndex).shape(); // {1, NUM_CLASSES}
        DataType probabilityDataType = tflite.getOutputTensor(probabilityTensorIndex).dataType();

        // Creates the input tensor.
        inputImageBuffer = new TensorImage(imageDataType);

        // Creates the output tensor and its processor.
        outputProbabilityBuffer = TensorBuffer.createFixedSize(probabilityShape, probabilityDataType);

        // Creates the post processor for the output probability.
        probabilityProcessor = new TensorProcessor.Builder().add(getPostprocessNormalizeOp()).build();
    }

    public static Classifier create(MappedByteBuffer buffer, Model model, Device device, int numThreads,
            String pathModel)
            throws IOException {
        if (model == Model.CARD_LIVENESSNET) {
            return new CardLivenessNet(buffer, device, numThreads);
        } else if (model == Model.FACE_LIVENESSNET) {
            return new FaceLivenessNet(buffer, device, numThreads);
        } else {
            throw new UnsupportedOperationException();
        }
    }

    /**
     * An immutable result returned by a Classifier describing what was recognized.
     */
    public static class Recognition {
        /**
         * A unique identifier for what has been recognized. Specific to the class, not
         * the instance of
         * the object.
         */
        private final String id;

        /**
         * Display name for the recognition.
         */
        private final String title;

        /**
         * A sortable score for how good the recognition is relative to others. Higher
         * should be better.
         */
        private final Float confidence;

        /**
         * Optional location within the source image for the location of the recognized
         * object.
         */
        private RectF location;

        public Recognition(
                final String id, final String title, final Float confidence, final RectF location) {
            this.id = id;
            this.title = title;
            this.confidence = confidence;
            this.location = location;
        }

        public String getId() {
            return id;
        }

        public String getTitle() {
            return title;
        }

        public Float getConfidence() {
            return confidence;
        }

        public RectF getLocation() {
            return new RectF(location);
        }

        public void setLocation(RectF location) {
            this.location = location;
        }

        @Override
        public String toString() {
            String resultString = "";
            if (id != null) {
                resultString += "[" + id + "] ";
            }

            if (title != null) {
                resultString += title + " ";
            }

            if (confidence != null) {
                resultString += String.format("(%.1f%%) ", confidence * 100.0f);
            }

            if (location != null) {
                resultString += location + " ";
            }

            return resultString.trim();
        }
    }

    /**
     * Runs inference and returns the classification results.
     */
    public List<Float> recognizeImage(final Bitmap bitmap) {
        // Logs this method so that it can be analyzed with systrace.
        Trace.beginSection("recognizeImage");

        Trace.beginSection("loadImage");
        long startTimeForLoadImage = SystemClock.uptimeMillis();
        inputImageBuffer = loadImage(bitmap);
        long endTimeForLoadImage = SystemClock.uptimeMillis();
        Trace.endSection();
        // Runs the inference call.
        Trace.beginSection("runInference");
        long startTimeForReference = SystemClock.uptimeMillis();
        inputImageBuffer.getBuffer().rewind();

        // print the ByteBuffer
        tflite.run(inputImageBuffer.getBuffer(), outputProbabilityBuffer.getBuffer().rewind());
        long endTimeForReference = SystemClock.uptimeMillis();
        Trace.endSection();
        List<Float> list = new ArrayList<>();
        try {
            outputProbabilityBuffer.getBuffer().rewind();
            float value = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value);
            float value1 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value1);
            float value2 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value2);
            float value3 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value3);
            float value4 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value4);
            float value5 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value5);
            float value6 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value6);
            float value7 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value7);
            float value8 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value8);
            float value9 = outputProbabilityBuffer.getBuffer().getFloat();
            list.add(value9);
        } catch (BufferUnderflowException e) {
            System.out.println("\nException Thrown : " + e);
        }
        return list;
    }

    public List<Float> recognizeImageBatch(final Bitmap bitmap1, final Bitmap bitmap2) {
        Trace.beginSection("recognizeImage");
        Trace.beginSection("loadImage");

        // preprocess input
        int[] dimension = new int[4];
        dimension[0] = 2;
        dimension[1] = 256;
        dimension[2] = 256;
        dimension[3] = 3;
        ArrayList<Bitmap> bitmaps = new ArrayList<Bitmap>();
        bitmaps.add(bitmap1);
        bitmaps.add(bitmap2);
        float[][][][] inputImageFloat = loadImage4D(bitmaps, dimension);
        // run intepreter
        System.out.println("Original ByteBuffer: ");

        tflite.resizeInput(0, dimension);
        tflite.run(inputImageFloat, outputProbabilityBuffer.getBuffer().rewind());
        Trace.endSection();

        // postprocess
        List<Float> list = new ArrayList<>();
        try {
            outputProbabilityBuffer.getBuffer().rewind();
            for (int i = 0; i < 6; i++) {
                float value = outputProbabilityBuffer.getBuffer().getFloat();
                list.add(value);
            }
        } catch (BufferUnderflowException ignored) {
        }
        return list;
    }

    public void close() {
        if (tflite != null) {
            tflite.close();
            tflite = null;
        }
        if (nnApiDelegate != null) {
            nnApiDelegate.close();
            nnApiDelegate = null;
        }
        tfliteModel = null;
    }

    /**
     * Get the image size along the x axis.
     */
    public int getImageSizeX() {
        return imageSizeX;
    }

    /**
     * Get the image size along the y axis.
     */
    public int getImageSizeY() {
        return imageSizeY;
    }

    /**
     * Loads input image, and applies preprocessing.
     */
    protected TensorImage loadImage(final Bitmap bitmap) {
        // Loads bitmap into a TensorImage.
        inputImageBuffer.load(bitmap);
        // TODO(b/143564309): Fuse ops inside ImageProcessor.
        ImageProcessor imageProcessor = new ImageProcessor.Builder()
                .add(new ResizeOp(224, 224, ResizeMethod.BILINEAR))
                .add(getPreprocessNormalizeOp())
                .build();
        return imageProcessor.process(inputImageBuffer);
    }

    protected float[][][][] loadImage4D(ArrayList<Bitmap> bitmaps, int[] dimension) {
        int batchNum = dimension[0];
        int height = dimension[1];
        int width = dimension[2];
        int channel = dimension[3];
        float[][][][] input = new float[batchNum][height][width][channel];
        for (int i = 0; i < batchNum; i++) {
            Bitmap tmpBitmap = bitmaps.get(i);
            tmpBitmap = Bitmap.createScaledBitmap(tmpBitmap, height, width, true);
            // tmpBitmap = getBitmapFromAsset(context, "test_images.jpg"s );
            // SaveImage(tmpBitmap, "test_" + String.valueOf(System.currentTimeMillis()) +
            // ".jpg");
            for (int h = 0; h < height; h++) {
                for (int w = 0; w < width; w++) {
                    int pixel = tmpBitmap.getPixel(h, w);
                    input[i][w][h][0] = Color.red(pixel);
                    input[i][w][h][1] = Color.green(pixel);
                    input[i][w][h][2] = Color.blue(pixel);
                }
            }
        }
        return input;
    }

    /**
     * Gets the top-k results.
     */
    private static List<Recognition> getTopKProbability(Map<String, Float> labelProb) {
        // Find the best classifications.
        PriorityQueue<Recognition> pq = new PriorityQueue<>(
                MAX_RESULTS,
                new Comparator<Recognition>() {
                    @Override
                    public int compare(Recognition lhs, Recognition rhs) {
                        // Intentionally reversed to put high confidence at the head of the queue.
                        return Float.compare(rhs.getConfidence(), lhs.getConfidence());
                    }
                });

        for (Map.Entry<String, Float> entry : labelProb.entrySet()) {
            pq.add(new Recognition("" + entry.getKey(), entry.getKey(), entry.getValue(), null));
        }

        final ArrayList<Recognition> recognitions = new ArrayList<>();
        int recognitionsSize = Math.min(pq.size(), MAX_RESULTS);
        for (int i = 0; i < recognitionsSize; ++i) {
            recognitions.add(pq.poll());
        }
        return recognitions;
    }

    /**
     * Gets the name of the model file stored in Assets.
     */
    protected abstract String getModelPath();

    /**
     * Gets the name of the label file stored in Assets.
     */
    protected abstract String getLabelPath();

    /**
     * Gets the TensorOperator to nomalize the input image in preprocessing.
     */
    protected abstract TensorOperator getPreprocessNormalizeOp();

    /**
     * Gets the TensorOperator to dequantize the output probability in post
     * processing.
     *
     * <p>
     * For quantized model, we need de-quantize the prediction with NormalizeOp (as
     * they are all
     * essentially linear transformation). For float model, de-quantize is not
     * required. But to
     * uniform the API, de-quantize is added to float model too. Mean and std are
     * set to 0.0f and
     * 1.0f, respectively.
     */
    protected abstract TensorOperator getPostprocessNormalizeOp();
}
