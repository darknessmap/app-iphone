//
//  GFirstViewController.m
//  DarnkessMap
//
//  Created by Emiliano Burgos on 2/23/13.
//  Copyright (c) 2013 Emiliano Burgos. All rights reserved.
//

#import "GAboutViewController.h"

@interface GAboutViewController ()

@end

@implementation GAboutViewController

@synthesize textViewOutlet;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    textViewOutlet.dataDetectorTypes = UIDataDetectorTypeLink;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTextViewOutlet:nil];
    [super viewDidUnload];
}
@end
