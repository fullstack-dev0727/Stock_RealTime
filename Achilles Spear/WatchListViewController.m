//
//  WatchListViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "WatchListViewController.h"
#import "BaseNavigationViewController.h"
#import "Util.h"
#import "HelperMethods.h"
#import "WatchListContentViewController.h"
#import "ProductDetailViewController.h"

@interface WatchListViewController ()

@end

@implementation WatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier: @"watchListMenuViewController"]];
    
    WatchListContentViewController* watchListContentViewController = (WatchListContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"watchListContentViewController"];
    BaseNavigationViewController* centerNav = [[BaseNavigationViewController alloc] initWithRootViewController:watchListContentViewController];
    [self setCenterPanel:centerNav];
    
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

@end
