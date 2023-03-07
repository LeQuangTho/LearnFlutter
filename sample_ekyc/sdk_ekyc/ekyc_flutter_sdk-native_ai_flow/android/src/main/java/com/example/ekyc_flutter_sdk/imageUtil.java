package com.example.ekyc_flutter_sdk;

import android.graphics.Bitmap;
import java.lang.Math;
import java.nio.ByteBuffer;

// import java.lang.Object.Rect;
import android.graphics.Rect;

import android.graphics.Color;
import android.util.Log;
import android.graphics.YuvImage;
import android.graphics.ImageFormat;
import android.graphics.Matrix;
import java.io.ByteArrayOutputStream;
import android.graphics.BitmapFactory;

public class imageUtil {
    static int count = 0;

    static Bitmap converYUV420ToRGB(byte[] plane0, byte[] plane1, byte[] plane2, int width, int height,
            int uvRowStride, int uvPixelStride) {
        int imageWidth = width;
        int imageHeight = height;
        Bitmap bitmap = Bitmap.createBitmap(imageWidth, imageHeight, Bitmap.Config.ARGB_8888);
        for (int w = 0; w < imageWidth; w++) {
            for (int h = 0; h < imageHeight; h++) {
                int uvIndex = uvPixelStride * (int) Math.floor(w / 2) + uvRowStride * (int) Math.floor(h / 2);
                final int index = h * imageWidth + w;
                int y = plane0[index] & 0xFF;
                int u = plane1[uvIndex] & 0xFF;
                int v = plane2[uvIndex] & 0xFF;

                int r = (int) Math.round(y + (1.370705 * (v - 128)));
                int g = (int) Math.round(y - (0.698001 * (v - 128)) - (0.337633 * (u - 128)));
                int b = (int) Math.round(y + (1.732446 * (u - 128)));

                // Log.e("converYUV420ToRGB", "converYUV420ToRGB 3");

                r = clamp(r, 0, 255);
                g = clamp(g, 0, 255);
                b = clamp(b, 0, 255);
                // Log.e("converYUV420ToRGB", "converYUV420ToRGB 4");

                bitmap.setPixel(w, h, Color.argb(255, r, g, b));
                // bitmap.setPixel(w, h, Color.argb(255, 0, 0, 0));
                // Log.e("converYUV420ToRGB", "converYUV420ToRGB 5");
            }
        }
        return bitmap;
    }

    public static int clamp(int val, int min, int max) {
        return Math.max(min, Math.min(max, val));
    }

    static Bitmap toYuvImage(byte[] plane0, byte[] plane1, byte[] plane2, int width, int height,
            int uvRowStride, int uvPixelStride, int yRowStride, int yPixelStride) {

        // Order of U/V channel guaranteed, read more:
        // https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888
        // Plane yPlane = image.getPlanes()[0];
        // Plane uPlane = image.getPlanes()[1];
        // Plane vPlane = image.getPlanes()[2];

        ByteBuffer yBuffer = ByteBuffer.wrap(plane0);
        ByteBuffer uBuffer = ByteBuffer.wrap(plane1);
        ByteBuffer vBuffer = ByteBuffer.wrap(plane2);

        // Full size Y channel and quarter size U+V channels.
        int numPixels = (int) (width * height * 1.5f);
        byte[] nv21 = new byte[numPixels];
        int index = 0;

        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                nv21[index++] = yBuffer.get(y * yRowStride + x * yPixelStride);
            }
        }

        // Copy VU data; NV21 format is expected to have YYYYVU packaging.
        // The U/V planes are guaranteed to have the same row stride and pixel stride.
        int uvWidth = width / 2;
        int uvHeight = height / 2;

        for (int y = 0; y < uvHeight; ++y) {
            for (int x = 0; x < uvWidth; ++x) {
                int bufferIndex = (y * uvRowStride) + (x * uvPixelStride);
                // V channel.
                nv21[index++] = vBuffer.get(bufferIndex);
                // U channel.
                nv21[index++] = uBuffer.get(bufferIndex);
            }
        }

        try {
            YuvImage img = new YuvImage(
                    nv21, ImageFormat.NV21, width, height, /* strides= */ null);
            Rect rect = new Rect(0, 0, width, height);
            ByteArrayOutputStream stream = new ByteArrayOutputStream();
            img.compressToJpeg(rect, 100, stream);
            Bitmap bitmap = BitmapFactory.decodeByteArray(stream.toByteArray(), 0, stream.size());
            if (bitmap == null)
                return null;
            stream.close();
            return bitmap;
        } catch (Exception ex) {
            Log.e("Camera PreviewFrame", "Error:" + ex.getMessage());
        }
        return null;
    }
}
