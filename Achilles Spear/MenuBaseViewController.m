//
//  MenuBaseViewController.m
//  Achilles Spear
//
//  Created by KP on 5/13/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuBaseViewController.h"
#import "HelperMethods.h"
#import "Util.h"

@interface MenuBaseViewController ()

@end

@implementation MenuBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIImageView* lineImageView = (UIImageView*) [self.view viewWithTag:101];
    [lineImageView setBackgroundColor:[HelperMethods getStuffColor:LINE]];
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
