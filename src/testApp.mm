#include "testApp.h"

//good reference of other OF iPhone app that uses coreLocation:
// https://github.com/trentbrooks/AntiMap/blob/master/AntiMapLog/Openframeworks-iPhone/AntiMapLog/src/AntiMapLog.mm


//--------------------------------------------------------------
void testApp::setup(){
    
    // dump lots of info to console (useful for debugging)
	ofSetLogLevel(OF_LOG_VERBOSE);
    
	//ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);

	ofSetFrameRate(30);
    
    // load font for displaying info
	font.loadFont("verdana.ttf", 12, true, true);
    font.setLineHeight(18.0f);
	font.setLetterSpacing(1.027);
    
    // DEFAULT properties (can't set from header, boooo!)
    // gps + compass
    latitude = 0;
    longitude = 0;
    latitudeStr = "0.000000";
    longitudeStr = "0.000000";

    // setup sensors
    ofRegisterTouchEvents(this);
    ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    coreLocation = new ofxiPhoneCoreLocation();
    hasGPS = coreLocation->startLocation();
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
    ofxiPhoneDisableIdleTimer(); // disable phone sleep
    printf("\nPhone: %s\n", iPhoneGetDeviceRevision().c_str());
    
    //VidGrabber setup
	grabber.initGrabber(480, 360, OF_PIXELS_BGRA);
	tex.allocate(grabber.getWidth(), grabber.getHeight(), GL_RGB);
    
    width = grabber.getWidth();
    height = grabber.getHeight();
	
	pix = new unsigned char[ (int)( width * height * 3.0) ];
}

//--------------------------------------------------------------
void testApp::update(){
	ofBackground(255,255,255);	
	
	grabber.update();
	
	unsigned char * src = grabber.getPixels();
	int totalPix = grabber.width * grabber.height * 3;
	
    //VideoGrabberExample Code
   
    //Find amount of Red, Green and Blue pixel values
    long double redVals = 0.0;
    long double blueVals = 0.0;
    long double greenVals = 0.0;
    
	for(int k = 0; k < totalPix; k+= 3){
		
        // redValues
        redVals += src[k];
        
        // green values
        greenVals += src[k+1];
        
        // blue values
        blueVals += src[k+2];
	}
    

    //Calculate Mean
    double imageRedMean 	= 0, imageGreenMean    = 0, imageBlueMean    = 0;
    
    int pixPerFrame = width*height;
    
    imageRedMean = redVals/pixPerFrame;
    imageGreenMean = greenVals/pixPerFrame;
    imageBlueMean = blueVals/pixPerFrame;

    
    //JAVA CODE
    
    // Calculate histogram
    //calculateIntensityHistogram(rgbData, redHistogram,  width, height, 0);
    //calculateIntensityHistogram(rgbData, greenHistogram,width, height, 1);
    //calculateIntensityHistogram(rgbData, blueHistogram, width, height, 2);
    
    // Calculate mean
    //double imageRedMean 	= 0, imageGreenMean    = 0, imageBlueMean    = 0;
    //double redHistogramSum  = 0, greenHistogramSum = 0, blueHistogramSum = 0;
    /*
    for (int bin = 0; bin < 256; bin++)
    {
        imageRedMean      += redHistogram[bin] * bin;
        redHistogramSum   += redHistogram[bin];
        
        imageGreenMean 	  += greenHistogram[bin] * bin;
        greenHistogramSum += greenHistogram[bin];
        
        imageBlueMean 	  += blueHistogram[bin] * bin;
        blueHistogramSum  += blueHistogram[bin];
    } // bin
    
    imageRedMean   /= redHistogramSum;
    imageGreenMean /= greenHistogramSum;
    imageBlueMean  /= blueHistogramSum;
     */
    
    //Calculate averageBrightness -- How to do this the best way?
    _averageBrightness = 0;
    
    //_averageBrightness = (imageRedMean + imageGreenMean + imageBlueMean) / 3;
    
    //Let's use RGB -> Luma, using Y = 0.375 R + 0.5 G + 0.125 B, we have a quick way out: Y = (R+R+B+G+G+G)/6
    //Is this still relevant for OF and iPhone?
    _averageBrightness = ((imageRedMean*2)+imageBlueMean+(imageGreenMean*3))/6;
    
    brightnessHistory[brightnessCounter%256] = _averageBrightness; // why do a modulo of 256?
    brightnessCounter++;
     
}

//--------------------------------------------------------------
void testApp::draw(){	
	
	ofSetColor(255);
	grabber.draw(0, 0);
	    
    //JAVA
    // Draw Location
    _drawLocationText(longitude, latitude, marginWidth);
    
    // Draw Time and AverageBrightness Value
    _drawBrightnessText(_averageBrightness, marginWidth);
    
    // Draw brightness histogram
    drawBrightnessHistogram(width, height, marginWidth);
}

//--------------------------------------------------------------
void testApp::calculateIntensityHistogram(int* rgb, int* histogram, int width, int height, int component){
    
    for (int bin = 0; bin < 256; bin++) { // for Android the bin value is 256, what is it for iPhone?
        histogram[bin] = 0;
    } //bin
    
    if(component == 0) // red
    {
        for(int pix = 0; pix < width*height; pix += 3)
        {
            int pixVal = (rgb[pix] >> 16) & 0xff;
            histogram[ pixVal ]++;
        } // pix
    }
    else if (component == 1) // green
    {
        for (int pix = 0; pix < width*height; pix += 3)
        {
            int pixVal = (rgb[pix] >> 8) & 0xff;
            histogram[ pixVal ] ++;
        } // pix
    }
    else // blue
    {
        for(int pix = 0; pix < width*height; pix += 3)
        {
            int pixVal = rgb[pix] & 0xff;
            histogram[ pixVal ]++;
        } // pix
    }
    
}

