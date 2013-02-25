#include "DarknessMapApp.h"


//--------------------------------------------------------------
//DarknessMapApp :: DarknessMapApp(ofVideoGrabber *globalGrabber) {
DarknessMapApp :: DarknessMapApp() {
    cout << "creating DarknessMapApp" << endl;
    
}

//--------------------------------------------------------------
DarknessMapApp :: ~DarknessMapApp() {
    cout << "destroying DarknessMapApp" << endl;
}

//--------------------------------------------------------------
void DarknessMapApp::setup() {
	ofSetLogLevel(OF_LOG_VERBOSE);
    
	ofSetFrameRate(30);
    
    // load font for displaying info
	font.loadFont("fonts/AvenirNext.ttc", 14, true, true);
    font.setLineHeight(18.0f);
	font.setLetterSpacing(1.027);
    

    
    // DEFAULT properties (can't set from header, boooo!)
    // gps + compass
    latitude = 0.0;
    longitude = 0.0;
    latitudeStr = "0.000000";
    longitudeStr = "0.000000";
    
    // setup sensors
    ofRegisterTouchEvents(this);
    ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
    coreLocation = new ofxiPhoneCoreLocation();
    hasGPS = coreLocation->startLocation();
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
    ofxiPhoneDisableIdleTimer(); // disable phone sleep
    printf("\nPhone: %s\n", iPhoneGetDeviceRevision().c_str());
    
    //VidGrabber setup
	//grabber.initGrabber(480, 360, OF_PIXELS_BGRA);
    //grabber.initGrabber(480, 360, OF_PIXELS_BGRA);
    grabber.initGrabber(480, 360);
    //grabber.setUseTexture(false);
    
    //width = grabber.getWidth();
    //height = grabber.getHeight();
    
    width = ofGetWidth();
    height = ofGetHeight();
    canvasWidth = width;
    canvasHeight = 100;
    
    //Darkness Map Website Button
    rect.set(0, 100, 0, height - 50);
    
    //pixel array to store brightness data
    brightnessHistory = new double[histogramWidth];
	pix = new unsigned char[ (int)( width * height * 3.0) ];
    
    canvas.allocate(canvasWidth, canvasHeight, GL_RGBA);
    canvasPixels = new unsigned char [canvasWidth * canvasHeight * 4];
    
    //set canvas (for histogram) pixels to alpha initially
    for(int i = 0; i < canvasWidth; i++) {
        for(int j = 0; j < canvasHeight; j++) {
            canvasPixels[( j*canvasWidth + i)*4 + 0] = 0;
            canvasPixels[( j*canvasWidth + i)*4 + 1] = 0;
            canvasPixels[( j*canvasWidth + i)*4 + 2] = 0;
            canvasPixels[( j*canvasWidth + i)*4 + 3] = 0;
            
        }
    }
    
    canvas.loadData(canvasPixels, canvasWidth, canvasHeight, GL_RGBA);
    
}

//--------------------------------------------------------------
void DarknessMapApp::update(){
	//ofBackground(255,255,255);
	
	grabber.update();
    
    if( grabber.isFrameNew()) {
        updateLocation();
        
        unsigned char * src = grabber.getPixels();
        int totalPix = grabber.getWidth() * grabber.getHeight() * 3;
        
        //VideoGrabberExample Code
        
        //1. Find amount of Red, Green and Blue pixel values
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
        
        
        //2. Calculate Mean
        double imageRedMean 	= 0, imageGreenMean    = 0, imageBlueMean    = 0;
        
        int pixPerFrame = width*height;
        
        imageRedMean = redVals/pixPerFrame;
        imageGreenMean = greenVals/pixPerFrame;
        imageBlueMean = blueVals/pixPerFrame;
        
        //3. Calculate averageBrightness -- How to do this the best way?
        _averageBrightness = 0;
        
        //_averageBrightness = (imageRedMean + imageGreenMean + imageBlueMean) / 3;
        
        //Let's use RGB -> Luma, using Y = 0.375 R + 0.5 G + 0.125 B, we have a quick way out: Y = (R+R+B+G+G+G)/6
        //Is this still relevant for OF and iPhone?
        _averageBrightness = ((imageRedMean*2)+imageBlueMean+(imageGreenMean*3))/6;
        
        // Draw brightness histogram
        drawBrightnessHistogram(_averageBrightness, width, height, marginWidth);
        
    }
}

