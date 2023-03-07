package com.example.ekyc_flutter_sdk;

import java.util.List;

public class OptionsFace {
    public int numClasses;
    public int numBoxes;
    public int numCoords;
    public int keypointCoordOffset;
    public List<Integer> ignoreClasses;
    public float scoreClippingThresh;
    public float minScoreThresh;
    public int numKeypoints = 0;
    public int numValuesPerKeypoint = 2;
    public int boxCoordOffset = 0;
    public float xScale = 0.0f;
    public float yScale = 0.0f;
    public float wScale = 0.0f;
    public float hScale = 0.0f;
    public Boolean applyExponentialOnBoxSize = false; // change
    public Boolean reverseOutputOrder = true;
    public Boolean sigmoidScore = true;
    public Boolean flipVertically = false;

    public OptionsFace(int numClasses,
            int numBoxes,
            int numCoords,
            int keypointCoordOffset,
            List<Integer> ignoreClasses,
            float scoreClippingThresh,
            float minScoreThresh,
            int numKeypoints,
            int numValuesPerKeypoint,
            Boolean reverseOutputOrder,
            int boxCoordOffset,
            float xScale,
            float yScale,
            float wScale,
            float hScale,
            boolean flipVertically) {
        this.numClasses = numClasses;
        this.numBoxes = numBoxes;
        this.numCoords = numCoords;
        this.keypointCoordOffset = keypointCoordOffset;
        this.ignoreClasses = ignoreClasses;
        this.scoreClippingThresh = scoreClippingThresh;
        this.minScoreThresh = minScoreThresh;
        this.numKeypoints = numKeypoints;
        this.numValuesPerKeypoint = numValuesPerKeypoint;
        this.reverseOutputOrder = reverseOutputOrder;
        this.boxCoordOffset = boxCoordOffset;
        this.xScale = xScale;
        this.yScale = yScale;
        this.wScale = wScale;
        this.hScale = hScale;
        this.flipVertically = flipVertically;
    }
}
