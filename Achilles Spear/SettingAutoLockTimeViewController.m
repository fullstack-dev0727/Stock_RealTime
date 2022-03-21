//
//  SettingAutoLockTimeViewController.m
//  Achilles Spear
//
//  Created by KP on 2/12/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SettingAutoLockTimeViewController.h"
#import "Util.h"
#import "MainViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "HelperMethods.h"

@interface SettingAutoLockTimeViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuValues;
@end

@implementation SettingAutoLockTimeViewController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self menuValues];
    
    self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height);

    [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:@"Setting / AutoLock"];
    
    [_lockTimeLabel setTextColor:[HelperMethods getStuffColor:TEXT]];
    
    [[_lockTimeTableView layer] setBorderWidth:1.0f];
    [[_lockTimeTableView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    
    NSInteger lockTime = [[HelperMethods  getUserPreference:LOCKTIME] integerValue];
    for (int i = 0; i < [_menuValues count]; i++) {
        NSInteger value = [_menuValues[i] integerValue];
        if (value == lockTime) {
            index = i;
            [_lockTimeTableView reloadData];
            break;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    _menuItems = @[@"30 seconds", @"5 minutes", @"10 minutes", @"15 minutes", @"30 minutes", @"Never"];
    return _menuItems;
}
- (NSArray *) menuValues {
    if (_menuValues) return _menuValues;
    _menuValues = @[@30, @300, @600, @900, @1800, @0];
    return _menuValues;
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
    static NSString *CellIdentifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    cell.textLabel.text = menuItem;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    if (index == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    index = indexPath.row;
    [_lockTimeTableView reloadData];
    [HelperMethods setUserPreference:_menuValues[indexPath.row] forKey:LOCKTIME];
    [HelperMethods postNotificationWithName:@"resetIdleTimer" withCategoryId:[HelperMethods getUserPreference:LOCKTIME]];
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
