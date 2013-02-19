#include "AboutApp.h"

//--------------------------------------------------------------
AboutApp :: AboutApp () {
    cout << "creating AboutApp" << endl;
}

//--------------------------------------------------------------
AboutApp :: ~AboutApp () {
    cout << "destroying AboutApp" << endl;
}

//--------------------------------------------------------------
void AboutApp::setup() {	
	ofBackground(127);
    
    int fontSize = 14;
    if (ofxiPhoneGetOFWindow()->isRetinaSupported())
        fontSize *= 2;
    
    font.loadFont("fonts/mono0755.ttf", fontSize);
    
    image.loadImage("images/dive.jpg");
}

//--------------------------------------------------------------
void AboutApp::update(){

}

//--------------------------------------------------------------
void AboutApp::draw() {
    int x = (ofGetWidth()  )  * 0.5;
    int y = (ofGetHeight() ) * 0.5;
    int p = 0;
    
	ofSetColor(ofColor::white);
    image.draw(x, y);
    
    x = ofGetWidth()  * 0.2;
    y = ofGetHeight() * 0.11;
    p = ofGetHeight() * 0.035;
    
    ofSetColor(ofColor::white);
    font.drawString("frame num      = " + ofToString( ofGetFrameNum() ),    x, y+=p);
    font.drawString("frame rate     = " + ofToString( ofGetFrameRate() ),   x, y+=p);
    font.drawString("screen width   = " + ofToString( ofGetWidth() ),       x, y+=p);
    font.drawString("screen height  = " + ofToString( ofGetHeight() ),      x, y+=p);
}

//--------------------------------------------------------------
void AboutApp::exit() {
    //
}

//--------------------------------------------------------------
void AboutApp::touchDown(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void AboutApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void AboutApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void AboutApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void AboutApp::lostFocus(){

}

//--------------------------------------------------------------
void AboutApp::gotFocus(){

}

//--------------------------------------------------------------
void AboutApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void AboutApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void AboutApp::touchCancelled(ofTouchEventArgs& args){

}