//--------------------------------------------------------------
void DarknessMapApp::draw(){
	
	//ofSetColor(255);
	grabber.draw(0, 0, width, height);
    
    ofEnableAlphaBlending();
    canvas.draw(0, height - canvasHeight, canvasWidth, canvasHeight);
    ofDisableAlphaBlending();
    
    //JAVA
    // Draw Location
    _drawLocationText();
    
    // Draw Time and AverageBrightness Value
    _drawTimeStamp(marginWidth);
    _drawBrightnessText(_averageBrightness, marginWidth);
    
    
}

//--------------------------------------------------------------
void DarknessMapApp::drawBrightnessHistogram(double averageBrightness, int width, int height, int marginWidth) {
    
    //draw average brightness into canvas
    for(int i = 0; i < canvasHeight; i++) {  //use a pointer instead of pixel array
        
        canvasPixels[( i*canvasWidth + draw_position_x)*4 + 0] = averageBrightness;
        canvasPixels[( i*canvasWidth + draw_position_x)*4 + 1] = averageBrightness;
        canvasPixels[( i*canvasWidth + draw_position_x)*4 + 2] = averageBrightness;
        canvasPixels[( i*canvasWidth + draw_position_x)*4 + 3] = 255;
        
    }
    
    canvas.loadData(canvasPixels, canvasWidth, canvasHeight, GL_RGBA);
    
    draw_position_x++;
    
    if(draw_position_x > canvasWidth) {
        draw_position_x = 0;
    }
    
}

//--------------------------------------------------------------
// timestamp help
string DarknessMapApp::getTimeStamp()
{
    string theYear = ofToString(ofGetYear()).substr(2); // just get the last 2 digits of the year (2011 > 11)
    return pad(ofGetMonth()) + "-" + pad(ofGetDay()) + "-" +  theYear + " " + pad(ofGetHours()) + ":" + pad(ofGetMinutes()) + ":" + pad(ofGetSeconds());
}

//--------------------------------------------------------------
// adds a leading zero
string DarknessMapApp::pad(int value)
{
    if(value < 10) return "0" + ofToString(value);
    
    return ofToString(value);
}

//--------------------------------------------------------------
/**
 *
 * @param canvas
 * @param longitude
 * @param latitude
 * @param marginWidth
 */
void DarknessMapApp::_drawLocationText() {
    
    //Translate from Java
    string LatValues = "Lat: " + latitudeStr;
    string LonValues = "Lon: " + longitudeStr;
    ofPushStyle();
    ofSetColor(0, 0, 0); // rgb value for black
    font.drawString(LatValues, 0 + 10-1, 70-1);
    font.drawString(LatValues, 0 + 10+1, 70-1);
    font.drawString(LatValues, 0 + 10+1, 70+1);
    font.drawString(LatValues, 0 + 10-1, 70+1);
    ofSetColor(255, 255, 0); // rgb value for yellow
    font.drawString(LatValues, 0 + 10,   70);
    ofPopStyle();
    
    ofPushStyle();
    ofSetColor(0, 0, 0); // rgb value for black
    font.drawString(LonValues, 0 + 10-1, 95-1);
    font.drawString(LonValues, 0 + 10+1, 95-1);
    font.drawString(LonValues, 0 + 10+1, 95+1);
    font.drawString(LonValues, 0 + 10-1, 95+1);
    ofSetColor(255, 255, 0); // rgb value for yellow
    font.drawString(LonValues, 0 + 10,   95);
    ofPopStyle();
}

