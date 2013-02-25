//
//  GAppDelegate.h
//  DarnkessMap
//
//  Created by Emiliano Burgos on 2/23/13.
//  Copyright (c) 2013 Emiliano Burgos. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSString* UID;
@property (nonatomic, retain) NSString* SID;

//@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

//- (BOOL)openURL:(NSURL*)url;
@end
