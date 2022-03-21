//
//  SettingMenuViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SettingMenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "SecretAnswerViewController.h"
#import "SettingAutoLockTimeViewController.h"
#import "SettingColorThemeViewController.h"
#import "SettingHelpViewController.h"
#import "Util.h"
#import "HelperMethods.h"
#import "MainViewController.h"

@interface SettingMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SettingMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [HelperMethods addNotificationObserver:self withName:@"setting_menu_refreshColorTheme" useSelector:@selector(refreshColorTheme:)];
    
    /** set menu layout width */
    _contentView.frame = CGRectMake(0, 0, SUBMENU_WIDTH, self.view.frame.size.height);
    
    /** select first menu item*/
    NSIndexPath *defaultSelectedCell= [NSIndexPath indexPathForRow:0 inSection:0];
    [_settingMenuTableView selectRowAtIndexPath:defaultSelectedCell animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    
    [_settingMenuTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
    
    UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
    [nav pushViewController:[self.storyboard instantiateViewControllerWithIdentifier: @"secretAnswerViewController"] animated:NO];

}
- (void) refreshColorTheme:(NSNotification *) notification {
    [_settingMenuTableView reloadData];
    [_settingMenuTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
    UIImageView* lineImageView = (UIImageView*) [self.view viewWithTag:101];
    [lineImageView setBackgroundColor:[HelperMethods getStuffColor:LINE]];
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

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    _menuItems = @[@"Secret Answer", @"Lock Time", @"Color Theme", @"Help", @"Log out"];
    return _menuItems;
}
#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self menuItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    cell.textLabel.text = menuItem;
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.textLabel.textColor = [HelperMethods getStuffColor:TEXT];
    
    // This is how you change the background color
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [HelperMethods getStuffColor:LINE];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [UIView new];
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    
    switch (indexPath.row) {
        case 0: {
            UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
            [nav pushViewController:[self.storyboard instantiateViewControllerWithIdentifier: @"secretAnswerViewController"] animated:NO];

        }
            break;
        case 1: {
            UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
            [nav pushViewController:[self.storyboard instantiateViewControllerWithIdentifier: @"autoLockTimeViewController"] animated:NO];

        }
            break;
        case 2: {
            UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
            [nav pushViewController:[self.storyboard instantiateViewControllerWithIdentifier: @"colorThemeViewController"] animated:NO];

        }
            break;
        case 3: {
            UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
            [nav pushViewController:[self.storyboard instantiateViewControllerWithIdentifier: @"helpViewController"] animated:NO];

        }
            break;
        case 4: {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Would you like to log out?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil] show];
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self logout];
    }
        
}
@end
