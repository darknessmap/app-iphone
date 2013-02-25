//
//  MenuViewController.m
//  Created by lukasz karluk on 12/12/11.
//

#import "MyAppViewController.h"


#import "SquareAppViewController.h"
#import "SquareApp.h"

#import "DarknessMapAppViewController.h"
#import "DarknessMapApp.h"

#import "TriangleAppViewController.h"
#import "TriangleApp.h"

#import "AboutAppViewController.h"
#import "AboutApp.h"

#include "AboutAppTest.h"

//#include "ofxiPhone.h"
//#include "ofxiPhoneExtras.h"

//#include "AboutTest.h"

@implementation MyAppViewController

- (UIButton*) makeButtonWithFrame:(CGRect)frame 
                          andText:(NSString*)text {
    UIFont *font;
    font = [UIFont fontWithName:@"Georgia" size:30];
    
    UILabel *label;
    label = [[[ UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
    label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    label.textColor = [UIColor colorWithWhite:0 alpha:1];
    label.text = [text uppercaseString];
    label.textAlignment = UITextAlignmentCenter;
    label.font = font;
    label.userInteractionEnabled = NO;
    label.exclusiveTouch = NO;
    
    UIButton* button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addSubview:label];
    
    return button;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView* backgroundView;
    backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]] autorelease];
    [self.view addSubview: backgroundView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect scrollViewFrame = CGRectMake(0.f,
                                        0.f,
                                        screenRect.size.width,
                                        screenRect.size.height);
    
    UIScrollView* containerView = [[[UIScrollView alloc] initWithFrame:scrollViewFrame] autorelease];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    containerView.showsHorizontalScrollIndicator = NO;
    containerView.showsVerticalScrollIndicator = YES;
    containerView.alwaysBounceVertical = YES;
    [self.view addSubview:containerView];

    NSArray *buttonTitles;
    //buttonTitles = [NSArray arrayWithObjects: @"square", @"launch app", @"view map", @"about", nil];
    //buttonTitles = [NSArray arrayWithObjects: @"launch app", @"view map", @"about", nil];
    buttonTitles = [NSArray arrayWithObjects: @"launch app", @"about", nil];
    
    NSInteger buttonHeight = 70;
    NSInteger buttonY = screenRect.size.height - (buttonHeight*2);     // make room for navigation bar.
    NSInteger buttonGap = 2;
    //NSInteger buttonHeight = (screenRect.size.height - 44) / [buttonTitles count] - buttonGap * ([buttonTitles count] - 1);

    CGRect buttonRect = CGRectMake(0, 0, screenRect.size.width, buttonHeight);
    
    for (int i = 0; i < [buttonTitles count]; i++) {
        UIButton *button;
        button = [self makeButtonWithFrame:CGRectMake(0, buttonY, buttonRect.size.width, buttonRect.size.height)
                                   andText:[buttonTitles objectAtIndex:i]];
        [containerView addSubview:button ];
        
        if (i== 0)
            [button addTarget:self action:@selector(button1Pressed:) forControlEvents:UIControlEventTouchUpInside];
        else if (i==1)
            [button addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
        /*
        else if (i==2)
            [button addTarget:self action:@selector(button3Pressed:) forControlEvents:UIControlEventTouchUpInside];
        else if (i==3)
            [button addTarget:self action:@selector(button4Pressed:) forControlEvents:UIControlEventTouchUpInside];
        */
        buttonY += buttonRect.size.height;
        buttonY += buttonGap;
    }
    
    containerView.contentSize = CGSizeMake(buttonRect.size.width, buttonRect.size.height * 2);
}


- (void)button1Pressed:(id)sender {
    DarknessMapAppViewController *viewController;
//    ofVideoGrabber globalGrabber;
//    ofVideoGrabber* pointerToGrabber = &globalGrabber;
    viewController = [[[DarknessMapAppViewController alloc] initWithFrame:[[UIScreen mainScreen] bounds]
  //                                                               app:new DarknessMapApp(&globalGrabber)] autorelease];
                                                                      app:new DarknessMapApp()] autorelease];
    
    [self.navigationController pushViewController:viewController animated:YES];
    self.navigationController.navigationBar.topItem.title = @"Darkness Map";
}

/*

- (void)button2Pressed:(id)sender {
    AboutAppViewController *viewController;
    viewController = [[[AboutAppViewController alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                                                app:new AboutApp()] autorelease];
    
    [self.navigationController pushViewController:viewController animated:YES];
    self.navigationController.navigationBar.topItem.title = @"About";
}

   */
- (void)button2Pressed:(id)sender {
    AboutAppTest *viewController;
    viewController = [[AboutAppTest alloc] initWithNibName:@"AboutAppTest" bundle:Nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
    self.navigationController.navigationBar.topItem.title = @"About";

}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    BOOL bRotate = NO;
    bRotate = bRotate || (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    bRotate = bRotate || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    return bRotate;
}

@end
