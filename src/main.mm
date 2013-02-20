#include "ofMain.h"
#include "SquareApp.h"

int main(){
        
        ofAppiPhoneWindow *window = new ofAppiPhoneWindow();
        ofSetupOpenGL(ofPtr<ofAppBaseWindow>(window), 1024,768, OF_FULLSCREEN);
        window->startAppWithDelegate("MyAppDelegate");

}
