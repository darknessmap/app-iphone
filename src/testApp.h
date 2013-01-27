#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxiPhoneCoreLocation.h"

class testApp : public ofxiPhoneApp{
	
	public:
    
    // DEFAULTS
        void setup();
        void update();
        void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
    // VIDEO GRABBER FUNCTIONS FROM EXAMPLE
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
    // JAVA DARKNESS MAP TRANSLATION
        void calculateIntensityHistogram(int* rgb, int* histogram, int width, int height, int component);
        void drawBrightnessHistogram(int newImageWidth, int canvasHeight, int marginWidth);
        void _drawBrightnessText(double averageBrightness, int marginWidth);
        void _drawLocationText(double longitude, double latitude, int marginWidth);
        void sendPayload();
        
        void _drawTimeStamp(int marginWidth);
    
        void updateLocation();
        string getTimeStamp();
        string pad(int value);
    
        private GeoPayloadVO _geoVO;
    
        private Properties 	_config;
    
        private Gateway 	_gateway;

    
		ofVideoGrabber grabber;
		ofTexture tex;
		unsigned char * pix;
    
        int* rgbData;
        int* redHistogram;
        int* greenHistogram;
        int* blueHistogram;
        double* binSquared;
    
        int width;
        int height;
        int marginWidth;
        double* brightnessHistory = new double[256];
        int brightnessCounter = 0;
        double _averageBrightness;
    
        int requestUpdateCap = 64;
    
        // font for writing latitude longitude timestamp and brightness info
        ofTrueTypeFont font;
    
        ofxiPhoneCoreLocation * coreLocation;
        bool hasGPS;
        float heading;
    
        // GPS data. (string values were added so not to duplicate on ofToString conversions)
        double latitude;
        double longitude;
        string latitudeStr;
        string longitudeStr;

    
    /**
	 * Used to set the sampling rate
	 * on the GPS provider. Unit milliseconds.
	 * Average human walking speed
	 * ~= 5km/h => 1.4m/s.
	 */
	 int minTime     = 10 * 1000; //14m/s
	/** 
	 * Unit meters.
	 */
	 int minDistance = 14;
};