//--------------------------------------------------------------
void testApp::drawBrightnessHistogram(int width, int height, int marginWidth) {
    float barWidth = ((float)width / 256);
    // float barMarginHeight = 2;

    for (int bin = 0; bin < 256; bin++)
    {
        if (brightnessHistory[bin] != 0)
        //if (_averageBrightness != 0)
        {
            //ofSetColor(255, (int)brightnessHistory[bin], (int)brightnessHistory[bin], (int)brightnessHistory[bin]);
            ofSetColor((int)brightnessHistory[bin]);
            ofRect(bin%width, height - 100, 2, 100);
        }
    }
}

//--------------------------------------------------------------
// timestamp help
string testApp::getTimeStamp()
{
    string theYear = ofToString(ofGetYear()).substr(2); // just get the last 2 digits of the year (2011 > 11)
    return pad(ofGetMonth()) + "-" + pad(ofGetDay()) + "-" +  theYear + " " + pad(ofGetHours()) + ":" + pad(ofGetMinutes()) + ":" + pad(ofGetSeconds());
}

//--------------------------------------------------------------
// adds a leading zero
string testApp::pad(int value)
{
    if(value < 10) return "0" + ofToString(value);
    
    return ofToString(value);
}

//--------------------------------------------------------------
/**
 *
 * @param canvas
 * @param averageBrightness
 * @param marginWidth
 */
void testApp::_drawTimeStamp(int marginWidth) {

    //string TimeBrightness = "Time: "+ ofToString(ofGetTimestampString()) + " Brightness: " + ofToString(averageBrightness);
    string TimeBrightness = "Time: " + ofToString(getTimeStamp());
    ofSetColor(0, 0, 0); // rgb value for black
    font.drawString(TimeBrightness, marginWidth + 10-1, 60-1);
    font.drawString(TimeBrightness, marginWidth + 10+1, 60-1);
    font.drawString(TimeBrightness, marginWidth + 10+1, 60+1);
    font.drawString(TimeBrightness, marginWidth + 10-1, 60+1);
    ofSetColor(255, 255, 0); // rgb value for yellow;
    font.drawString(TimeBrightness, marginWidth + 10,   60);
}


//--------------------------------------------------------------
/**
 *
 * @param canvas
 * @param averageBrightness
 * @param marginWidth
 */
void testApp::_drawBrightnessText(double averageBrightness, int marginWidth) {
    
    // Translate from Java
    //string TimeBrightness = "Time: "+ ofToString(ofGetTimestampString()) + " Brightness: " + ofToString(averageBrightness);
    string TimeBrightness = "Time: " + ofToString(getTimeStamp()) + " Brightness: " + ofToString(averageBrightness);
    ofSetColor(0, 0, 0); // rgb value for black
    font.drawString(TimeBrightness, marginWidth + 10-1, 60-1);
    font.drawString(TimeBrightness, marginWidth + 10+1, 60-1);
    font.drawString(TimeBrightness, marginWidth + 10+1, 60+1);
    font.drawString(TimeBrightness, marginWidth + 10-1, 60+1);
    ofSetColor(255, 255, 0); // rgb value for yellow;
    font.drawString(TimeBrightness, marginWidth + 10,   60);
}

//--------------------------------------------------------------
/**
 *
 * @param canvas
 * @param longitude
 * @param latitude
 * @param marginWidth
 */
void testApp::_drawLocationText(double longitude, double latitude, int marginWidth) {
    
    //Translate from Java
    string LocationValues = "Lat: " + latitudeStr + " Long: " + longitudeStr;
    ofSetColor(0, 0, 0); // rgb value for black
    font.drawString(LocationValues, marginWidth + 10-1, 30-1);
    font.drawString(LocationValues, marginWidth + 10+1, 30-1);
    font.drawString(LocationValues, marginWidth + 10+1, 30+1);
    font.drawString(LocationValues, marginWidth + 10-1, 30+1);
    ofSetColor(255, 255, 0); // rgb value for yellow
    font.drawString(LocationValues, marginWidth + 10,   30);
}

//--------------------------------------------------------------
/**
 * We hit the DB with the geo info and the payload (av. brightness)
 * It should happen every time the location changes. Also, we can
 * request updates periodically (i.e every x frames.)
 */
void testApp::sendPayload() {
    printf("Sending payload");
    
    //TODO: We need to include frame brightness avg as payload.
    //double payload = mDrawOnTop.getAverageBrightness();
    //_geoVO.setPayload(payload);
    //_gateway.publish(_geoVO.toJson());

}

//--------------------------------------------------------------
/**
 * Initialize payload object. Set unique app/device id and
 * the sessions id.
 */
void testApp::_createPayload()
{
    //_geoVO = new GeoPayloadVO();
    //String sid = Session.id();
    //String uid = Installation.id(this.getBaseContext());
    //_geoVO.setSid(sid);
    //_geoVO.setUid(uid);
}

//--------------------------------------------------------------

void testApp::_createGateway() {
    
    //String api = _config.getProperty("API");
    //_gateway = new Gateway();
    //_gateway.setUrl(api);
    //_gateway.initialize();
    
}

//--------------------------------------------------------------
//Gets GPS data
void testApp::updateLocation() {
    if (hasGPS) {
        latitude = coreLocation->getLatitude();
        longitude = coreLocation->getLongitude();
        latitudeStr = ofToString(latitude, 6);
        longitudeStr = ofToString(longitude, 6);
    }
}

//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}


