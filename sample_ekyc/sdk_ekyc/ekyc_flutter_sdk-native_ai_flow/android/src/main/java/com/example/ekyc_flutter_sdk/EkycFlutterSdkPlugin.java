package com.example.ekyc_flutter_sdk;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.view.FlutterMain;
import android.graphics.YuvImage;
import java.io.ByteArrayOutputStream;
import android.graphics.BitmapFactory;
import android.graphics.Rect;

import android.os.Environment;
import android.graphics.Color;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.SystemClock;
import android.renderscript.Allocation;
import android.renderscript.Element;
import android.renderscript.RenderScript;
import android.renderscript.ScriptIntrinsicYuvToRGB;
import android.renderscript.Type;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

import org.tensorflow.lite.DataType;
import org.tensorflow.lite.Interpreter;
import org.tensorflow.lite.Tensor;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Vector;
import java.util.logging.LogManager;

import android.util.Log;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import android.os.Handler;
import android.os.HandlerThread;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.core.content.ContextCompat;
import android.Manifest;
import androidx.core.app.ActivityCompat;
import android.content.pm.PackageManager;
import androidx.appcompat.app.AppCompatActivity;
import android.app.Activity;

import org.tensorflow.lite.support.image.TensorImage;
import org.tensorflow.lite.support.image.ImageProcessor;

import org.tensorflow.lite.support.image.ops.ResizeOp;
import org.tensorflow.lite.support.image.ops.ResizeOp.ResizeMethod;
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer;

