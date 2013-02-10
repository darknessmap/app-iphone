#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxiPhoneCoreLocation.h"

#include "ofxAppUtils.h"
#include "Button.h"

class testApp : public ofxApp{
	
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
        void drawBrightnessHistogram(double averageBrightness, int newImageWidth, int canvasHeight, int marginWidth);
        void _drawBrightnessText(double averageBrightness, int marginWidth);
        void _drawLocationText();
        void sendPayload();
        
        void _drawTimeStamp(int marginWidth);
    
        void updateLocation();
        string getTimeStamp();
        string pad(int value);
    
        void _createGateway();
        void _createPayload();
    
    //JAVA classes - translate to Obj-C
        //private GeoPayloadVO _geoVO;
    
        //private Properties 	_config;
    
        //private Gateway     _gateway;

    
		ofVideoGrabber grabber;
		unsigned char * pix;
    
    void calculatePixelAvg();
    
        int* rgbData;
        int* redHistogram;
        int* greenHistogram;
        int* blueHistogram;
        double* binSquared;
    
        int width;
        int height;
        int marginWidth = 0;
    int screenWidth;
    int screenHeight;
    int histogramWidth;
        double* brightnessHistory;
        int brightnessCounter = 0;
        double _averageBrightness;
    int updateCounter = 0;
    
    ofTexture canvas;
    int canvasWidth;
    int canvasHeight;
    unsigned char * canvasPixels;
    int draw_position_x = 0;

    
        int requestUpdateCap = 64;
    
        // font for writing latitude longitude timestamp and brightness info
        ofTrueTypeFont font;
    
        ofxiPhoneCoreLocation * coreLocation;
        bool hasGPS;
    
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
    
    //ofxAppUtils stuff
    // handles the scenes
    ofxSceneManager sceneManager;
    
    // simple scene change gui
    Button prevButton, nextButton;
};
