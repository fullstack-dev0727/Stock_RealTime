//
//  SettingViewController.m
//  Achilles Spear
//
//  Created by KP on 3/29/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SettingViewController.h"
#import "BaseNavigationViewController.h"
#import "Util.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier: @"settingMenuViewController"]];
    BaseNavigationViewController* nav = [[BaseNavigationViewController alloc] init];
    [self setCenterPanel:nav];
    self.leftFixedWidth = SUBMENU_WIDTH;
    [self toggleLeftPanel:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)stylePanel:(UIView *)panel {
    [super stylePanel:panel];
    [panel.layer setCornerRadius:0.0f];
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
