//
//  SettingHelpViewController.m
//  Achilles Spear
//
//  Created by KP on 2/23/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SettingHelpViewController.h"
#import "Util.h"
#import "MainViewController.h"
#import "HelperMethods.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface SettingHelpViewController ()

@end

@implementation SettingHelpViewController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height);
    [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:@"Setting / Help"];
    [_helpContentTextView setTextColor:[HelperMethods getStuffColor:TEXT]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
