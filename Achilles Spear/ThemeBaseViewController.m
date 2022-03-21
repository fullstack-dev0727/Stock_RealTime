//
//  ThemeBaseViewController.m
//  Achilles Spear
//
//  Created by KP on 5/12/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "ThemeBaseViewController.h"
#import "Util.h"
#import "HelperMethods.h"

@interface ThemeBaseViewController ()

@end

@implementation ThemeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor* topColor = [HelperMethods getHightLightColor:[HelperMethods getStuffColor:BACKGROUND]];
    UIColor* bottomColor = [HelperMethods getStuffColor:BACKGROUND];
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    //Add gradient to view
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
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
