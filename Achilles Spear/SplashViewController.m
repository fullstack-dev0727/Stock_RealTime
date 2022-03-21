//
//  SplashViewController.m
//  Achilles Spear
//
//  Created by KP on 4/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SplashViewController.h"
#import "HelperMethods.h"
#import "Util.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3  * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        if ([access_token length] > 0 && [[HelperMethods getUserPreference:LOGGEDIN] isEqualToString:@"1"]) {
//            [self performSegueWithIdentifier:@"tomain" sender: self];
//        } else {
//            [self performSegueWithIdentifier:@"tologin" sender: self];
//        }
//    });
    
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    long startTime = [[HelperMethods getUserPreference:STARTTIME] longValue];
    NSInteger lockTime = [[HelperMethods getUserPreference:LOCKTIME] integerValue];
    if (lockTime != 0 && currentTime - startTime >= lockTime) {
        [HelperMethods removeKeyUserPreference:ACCESSTOKEN];
        [HelperMethods removeKeyUserPreference:LOGGEDIN];
        [HelperMethods setUserPreference:@0 forKey:STARTTIME];
    }

    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_logoImageView setAlpha:0.0f];
        //fade in
        [UIView animateWithDuration:4.0f animations:^{
            [_logoImageView setAlpha:1.0f];
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2  * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if ([access_token length] > 0 && [[HelperMethods getUserPreference:LOGGEDIN] isEqualToString:@"1"]) {
                    [self performSegueWithIdentifier:@"tomain" sender: self];
                } else {
                    [self performSegueWithIdentifier:@"tologin" sender: self];
                }
            });
        }];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
