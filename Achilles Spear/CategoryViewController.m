//
//  CategoryViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "CategoryMenuViewController.h"
#import "CategoryViewController.h"
#import "CategoryContentViewController.h"
#import "BaseNavigationViewController.h"
#import "Util.h"
#import "MBProgressHUD.h"
#import "HelperMethods.h"


@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BaseNavigationViewController* leftNav = [[BaseNavigationViewController alloc] init];
    [self setLeftPanel:leftNav];
    
    CategoryContentViewController* categoryContentViewController = (CategoryContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"categoryContentViewController"];
    BaseNavigationViewController* centerNav = [[BaseNavigationViewController alloc] initWithRootViewController:categoryContentViewController];
    [self setCenterPanel:centerNav];
    
    self.leftFixedWidth = SUBMENU_WIDTH;
    [self toggleLeftPanel:nil];
    
    NSDictionary* item = [HelperMethods getItemDicMenu:@"c_0"];
    if (item != nil) {
        [self configCategoryMenu:item];
    }
    [self getCategoryMenu];
    
}
- (void) configCategoryMenu:(NSDictionary*) item {
    BaseNavigationViewController* leftNav = (BaseNavigationViewController*) self.leftPanel;
    CategoryMenuViewController* categoryMenuViewController = (CategoryMenuViewController*) [self.storyboard instantiateViewControllerWithIdentifier: @"categoryMenuViewController"];
    [categoryMenuViewController setItemDic:item];
    leftNav.viewControllers = [NSArray arrayWithObject: categoryMenuViewController];
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
    if ([centerNav.viewControllers count] > 1) {
        [centerNav popToRootViewControllerAnimated:NO];
    } else {
        BaseNavigationViewController* leftNav = (BaseNavigationViewController*) self.leftPanel;
        [leftNav popViewControllerAnimated:NO];
    }
    
}
- (void) selectCategory: (NSDictionary*) item {
    BaseNavigationViewController* leftNav = (BaseNavigationViewController*) self.leftPanel;
    CategoryMenuViewController* categoryMenuViewController = (CategoryMenuViewController*) [self.storyboard instantiateViewControllerWithIdentifier: @"categoryMenuViewController"];
    [categoryMenuViewController setItemDic:item];
    [leftNav pushViewController:categoryMenuViewController animated:NO];
}
- (void) popToRootViewController {
    BaseNavigationViewController* leftNav = (BaseNavigationViewController*) self.leftPanel;
    [leftNav popToRootViewControllerAnimated:NO];
    
    BaseNavigationViewController* centerNav = (BaseNavigationViewController*) self.centerPanel;
    [centerNav popToRootViewControllerAnimated:NO];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void) getCategoryMenu {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    [HelperMethods getCategoryMenu:access_token completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    NSString* message = [response objectForKey:@"errors"];
                    if ([message isEqualToString:@"Your session is expired. Please sign in again."]) {
                        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    } else {
                        [HelperMethods showMessage:message];
                    }
                } else {
                    NSArray* data = response[@"data"];
                    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:CATEGORYMENU];
                    [HelperMethods postNotificationWithName:@"refreshMenuList"];
                }
            }
        });
    }];
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