//--------------------------------------------------------------
/**
 *
 * @param canvas
 * @param averageBrightness
 * @param marginWidth
 */
void DarknessMapApp::_drawTimeStamp(int marginWidth) {
    
    //string TimeBrightness = "Time: "+ ofToString(ofGetTimestampString()) + " Brightness: " + ofToString(averageBrightness);
    string Time = "Time: " + ofToString(getTimeStamp());
    ofPushStyle();
    ofSetColor(0, 0, 0); // rgb value for black
    font.drawString(Time, marginWidth + 10-1, 120-1);
    font.drawString(Time, marginWidth + 10+1, 120-1);
    font.drawString(Time, marginWidth + 10+1, 120+1);
    font.drawString(Time, marginWidth + 10-1, 120+1);
    ofSetColor(255, 255, 0); // rgb value for yellow;
    font.drawString(Time, marginWidth + 10,   120);
    ofPopStyle();
}


//--------------------------------------------------------------
/**
 *
 * @param canvas
 * @param averageBrightness
 * @param marginWidth
 */
void DarknessMapApp::_drawBrightnessText(double averageBrightness, int marginWidth) {
    
    // Translate from Java
    string Brightness = "Brightness: " + ofToString(averageBrightness);
    ofPushStyle();
    ofSetColor(0, 0, 0); // rgb value for black
    font.drawString(Brightness, marginWidth + 10-1, 145-1);
    font.drawString(Brightness, marginWidth + 10+1, 145-1);
    font.drawString(Brightness, marginWidth + 10+1, 145+1);
    font.drawString(Brightness, marginWidth + 10-1, 145+1);
    ofSetColor(255, 255, 0); // rgb value for yellow;
    font.drawString(Brightness, marginWidth + 10,   145);
    ofPopStyle();
}



//--------------------------------------------------------------
/**
 * We hit the DB with the geo info and the payload (av. brightness)
 * It should happen every time the location changes. Also, we can
 * request updates periodically (i.e every x frames.)
 */
void DarknessMapApp::sendPayload() {
    cout << "Sending payload"<< endl;
    
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
void DarknessMapApp::_createPayload()
{
    //_geoVO = new GeoPayloadVO();
    //String sid = Session.id();
    //String uid = Installation.id(this.getBaseContext());
    //_geoVO.setSid(sid);
    //_geoVO.setUid(uid);
}

//--------------------------------------------------------------

void DarknessMapApp::_createGateway() {
    
    //String api = _config.getProperty("API");
    //_gateway = new Gateway();
    //_gateway.setUrl(api);
    //_gateway.initialize();
    
}

//--------------------------------------------------------------
//Gets GPS data
void DarknessMapApp::updateLocation() {
    if (hasGPS) {
        latitude = coreLocation->getLatitude();
        longitude = coreLocation->getLongitude();
        latitudeStr = ofToString(latitude, 6);
        longitudeStr = ofToString(longitude, 6);
    }
}

//--------------------------------------------------------------
void DarknessMapApp::exit(){
    
    grabber.close();
    coreLocation->stopHeading();
    coreLocation = nil;
    canvas.clear();
    
    //grabber = nil;
}

//--------------------------------------------------------------
void DarknessMapApp::touchDown(ofTouchEventArgs & touch){
    rect.inside(touch.x, touch.y);
        
}

//--------------------------------------------------------------
void DarknessMapApp::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void DarknessMapApp::touchUp(ofTouchEventArgs & touch){
  
}

//--------------------------------------------------------------
void DarknessMapApp::touchDoubleTap(ofTouchEventArgs & touch){
}

//--------------------------------------------------------------
void DarknessMapApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void DarknessMapApp::lostFocus(){
    
}

//--------------------------------------------------------------
void DarknessMapApp::gotFocus(){
    
}

//--------------------------------------------------------------
void DarknessMapApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void DarknessMapApp::deviceOrientationChanged(int newOrientation){
    
}

