package com.example.ekyc_flutter_sdk;

import android.content.Context;
import android.graphics.Bitmap;
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
import org.tensorflow.lite.support.image.ops.ResizeWithCropOrPadOp;
import org.tensorflow.lite.support.image.ops.Rot90Op;
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.lang.Math.max;
import static java.lang.Math.min;

import org.tensorflow.lite.support.common.ops.NormalizeOp;

/**
 * A classifier specialized to label images using TensorFlow Lite.
 */
public class FaceDetection {
    public static final String TAG = "ClassifierWithSupport";

    /**
     * The model type used for classification.
     */
    public enum Model {
        FACE_DETECT_FRONT,
        FACE_MESH,
        FACE_DETECT_BACK
    }

    /**
     * The quantized model does not require normalization, thus set mean as 0.0f,
     * and std as 1.0f to
     * bypass the normalization.
     */
    private static final float IMAGE_MEAN = 255f;

    private static final float IMAGE_STD = 255f;

    private static final float IMAGE_MEAN_Hubert = 255f;

    private static final float IMAGE_STD_Hubert = 255f;

    /**
     * Quantized MobileNet requires additional dequantization to the output
     * probability.
     */
    private static final float PROBABILITY_MEAN = 127.5f;

    private static final float PROBABILITY_STD = 127.5f;

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

    /** The loaded TensorFlow Lite model. */

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
    protected Interpreter tflite;

    /**
     * Options for configuring the Interpreter.
     */
    private final Interpreter.Options tfliteOptions = new Interpreter.Options();

    /**
     * Input image TensorBuffer.
     */
    private TensorImage inputImageBuffer;

    /**
     * Output probability TensorBuffer.
     */
    private final TensorBuffer output0;
    private final TensorBuffer output1;

    /**
     * Processer to apply post processing of the output probability.
     */
    private final TensorProcessor probabilityProcessor;

    /**
     * Creates a classifier with the provided configuration.
     *
     * @param context    The current Activity.
     * @param model      The model to use for classification.
     * @param device     The device to use for classification.
     * @param numThreads The number of threads to use for classification.
     * @return A classifier with the desired configuration.
     */

    /**
     * Initializes a {@code Classifier}.
     */
    protected FaceDetection(MappedByteBuffer buffer, Device device, int numThreads) throws IOException {
        MappedByteBuffer tfliteModel = buffer;
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

        // Creates the input tensor.
        inputImageBuffer = new TensorImage(imageDataType);

        // Creates the output tensor and its processor.
        int probabilityTensorIndex = 0;
        int[] probabilityShape = tflite.getOutputTensor(probabilityTensorIndex).shape(); // {1, NUM_CLASSES}
        DataType probabilityDataType = tflite.getOutputTensor(probabilityTensorIndex).dataType();
        output0 = TensorBuffer.createFixedSize(probabilityShape, probabilityDataType);

        int probabilityTensorIndex1 = 1;
        int[] probabilityShape1 = tflite.getOutputTensor(probabilityTensorIndex1).shape(); // {1, NUM_CLASSES}
        DataType probabilityDataType1 = tflite.getOutputTensor(probabilityTensorIndex1).dataType();
        output1 = TensorBuffer.createFixedSize(probabilityShape1, probabilityDataType1);

        // Creates the post processor for the output probability.
        probabilityProcessor = new TensorProcessor.Builder().add(getPostprocessNormalizeOp()).build();

        Log.d(TAG, "Created a Tensorflow Lite Image Classifier.");
    }

