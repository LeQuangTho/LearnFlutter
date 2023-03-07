package com.example.ekyc_flutter_sdk;

import java.util.List;

public class AnchorOption {
    public int inputSizeWidth;
    public int inputSizeHeight;
    public float minScale;
    public float maxScale;
    public float anchorOffsetX;
    public float anchorOffsetY;
    public int numLayers;
    public List<Integer> featureMapWidth;
    public List<Integer> featureMapHeight;
    public List<Integer> strides;
    public List<Float> aspectRatios;
    public boolean reduceBoxesInLowestLayer;
    public float interpolatedScaleAspectRatio;
    public boolean fixedAnchorSize;

    public int getStridesSize() {
        return strides.size();
    }

    public int getFeatureMapHeightSize() {
        return featureMapHeight.size();
    }

    public int getFeatureMapWidthSize() {
        return featureMapWidth.size();
    }

    public AnchorOption(int inputSizeWidth,
            int inputSizeHeight,
            float minScale,
            float maxScale,
            float anchorOffsetX,
            float anchorOffsetY,
            int numLayers,
            List<Integer> featureMapWidth,
            List<Integer> featureMapHeight,
            List<Integer> strides,
            List<Float> aspectRatios,
            boolean reduceBoxesInLowestLayer,
            float interpolatedScaleAspectRatio,
            boolean fixedAnchorSize) {
        this.inputSizeWidth = inputSizeWidth;
        this.inputSizeHeight = inputSizeHeight;
        this.minScale = minScale;
        this.maxScale = maxScale;
        this.anchorOffsetX = anchorOffsetX;
        this.anchorOffsetY = anchorOffsetY;
        this.numLayers = numLayers;
        this.featureMapWidth = featureMapWidth;
        this.featureMapHeight = featureMapHeight;
        this.strides = strides;
        this.aspectRatios = aspectRatios;
        this.reduceBoxesInLowestLayer = reduceBoxesInLowestLayer;
        this.interpolatedScaleAspectRatio = interpolatedScaleAspectRatio;
        this.fixedAnchorSize = fixedAnchorSize;
    }
}
