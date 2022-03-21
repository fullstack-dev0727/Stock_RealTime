//
//  MainViewController.h
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "JASidePanelController.h"
#import "NewsViewController.h"
#import "FavouriteViewController.h"
#import "CategoryViewController.h"
#import "WatchListViewController.h"
#import "MenuViewController.h"
#import "SettingViewController.h"

@interface MainViewController : JASidePanelController <UIAlertViewDelegate> {
    NSTimer *idleTimer;
}
@property (strong, nonatomic) MenuViewController* menuViewController;
@property (strong, nonatomic) NewsViewController* newsViewController;
@property (strong, nonatomic) CategoryViewController* categoryViewController;
@property (strong, nonatomic) FavouriteViewController* favouriteViewController;
@property (strong, nonatomic) WatchListViewController* watchlistViewController;
@property (strong, nonatomic) SettingViewController* settingViewController;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onMenuClick:(id)sender;
- (void) showBackButton:(NSNotification *) notification;
- (void) showMenuButton:(NSNotification *) notification;
- (void) setTitle:(NSNotification *) notification;
- (void) refreshColorTheme:(NSNotification *) notification;
- (void)resetIdleTimer:(NSNotification*) notification;
@end
