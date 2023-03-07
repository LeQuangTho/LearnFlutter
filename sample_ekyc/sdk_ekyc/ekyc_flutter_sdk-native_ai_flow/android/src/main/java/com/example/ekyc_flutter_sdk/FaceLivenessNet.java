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
import org.tensorflow.lite.support.common.ops.NormalizeOp;

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

public class FaceLivenessNet extends Classifier {

    /**
     * The quantized model does not require normalization, thus set mean as 0.0f,
     * and std as 1.0f to
     * bypass the normalization.
     */
    private static final float IMAGE_MEAN = 0.0f;

    private static final float IMAGE_STD = 1.0f;

    /**
     * Quantized MobileNet requires additional dequantization to the output
     * probability.
     */
    private static final float PROBABILITY_MEAN = 0.0f;

    private static final float PROBABILITY_STD = 255.0f;
    public static final int OUTPUT_SIZE = 6;

    /**
     * Initializes a {@code ClassifierQuantizedMobileNet}.
     *
     * @param activity
     */
    public FaceLivenessNet(MappedByteBuffer buffer, Device device, int numThreads)
            throws IOException {
        super(buffer, device, numThreads);
    }

    @Override
    protected TensorImage loadImage(Bitmap bitmap) {
        // Loads bitmap into a TensorImage.
        inputImageBuffer.load(bitmap);
        // TODO(b/143564309): Fuse ops inside ImageProcessor.
        ImageProcessor imageProcessor = new ImageProcessor.Builder()
                .add(new ResizeOp(256, 256, ResizeOp.ResizeMethod.BILINEAR))
                .build();
        return imageProcessor.process(inputImageBuffer);
    }

    @Override
    public List<Float> recognizeImage(Bitmap bitmap) {
        // Logs this method so that it can be analyzed with systrace.
        Trace.beginSection("recognizeImage");
        Trace.beginSection("loadImage");
        long startTime = SystemClock.uptimeMillis();
        inputImageBuffer = loadImage(bitmap);
        Trace.endSection();

        // Runs the inference call.
        Trace.beginSection("runInference");
        inputImageBuffer.getBuffer().rewind();

        // print the ByteBuffer
        long startTime2 = SystemClock.uptimeMillis();
        tflite.run(inputImageBuffer.getBuffer(), super.outputProbabilityBuffer.getBuffer().rewind());
        Trace.endSection();
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

    @Override
    public List<Float> recognizeImageBatch(final Bitmap bitmap1, final Bitmap bitmap2) {
        Trace.beginSection("recognizeImage");
        Trace.beginSection("loadImage");
        // preprocess input
        long startTimeForLoadImage = SystemClock.uptimeMillis();
        int[] dimension = new int[4];
        dimension[0] = 2;
        dimension[1] = 256;
        dimension[2] = 256;
        dimension[3] = 3;
        ArrayList<Bitmap> bitmaps = new ArrayList<Bitmap>();
        bitmaps.add(bitmap1);
        bitmaps.add(bitmap2);
        float[][][][] inputImageFloat = loadImage4D(bitmaps, dimension);

        // prepare output
        DataType probabilityDataType1 = tflite.getOutputTensor(0).dataType();
        int[] tmpOutputShape = new int[2];
        tmpOutputShape[0] = 2;
        tmpOutputShape[1] = 6;
        TensorBuffer outputProbabilityBuffer1 = TensorBuffer.createFixedSize(tmpOutputShape, probabilityDataType1);

        // run intepreter
        tflite.run(inputImageFloat, outputProbabilityBuffer1.getBuffer().rewind());
        Trace.endSection();

        // postprocess
        List<Float> list = new ArrayList<>();
        try {
            outputProbabilityBuffer1.getBuffer().rewind();
            for (int i = 0; i < tmpOutputShape[0] * tmpOutputShape[1]; i++) {
                float value = outputProbabilityBuffer1.getBuffer().getFloat();
                list.add(value);
            }
        } catch (BufferUnderflowException ignored) {
        }
        return list;
    }

    @Override
    protected float[][][][] loadImage4D(ArrayList<Bitmap> bitmaps, int[] dimension) {
        int batchNum = dimension[0];
        int height = dimension[1];
        int width = dimension[2];
        int channel = dimension[3];
        float[][][][] input = new float[batchNum][height][width][channel];
        for (int i = 0; i < batchNum; i++) {
            Bitmap tmpBitmap = bitmaps.get(i);
            tmpBitmap = Bitmap.createScaledBitmap(tmpBitmap, width, height, true);
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

    @Override
    protected String getModelPath() {
        return "";
    }

    @Override
    protected String getLabelPath() {
        return "";
    }

    @Override
    protected TensorOperator getPreprocessNormalizeOp() {
        return new NormalizeOp(IMAGE_MEAN, IMAGE_STD);
    }

    @Override
    protected TensorOperator getPostprocessNormalizeOp() {
        return new NormalizeOp(PROBABILITY_MEAN, PROBABILITY_STD);
    }

    public static int[] maxIndexPerBatch(List<Float> results) {
        if (results == null || results.size() == 0)
            return null;
        int batchSize = results.size() / OUTPUT_SIZE;
        int[] listMaxIndex = new int[batchSize];
        for (int i = 0; i < batchSize; i++) {
            float maxValue = results.get(i * OUTPUT_SIZE);
            int maxIndex = 0;
            for (int j = 0; j < OUTPUT_SIZE; j++) {
                if (results.get(i * OUTPUT_SIZE + j) > maxValue) {
                    maxValue = results.get(i * OUTPUT_SIZE + j);
                    maxIndex = j;
                }
            }
            listMaxIndex[i] = maxIndex;
        }
        return listMaxIndex;
    }

    private static int getMaxIndex(int[] index) {
        if (index.length == OUTPUT_SIZE) {
            return index[0];
        }
        // handle batch output
        else
            return index[0];
    }

    public static boolean isCardValid(List<Float> results) {
        int[] listMaxIndex = maxIndexPerBatch(results);
        int indexMax = getMaxIndex(listMaxIndex);
        if (indexMax == 0)
            return true;
        return false;
    }
}