public class EkycFlutterSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private AssetManager assetManager;
  private Interpreter tfLite;
  private Vector<String> labels;
  private FaceLivenessNet faceLivenessClassifier;
  private CardLivenessNet cardLivenessClassifier;
  private FaceDetection faceDetection;
  private boolean progressDetect = false;
  private Activity activity;

  public static final int MY_PERMISSIONS_WRITE_EXTERNAL_STORAGE = 100;

  private Handler handler;
  private HandlerThread handlerThread;

  float[][] labelProb;
  private boolean tfLiteBusy = false;
  FlutterPluginBinding flutterPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ekyc_flutter_sdk");
    assetManager = flutterPluginBinding.getApplicationContext().getAssets();
    this.flutterPluginBinding = flutterPluginBinding;
    channel.setMethodCallHandler(this);
    initHandler();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("loadModel")) {
      try {
        String res = loadModel((HashMap) call.arguments);
        result.success(res);
      } catch (Exception e) {
        result.error("Failed to load model", e.getMessage(), e);
      }
    } else if (call.method.equals("runFaceValidationOnFrame")) {
      try {
        runFaceValidationOnFrame((HashMap) call.arguments, result);
      } catch (Exception e) {
        result.error("Failed to run model", e.getMessage(), e);
      }
    } else if (call.method.equals("RunCardValidateOnImage")) {
      try {
        RunCardValidateOnImage((HashMap) call.arguments, result);
      } catch (Exception e) {
        result.error("Failed to run model", e.getMessage(), e);
      }
    }
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    this.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    stopHandler();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // TODO: the Activity your plugin was attached to was destroyed to change
    // configuration.
    // This call will be followed by onReattachedToActivityForConfigChanges().
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    // TODO: your plugin is now attached to a new Activity after a configuration
    // change.
  }

  @Override
  public void onDetachedFromActivity() {
    // TODO: your plugin is no longer associated with an Activity. Clean up
    // references.
  }

  private String loadModel(HashMap args) throws IOException {
    String model = args.get("model").toString();
    Object isAssetObj = args.get("isAsset");
    boolean isAsset = isAssetObj == null ? false : (boolean) isAssetObj;
    MappedByteBuffer buffer = null;
    String modelType = args.get("modelType").toString();
    String key = null;

    if (isAsset) {
      key = FlutterMain.getLookupKeyForAsset(model);
      AssetFileDescriptor fileDescriptor = assetManager.openFd(key);
      FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
      FileChannel fileChannel = inputStream.getChannel();
      long startOffset = fileDescriptor.getStartOffset();
      long declaredLength = fileDescriptor.getDeclaredLength();
      buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
    } else {
      FileInputStream inputStream = new FileInputStream(new File(model));
      FileChannel fileChannel = inputStream.getChannel();
      long declaredLength = fileChannel.size();
      buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, 0, declaredLength);
    }

    int numThreads = (int) args.get("numThreads");

    switch (modelType) {
      case "faceLiveness":
        faceLivenessClassifier = new FaceLivenessNet(buffer, FaceLivenessNet.Device.CPU, numThreads);
        break;
      case "faceDetection":
        faceDetection = new FaceDetection(buffer, FaceDetection.Device.CPU, numThreads);
        break;
      case "cardLiveness":
        cardLivenessClassifier = new CardLivenessNet(buffer, CardLivenessNet.Device.CPU, numThreads);
        break;
      default:
        faceLivenessClassifier = new FaceLivenessNet(buffer, FaceLivenessNet.Device.CPU, numThreads);
        break;
    }
    return "success";
  }

  private void RunCardValidateOnImage(HashMap args, Result result) throws IOException {
    ByteBuffer input;
    long startTime;
    runInBackground(() -> {
      if (progressDetect == false) {
        progressDetect = true;
        new CardImageTask((List<Float> livenessResults) -> {
          result.success(livenessResults);
        }).execute((HashMap) args);
      }
    });
  }

  private void runFaceValidationOnFrame(HashMap args, Result result) throws IOException {
    int NUM_RESULTS;
    float THRESHOLD;
    ByteBuffer input;
    long startTime;
    runInBackground(() -> {
      if (progressDetect == false) {
        progressDetect = true;
        new ImageTask((List<Detection> detectionResults, List<Float> livenessResults) -> {
          List<Object> responseResult = new ArrayList<>();
          for (int i = 0; i < detectionResults.size(); i++) {
            Map<String, Object> tmpMap = detectionResults.get(i).toMap();
            tmpMap.put("type", "Detection");
            responseResult.add(tmpMap);
          }
          if (livenessResults == null) {
            Map<String, Object> tmpMap = new HashMap<>();
            tmpMap.put("type", "Liveness");
            tmpMap.put("liveness", "null");
            responseResult.add(tmpMap);
          } else {
            Map<String, Object> tmpMap = new HashMap<>();
            tmpMap.put("type", "Liveness");
            tmpMap.put("liveness", livenessResults);
            responseResult.add(tmpMap);
          }
          result.success(responseResult);
        }).execute((HashMap) args);
      }
    });
  }

  Bitmap convertYuvToBitmapAndCrop(List<byte[]> bytesList, int imageHeight, int imageWidth, float mean, float std,
      int maskLeft, int maskTop, int maskWidth, int maskHeight,
      int rotation) throws IOException {
    ByteBuffer Y = ByteBuffer.wrap(bytesList.get(0));
    ByteBuffer U = ByteBuffer.wrap(bytesList.get(1));
    ByteBuffer V = ByteBuffer.wrap(bytesList.get(2));

    int Yb = Y.remaining();
    int Ub = U.remaining();
    int Vb = V.remaining();

    byte[] data = new byte[Yb + Ub + Vb];

    Y.get(data, 0, Yb);
    V.get(data, Yb, Vb);
    U.get(data, Yb + Vb, Ub);

    Bitmap bitmapRaw = Bitmap.createBitmap(imageWidth, imageHeight, Bitmap.Config.ARGB_8888);
    Allocation bmData = renderScriptNV21ToRGBA888(
        this.flutterPluginBinding.getApplicationContext(),
        imageWidth,
        imageHeight,
        data);
    bmData.copyTo(bitmapRaw);
    // SaveImage(bitmapRaw, String.valueOf(System.currentTimeMillis()) +
    // "_raw.jpg");

    Matrix matrix = new Matrix();
    matrix.postRotate(rotation);
    bitmapRaw = Bitmap.createBitmap(bitmapRaw, maskLeft, maskTop, maskWidth, maskHeight, matrix,
        true);

    return bitmapRaw;
  }

  Bitmap convertYuvToBitmap(List<byte[]> bytesList, int imageHeight, int imageWidth,
      int rotation) throws IOException {
    ByteBuffer Y = ByteBuffer.wrap(bytesList.get(0));
    ByteBuffer U = ByteBuffer.wrap(bytesList.get(1));
    ByteBuffer V = ByteBuffer.wrap(bytesList.get(2));

    int Yb = Y.remaining();
    int Ub = U.remaining();
    int Vb = V.remaining();

    byte[] data = new byte[Yb + Ub + Vb];

    Y.get(data, 0, Yb);
    V.get(data, Yb, Vb);
    U.get(data, Yb + Vb, Ub);

    Bitmap bitmapRaw = Bitmap.createBitmap(imageWidth, imageHeight, Bitmap.Config.ARGB_8888);
    Allocation bmData = renderScriptNV21ToRGBA888(
        this.flutterPluginBinding.getApplicationContext(),
        imageWidth,
        imageHeight,
        data);
    bmData.copyTo(bitmapRaw);
    // SaveImage(bitmapRaw, String.valueOf(System.currentTimeMillis()) +
    // "_raw.jpg");

    Matrix matrix = new Matrix();
    matrix.postRotate(rotation);
    bitmapRaw = Bitmap.createBitmap(bitmapRaw, 0, 0, bitmapRaw.getWidth(), bitmapRaw.getHeight(), matrix,
        true);
    return bitmapRaw;
  }

  public Allocation renderScriptNV21ToRGBA888(Context context, int width, int height, byte[] nv21) {
    // https://stackoverflow.com/a/36409748
    RenderScript rs = RenderScript.create(context);
    ScriptIntrinsicYuvToRGB yuvToRgbIntrinsic = ScriptIntrinsicYuvToRGB.create(rs, Element.U8_4(rs));

    Type.Builder yuvType = new Type.Builder(rs, Element.U8(rs)).setX(nv21.length);
    Allocation in = Allocation.createTyped(rs, yuvType.create(), Allocation.USAGE_SCRIPT);

    Type.Builder rgbaType = new Type.Builder(rs, Element.RGBA_8888(rs)).setX(width).setY(height);
    Allocation out = Allocation.createTyped(rs, rgbaType.create(), Allocation.USAGE_SCRIPT);

    in.copyFrom(nv21);

    yuvToRgbIntrinsic.setInput(in);
    yuvToRgbIntrinsic.forEach(out);
    return out;
  }

  private void SaveImage(Bitmap finalBitmap, String filename) {
    if (ContextCompat.checkSelfPermission(activity,
        Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED
        || ContextCompat.checkSelfPermission(activity,
            Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

      ActivityCompat.requestPermissions(activity,
          new String[] { Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE },
          MY_PERMISSIONS_WRITE_EXTERNAL_STORAGE);

    } else {
      String root = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).toString();

      File myDir = new File(root + "/saved_images");
      myDir.mkdirs();

      String fname = filename;
      File file = new File(myDir, fname);
      if (file.exists())
        file.delete();
      try {
        file.createNewFile();
      } catch (IOException e) {
        e.printStackTrace();
      }
      try {
        FileOutputStream out = new FileOutputStream(file);
        finalBitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
        out.flush();
        out.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }

  private class CardImageTask extends AsyncTask<HashMap, Void, Exception> {
    // private Bitmap bitmap;
    private CardImageResponse cardImageResponse;

    CardImageTask(CardImageResponse cardImageResponse) {
      this.cardImageResponse = cardImageResponse;
    }

    @Override
    protected Exception doInBackground(HashMap... params) {
      HashMap args = params[0];

      byte[] bytesList = (byte[]) args.get("bytesList");
      int imageHeight = (int) args.get("imageHeight");
      int imageWidth = (int) args.get("imageWidth");

      // convert sang bitmap
      Bitmap bmpNew = BitmapFactory.decodeByteArray(bytesList, 0,
          bytesList.length);
      // SaveImage(bmpNew, String.valueOf(System.currentTimeMillis()) + ".jpg");

      // run
      List<Float> cardLivenessResults = cardLivenessClassifier.recognizeImage(bmpNew);
      cardImageResponse.processFinished(cardLivenessResults);
      progressDetect = false;
      return null;
    }

    @Override
    protected void onPostExecute(Exception result) {

    }
  }

  private class ImageTask extends AsyncTask<HashMap, Void, Exception> {
    // private Bitmap bitmap;
    private ImageResponse imageResponse;

    ImageTask(ImageResponse imageResponse) {
      this.imageResponse = imageResponse;
    }

    @Override
    protected Exception doInBackground(HashMap... params) {
      HashMap args = params[0];
      List<byte[]> bytesList = (List<byte[]>) args.get("bytesList");
      int imageHeight = (int) args.get("imageHeight");
      int imageWidth = (int) args.get("imageWidth");
      int sensorOrientation = (int) args.get("sensorOrientation");
      double screenHeight = (double) args.get("screenHeight");
      double screenWidth = (double) args.get("screenWidth");
      double maskLeft = (double) args.get("maskLeft");
      double maskTop = (double) args.get("maskTop");
      double maskWidth = (double) args.get("maskWidth");
      double maskHeight = (double) args.get("maskHeight");
      double sizeAspectRatio = (double) args.get("sizeAspectRatio");

      try {
        /// compute Mask Scale In Real Screen
        double imageAspectRatio;
        double[] scaleList = new double[4];
        int realImageHeight = imageHeight;
        int realImageWidth = imageWidth;

        if ((sensorOrientation / 90) % 2 != 0) {
          // horizontal image
          realImageWidth = imageHeight;
          realImageHeight = imageWidth;
        }

        imageAspectRatio = (double) imageHeight / imageWidth;
        scaleList = computeMaskScale(sizeAspectRatio, imageAspectRatio, realImageWidth, realImageHeight,
            screenHeight, screenWidth,
            maskLeft, maskTop, maskWidth, maskHeight);

        double cardAreaLeftScale = scaleList[0];
        double cardAreaTopScale = scaleList[1];
        double cardAreaWidthScale = scaleList[2];
        double cardAreaHeightScale = scaleList[3];

        int cropLeft = (int) (cardAreaLeftScale * realImageWidth);
        int cropTop = (int) (cardAreaTopScale * realImageHeight);
        int cropWidth = (int) (cardAreaWidthScale * realImageWidth);
        int cropHeight = (int) (cardAreaHeightScale * realImageHeight);

        // if (sensorOrientation == 90) {
        // int tmp = cropLeft;
        // cropLeft = cropTop;
        // cropTop = tmp;
        // tmp = cropWidth;
        // cropWidth = cropHeight;
        // cropHeight = tmp;
        // } else if (sensorOrientation == 270) {
        // int tmpCropTop = cropTop;
        // cropTop = cropLeft;
        // cropLeft = imageWidth - cropHeight - tmpCropTop;
        // int tmpHeight = cropHeight;
        // cropHeight = cropWidth;
        // cropWidth = tmpHeight;
        // }

        /// crop
        // Bitmap rawBitmap = convertYuvToBitmapAndCrop(bytesList, imageHeight,
        /// imageWidth, (float) 127.5, (float) 127.5,
        // cropLeft,
        // cropTop,
        // cropWidth,
        // cropHeight,
        // sensorOrientation);

        Bitmap rawBitmap = convertYuvToBitmap(bytesList, imageHeight, imageWidth, sensorOrientation);

        List<Float> livenessResults = null;
        List<Detection> detectionResults = faceDetection.detectFaceFront(rawBitmap, 0,
            true,
            false,
            1.0f);

        // Log.e("Hubert", "cropWidth: " + cropWidth);
        // Log.e("Hubert", "cropHeight: " + cropHeight);
        if (detectionResults.size() == 1) {
          int xMin = (int) (detectionResults.get(0).xMin * rawBitmap.getWidth());
          int yMin = (int) (detectionResults.get(0).yMin * rawBitmap.getHeight());
          int height = (int) (detectionResults.get(0).height * rawBitmap.getHeight());
          int width = (int) (detectionResults.get(0).width * rawBitmap.getWidth());

          // // add padding
          // cropLeft = cropLeft - 10 > 0 ? cropLeft - 10 : 0;
          // cropTop = cropTop - 10 > 0 ? cropTop - 10 : 0;
          // cropWidth = cropWidth + 20 < rawBitmap.getWidth() ? rawBitmap.getWidth() :
          // cropWidth + 20;
          // cropHeight = cropHeight + 20 < rawBitmap.getHeight() ? rawBitmap.getHeight()
          // : cropHeight + 20;

          // Log.e("Hubert", "cropLeft: " + cropLeft);
          // Log.e("Hubert", "cropTop: " + cropTop);
          // Log.e("Hubert", "cropWidth: " + cropWidth);
          // Log.e("Hubert", "cropHeight: " + cropHeight);

          if (checkFaceInBox(cropLeft, cropTop, cropWidth, cropHeight, xMin, yMin, width, height)) {
            Bitmap cropBitmap = Bitmap.createBitmap(rawBitmap, cropLeft, cropTop,
                cropWidth, cropHeight);
            // run face liveness
            livenessResults = faceLivenessClassifier.recognizeImage(cropBitmap);
            // Log.e("Hubert", "livenessResults.size(): " + livenessResults.size());
          }
        }
        imageResponse.processFinished(detectionResults, livenessResults);
        progressDetect = false;
        return null;

      } catch (Exception e) {
        Log.d("EkycFlutterSdkPlugin", "Failed to convert yuv to bitmap");
        return null;
      }
    }

    @Override
    protected void onPostExecute(Exception result) {

    }
  }

  boolean checkFaceInBox(int boxLeft, int boxTop, int boxWidth, int boxHeight, int faceLeft, int faceTop,
      int faceWidth, int FaceHeight) {
    String tag = "Hubert";
    // Log.e(tag, "boxLeft: " + boxLeft);
    // Log.e(tag, "boxTop: " + boxTop);
    // Log.e(tag, "boxWidth: " + boxWidth);
    // Log.e(tag, "boxHeight: " + boxHeight);
    // Log.e(tag, "faceLeft: " + faceLeft);
    // Log.e(tag, "faceTop: " + faceTop);
    // Log.e(tag, "faceWidth: " + faceWidth);
    // Log.e(tag, "FaceHeight: " + FaceHeight);

    // Log.e(tag, "so sanh ......");
    // Log.e(tag, "faceLeft = " + faceLeft);
    // Log.e(tag, "(boxLeft - boxWidth / 5): " + (boxLeft - boxWidth / 5));

    // Log.e(tag, "faceTop = " + faceTop);
    // Log.e(tag, "(boxTop - boxHeight / 3): " + (boxTop - boxHeight / 3));

    // Log.e(tag, "(faceLeft + faceWidth): " + (faceLeft + faceWidth));
    // Log.e(tag, "boxLeft + boxWidth + 2 * boxWidth / 5): " + (boxLeft + boxWidth +
    // 2 * boxWidth / 5));

    // Log.e(tag, "(faceTop + FaceHeight): " + (faceTop + FaceHeight));
    // Log.e(tag, "boxTop + boxHeight + boxHeight / 5): " + (boxTop + boxHeight +
    // boxHeight / 5));

    // // add padding
    // if (faceLeft >= (boxLeft - boxWidth / 5) && faceTop >= (boxTop - boxHeight /
    // 3)
    // && (faceLeft + faceWidth) <= (boxLeft + boxWidth + 2 * boxWidth / 5)
    // && (faceTop + FaceHeight) <= (boxTop + boxHeight + boxHeight / 5)) {
    // return true;
    // }

    // no padding
    // add padding
    if (faceLeft >= boxLeft && faceTop >= boxTop
        && (faceLeft + faceWidth) <= (boxLeft + boxWidth)
        && (faceTop + FaceHeight) <= (boxTop + boxHeight + boxHeight / 5)) {
      return true;
    }

    // Log.e("Hubert", "checkFaceInBox: false");
    return false;
  }

  double[] computeMaskScale(double sizeAspectRatio, double imageAspectRatio, double imageWidth, double imageHeight,
      double screenHeight, double screenWidth,
      double maskLeft, double maskTop, double maskWidth, double maskHeight) {
    double _cardAreaLeftScale;
    double _cardAreaTopScale;
    double _cardAreaWidthScale;
    double _cardAreaHeightScale;
    double scale = sizeAspectRatio * imageAspectRatio;

    if (scale < 1) {
      // image width fit screen width -> cut image width
      double realImageWidth = (double) (screenHeight * imageWidth) / imageHeight;
      double marginWidth = (double) (realImageWidth - screenWidth);

      _cardAreaLeftScale = (double) ((maskLeft + marginWidth / 2) / realImageWidth);
      _cardAreaTopScale = (double) (maskTop / screenHeight);
      _cardAreaWidthScale = (double) (maskWidth / realImageWidth);
      _cardAreaHeightScale = (double) (maskHeight / screenHeight);
    } else {
      // image height fit screen height -> cut image height
      double realImageHeight = (double) ((screenWidth * imageHeight) / imageWidth);
      double marginHeight = (double) (realImageHeight - screenHeight);

      _cardAreaLeftScale = (double) (maskLeft / screenWidth);
      _cardAreaTopScale = (double) ((maskTop + marginHeight / 2) / realImageHeight);
      _cardAreaWidthScale = (double) (maskWidth / screenWidth);
      _cardAreaHeightScale = (double) (maskHeight / realImageHeight);
    }

    double[] tmp = { _cardAreaLeftScale, _cardAreaTopScale, _cardAreaWidthScale, _cardAreaHeightScale };
    return tmp;
  }

  private interface CardImageResponse {
    void processFinished(List<Float> livenessResults);
  }

  private interface ImageResponse {
    void processFinished(List<Detection> detectionResults, List<Float> livenessResults);
  }

  protected synchronized void runInBackground(final Runnable r) {
    if (handler != null) {
      handler.post(r);
    }
  }

  public void initHandler() {
    handlerThread = new HandlerThread("inference");
    handlerThread.start();
    handler = new Handler(handlerThread.getLooper());
  }

  public void stopHandler() {
    if (handlerThread == null)
      return;
    handlerThread.quitSafely();
    try {
      handlerThread.join();
      handlerThread = null;
      handler = null;
    } catch (final InterruptedException e) {
      e.printStackTrace();
    }
  }
}
