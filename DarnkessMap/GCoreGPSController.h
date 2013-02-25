//
//  GCoreGPSController.h
//  DarnkessMap
//
//  Created by Emiliano Burgos on 2/23/13.
//  Copyright (c) 2013 Emiliano Burgos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GCoreGPSControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface GCoreGPSController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locMgr;
	id __weak delegate;
}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, weak) id delegate;

@end
