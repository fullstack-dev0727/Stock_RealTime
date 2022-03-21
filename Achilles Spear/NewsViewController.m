//
//  NewsViewController.m
//  Achilles Spear
//
//  Created by KP on 2/10/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "NewsViewController.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseNavigationViewController.h"
#import "HelperMethods.h"

@interface NewsViewController ()

@end
static NSString *csrf_cookie;
@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _newsMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"newsMenuViewController"];
    [self setLeftPanel: _newsMenuViewController];
    BaseNavigationViewController* nav = [[BaseNavigationViewController alloc] init];
    [self setCenterPanel:nav];
    self.leftFixedWidth = SUBMENU_WIDTH;
    [self toggleLeftPanel:nil];
    
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)stylePanel:(UIView *)panel {
    [super stylePanel:panel];
    [panel.layer setCornerRadius:0.0f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) backFunc {
    BaseNavigationViewController* centerNav = (BaseNavigationViewController*) self.centerPanel;
    [centerNav popViewControllerAnimated:YES];
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
