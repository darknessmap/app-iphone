//
//  GSecondViewController.m
//  DarnkessMap
//
//  Created by Emiliano Burgos on 2/23/13.
//  Copyright (c) 2013 Emiliano Burgos. All rights reserved.
//

#import "GDarknessMapViewController.h"
#import "GPayload.h"
#import "GServiceGateway.h"
#import "GPUImage.h"
#import "GGPUImageLuminosityExtractor.h"
#import "GAppDelegate.h"

@interface GDarknessMapViewController ()

@end



@implementation GDarknessMapViewController

@synthesize locLabel;
@synthesize timeLabel;
@synthesize lumiLabel;
@synthesize CLController;
@synthesize location, payloadObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Fire location shait.
	CLController = [[GCoreGPSController alloc] init];
	CLController.delegate = self;
	[CLController.locMgr startUpdatingLocation];
    
    //uh?
    NSLog(@"view did fucking load");
    
    [self setupVideoCamera];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [videoCamera startCameraCapture];
}

-(void) setupVideoCamera
{
    //TODO: WE NEED THE CAMERA TO FILL PARENT CONTAINER FOR ALL DEVICES...
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh  cameraPosition:AVCaptureDevicePositionBack];
    
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    filter = [[GGPUImageLuminosityExtractor alloc] init];

    [videoCamera addTarget:filter];
    
    GPUImageView *filterView = (GPUImageView *) self.view;
    
    [filter addTarget:filterView];
    
    [videoCamera startCameraCapture];
    
    //More fucking hoops, to retain our block...AND to have access to the context.
    //REALLY FUCKING REALLY?!
    __weak typeof(self) weakSelf = self;
    callbackBlock = ^(CGFloat luminosity, CMTime frameTime) {
        typeof(self) strongSelf = weakSelf;
        strongSelf.luminosity = [NSNumber numberWithFloat:luminosity];
        //strongSelf.lumiLabel.text = [NSString stringWithFormat:@"Brightness: %f", luminosity];
//        NSLog(@"we are fucking here: %f", luminosity);
    };
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateLabelTimer:) userInfo:nil repeats:YES];
    
    [(GGPUImageLuminosityExtractor *)filter setLuminosityCallbackBlock:callbackBlock];
    
    /*
    double delayToStartRecording = 0.5;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
    dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Start recording");
        
        
        
        double delayInSeconds = 10.0;
        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            
                        NSLog(@"Movie completed");
            
        });
    });
    */

}
- (void)updateLabelTimer:(NSTimer *)timer
{
    self.lumiLabel.text = [NSString stringWithFormat:@"Brightness: %@", self.luminosity];
}

- (void)locationUpdate:(CLLocation *)aLocation {
    
    self.location = aLocation;
    
    double latDouble = [self.location coordinate].latitude;
    double lonDouble = [self.location coordinate].longitude;
    
	locLabel.text = [NSString stringWithFormat:@"Lat: %f Lon: %f", latDouble, lonDouble];
    
    
    //TODO: Format timestamp for display?
    NSDate *date = [self.location timestamp];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSInteger timestamp = round(interval);
    
    timeLabel.text = [NSString stringWithFormat:@"Time: %ld", (long)timestamp];
    
    
    NSNumber* lon = [NSNumber numberWithDouble:latDouble];
    NSNumber* lat = [NSNumber numberWithDouble:lonDouble];
    
    //TODO: get actual values...
    
    NSString* uid = [(GAppDelegate *)[[UIApplication sharedApplication] delegate] UID];
    NSString* sid = [(GAppDelegate *)[[UIApplication sharedApplication] delegate] SID];
    
    GPayload* payload = [[GPayload alloc] initWithUid:uid sid:sid];
    
    NSDictionary* loc = [NSDictionary dictionaryWithObjectsAndKeys:lon,@"lon", lat, @"lat",nil];
    
    [payload setPayload:self.luminosity
             location:loc
             timestamp:&timestamp];
    
    payloadObject = [NSMutableDictionary dictionary];
    
    NSString* json = [payload getAsJsonString:payloadObject];
    
    NSLog(@"fuck: %@", json);
   
    
    GServiceGateway* gateway = [[GServiceGateway alloc] init];
    
    //TODO: Get the IP/end point url from a config file :)http://localhost:9090/api/darkness
    NSString* url = @"http://178.79.145.84:8080/api/darkness";
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:json,@"data", nil];
    
    [gateway connectionPOST:url withParams:data];
    
}

- (void)locationError:(NSError *)error {
	locLabel.text = [error description];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Note: I needed to stop camera capture before the view went off the screen in order to prevent a crash from the camera still sending frames
    [videoCamera stopCameraCapture];
    
	[super viewWillDisappear:animated];
}


@end