    /**
     * Closes the interpreter and model to release resources.
     */
    public void close() {
        if (tflite != null) {
            tflite.close();
            tflite = null;
        }
        if (nnApiDelegate != null) {
            nnApiDelegate.close();
            nnApiDelegate = null;
        }
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
    private TensorImage loadImage(final Bitmap bitmap, int sensorOrientation) {
        // Loads bitmap into a TensorImage.
        inputImageBuffer.load(bitmap);

        // Creates processor for the TensorImage.
        int cropSize = min(bitmap.getWidth(), bitmap.getHeight());
        int numRotation = sensorOrientation / 90;

        // TODO(b/143564309): Fuse ops inside ImageProcessor.
        ImageProcessor imageProcessor = new ImageProcessor.Builder()
                // .add(new ResizeWithCropOrPadOp(cropSize, cropSize))
                .add(new ResizeOp(imageSizeX, imageSizeY, ResizeMethod.BILINEAR))
                .add(new Rot90Op(numRotation))
                .add(getPreprocessNormalizeOp())
                .build();

        TensorImage aa = imageProcessor.process(inputImageBuffer);

        return aa;
    }

    public List<Detection> detectFaceFront(final Bitmap bitmap, int sensorOrientation, boolean reverseOutputOrder,
            boolean flipVertically, float ratio) {
        OptionsFace options = new OptionsFace(
                1,
                896,
                16,
                4,
                new ArrayList<Integer>(),
                100.0f,
                0.7f,
                6,
                2,
                reverseOutputOrder,
                0,
                128,
                128,
                128,
                128,
                flipVertically);

        AnchorOption anchors = new AnchorOption(
                128,
                128,
                0.1484375f,
                0.75f,
                0.5f,
                0.5f,
                4,
                new ArrayList<Integer>(),
                new ArrayList<Integer>(),
                Arrays.asList(8, 16, 16, 16),
                Arrays.asList(ratio),
                false,
                ratio,
                true);

        List<Anchor> _andchors = UtilsFace.getAnchors(anchors);
        // Logs this method so that it can be analyzed with systrace.
        Trace.beginSection("recognizeImage");
        Trace.beginSection("loadImage");

        long startTimeForLoadImage = SystemClock.uptimeMillis();
        inputImageBuffer = loadImage(bitmap, sensorOrientation);
        long endTimeForLoadImage = SystemClock.uptimeMillis();
        Trace.endSection();

        // Runs the inference call.
        Trace.beginSection("runInference");
        long startTimeForReference = SystemClock.uptimeMillis();
        long initOutput = SystemClock.uptimeMillis();
        Map<Integer, Object> outputs = new HashMap();

        long createOutput = SystemClock.uptimeMillis();
        outputs.put(0, output0.getBuffer().rewind());
        outputs.put(1, output1.getBuffer().rewind());

        long prepareInput = SystemClock.uptimeMillis();
        ByteBuffer[] inputs = new ByteBuffer[1];
        inputs[0] = inputImageBuffer.getBuffer();

        long startReference = SystemClock.uptimeMillis();
        tflite.runForMultipleInputsOutputs(inputs, outputs);

        long endTimeForReference = SystemClock.uptimeMillis();
        Trace.endSection();
        List<Detection> detections = new ArrayList<>();
        List<Detection> _detections = new ArrayList<>();
        try {
            float[] regression = output0.getFloatArray();
            float[] classificators = output1.getFloatArray();
            detections = UtilsFace.process(
                    options,
                    classificators,
                    regression,
                    _andchors);
            _detections = UtilsFace.origNms(detections, 0.3f, bitmap.getWidth(), bitmap.getHeight());
        } catch (Exception e) {
            System.out.println("\nException Thrown : " + e);
        }
        return _detections;
    }

    /**
     * Runs inference and returns the classification results.
     */
    public List<Detection> detectFaceBack(final Bitmap bitmap, int sensorOrientation, boolean reverseOutputOrder,
            boolean flipVertically, float ratio) {
        OptionsFace options = new OptionsFace(
                1,
                896,
                16,
                4,
                new ArrayList<Integer>(),
                100.0f,
                0.8f,
                6,
                2,
                reverseOutputOrder,
                0,
                256,
                256,
                256,
                256,
                flipVertically);

        AnchorOption anchors = new AnchorOption(
                256,
                256,
                0.1484375f,
                0.75f,
                0.5f,
                0.5f,
                4,
                new ArrayList<Integer>(),
                new ArrayList<Integer>(),
                Arrays.asList(16, 32, 32, 32),
                Arrays.asList(ratio),
                false,
                ratio,
                true);
        List<Anchor> _andchors = UtilsFace.getAnchors(anchors);
        // Logs this method so that it can be analyzed with systrace.
        Trace.beginSection("recognizeImage");
        Trace.beginSection("loadImage");

        long startTimeForLoadImage = SystemClock.uptimeMillis();
        inputImageBuffer = loadImage(bitmap, sensorOrientation);
        long endTimeForLoadImage = SystemClock.uptimeMillis();
        Trace.endSection();

        // Runs the inference call.
        Trace.beginSection("runInference");
        long startTimeForReference = SystemClock.uptimeMillis();
        long initOutput = SystemClock.uptimeMillis();
        Map<Integer, Object> outputs = new HashMap();

        long createOutput = SystemClock.uptimeMillis();
        outputs.put(0, output0.getBuffer().rewind());
        outputs.put(1, output1.getBuffer().rewind());

        long prepareInput = SystemClock.uptimeMillis();
        ByteBuffer[] inputs = new ByteBuffer[1];
        inputs[0] = inputImageBuffer.getBuffer();

        long startReference = SystemClock.uptimeMillis();
        tflite.runForMultipleInputsOutputs(inputs, outputs);

        long endTimeForReference = SystemClock.uptimeMillis();
        Trace.endSection();
        List<Detection> detections = new ArrayList<>();
        List<Detection> _detections = new ArrayList<>();
        try {
            float[] regression = output0.getFloatArray();
            float[] classificators = output1.getFloatArray();
            detections = UtilsFace.process(
                    options,
                    classificators,
                    regression,
                    _andchors);
            _detections = UtilsFace.origNms(detections, 0.3f, bitmap.getWidth(), bitmap.getHeight());
        } catch (Exception e) {
            System.out.println("\nException Thrown : " + e);
        }
        return _detections;
    }

    protected String getModelPath() {
        return "face_detection_back.tflite";
    }

    protected TensorOperator getPreprocessNormalizeOp() {
        return new NormalizeOp(IMAGE_MEAN, IMAGE_STD);
    }

    protected TensorOperator getPreprocessNormalizeOpHubert() {
        return new NormalizeOp(IMAGE_MEAN_Hubert, IMAGE_STD_Hubert);
    }

    protected TensorOperator getPostprocessNormalizeOp() {
        return new NormalizeOp(PROBABILITY_MEAN, PROBABILITY_STD);
    }

}
