//
//  AppDelegate.h
//  Achilles Spear
//
//  Created by KP on 1/26/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) MainViewController *mainVC;
@property (strong, nonatomic) UIWindow *window;
@end

