//
//  main.m
//  DarnkessMap
//
//  Created by Emiliano Burgos on 2/23/13.
//  Copyright (c) 2013 Emiliano Burgos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAppDelegate.h"
//#import "GApplicationBase.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc,
                                 argv,
                                 nil,
//                                 NSStringFromClass([GApplicationBase class]),
                                 NSStringFromClass([GAppDelegate class]));
    }
}
