//
//  GCoreGPSController.m
//  DarnkessMap
//
//  Created by Emiliano Burgos on 2/23/13.
//  Copyright (c) 2013 Emiliano Burgos. All rights reserved.
//

#import "GCoreGPSController.h"

@implementation GCoreGPSController

@synthesize locMgr, delegate;

- (id)init {
	self = [super init];
    
	if(self != nil) {
        // Create new instance of locMgr
		self.locMgr = [[CLLocationManager alloc] init];
//        self.locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        self.locMgr.purpose = @"Relate darkness average to location.";
//        self.locMgr.distanceFilter = 45;
        self.locMgr.distanceFilter = 0;
        
        // Set the delegate as self.
		self.locMgr.delegate = self;
	}
    
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(GCoreGPSControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(GCoreGPSControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self.delegate locationError:error];
	}
}

@end
