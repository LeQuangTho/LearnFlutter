package com.example.ekyc_flutter_sdk;

import android.graphics.PointF;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Detection {
    public float score;
    public int classID;
    public float xMin;
    public float yMin;
    public float xMax;
    public float yMax;
    public float width;
    public float height;
    public PointF[] landmarks;

    public Detection(float score, int classID, float xMin, float yMin, float width, float height, PointF[] landmarks,
            float xMax, float yMax) {
        this.score = score;
        this.classID = classID;
        this.xMin = xMin;
        this.yMin = yMin;
        this.width = width;
        this.height = height;
        this.landmarks = landmarks;
        this.xMax = xMax;
        this.yMax = yMax;
    }

    Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("score", score);
        map.put("classID", classID);
        map.put("xMin", xMin);
        map.put("yMin", yMin);
        map.put("width", width);
        map.put("height", height);
        map.put("xMax", xMax);
        map.put("yMax", yMax);
        map.put("leftEyeX", landmarks[0].x);
        map.put("leftEyeY", landmarks[0].y);
        map.put("rightEyeX", landmarks[1].x);
        map.put("rightEyeY", landmarks[1].y);
        map.put("noseX", landmarks[2].x);
        map.put("noseY", landmarks[2].y);
        map.put("mouthX", landmarks[3].x);
        map.put("mouthY", landmarks[3].y);
        map.put("leftCheekX", landmarks[4].x);
        map.put("leftCheekY", landmarks[4].y);
        map.put("rightCheekX", landmarks[5].x);
        map.put("rightCheekY", landmarks[5].y);
        return map;
    }
}
