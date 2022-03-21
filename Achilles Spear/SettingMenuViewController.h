//
//  SettingMenuViewController.h
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuBaseViewController.h"

@interface SettingMenuViewController : MenuBaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *settingMenuTableView;
@property (strong, nonatomic) IBOutlet UIView *rootMenuView;
- (void) refreshColorTheme:(NSNotification *) notification;
@end
