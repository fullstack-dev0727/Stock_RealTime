//
//  BaseViewController.m
//  Achilles Spear
//
//  Created by KP on 2/10/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "AppDelegate.h"
#import "HelperMethods.h"
#import "MainViewController.h"
#import "BaseViewController.h"
#import "Util.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIColor* topColor = UIColorFromRGB(BACKGROUNDCOLOR);
//    UIColor* bottomColor = UIColorFromRGB(BACKGROUNDCOLOR1);
//    // Create the gradient
//    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
//    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
//    theViewGradient.frame = self.view.bounds;
//    //Add gradient to view
//    [self.view.layer insertSublayer:theViewGradient atIndex:0];
//    UIImageView* helmetImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    [helmetImageView setImage:[UIImage imageNamed:@"helmet.png"]];
//    helmetImageView.alpha = 0.05f;
//    [self.view.layer insertSublayer:helmetImageView.layer atIndex:1];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) logout {
    [HelperMethods removeKeyUserPreference:ACCESSTOKEN];
    [HelperMethods removeKeyUserPreference:LOGGEDIN];
    AppDelegate* appDelegate = APPDELEGATE;
    [appDelegate.mainVC performSegueWithIdentifier:@"main_to_login" sender: self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
