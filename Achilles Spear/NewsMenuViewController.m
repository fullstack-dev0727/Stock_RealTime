//
//  NewsMenuViewController.m
//  Achilles Spear
//
//  Created by KP on 3/24/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "NewsMenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "NewsContentViewController.h"
#import "Util.h"
#import "MainViewController.h"
#import "HelperMethods.h"

@interface NewsMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation NewsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self menuItems];
    /** set menu layout width */
    _contentView.frame = CGRectMake(0, 0, SUBMENU_WIDTH, self.view.frame.size.height);
    
    NSIndexPath *defaultSelectedCell= [NSIndexPath indexPathForRow:0 inSection:0];
    [_menuTableView selectRowAtIndexPath:defaultSelectedCell animated:YES  scrollPosition:UITableViewScrollPositionBottom];

    [_menuTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
    
    NewsContentViewController* newsContentViewController = (NewsContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"newsContentViewController"];
    UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
    [nav pushViewController:newsContentViewController animated:NO];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_menuTableView reloadData];
    [_menuTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Properties
- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    _menuItems = @[@"Latest", @"Worldwide", @"Markets", @"Technology", @"Industries", @"Energy"];
    return _menuItems;
}

#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NewsMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView* lineImageView = (UIImageView*) [cell viewWithTag:100];
    lineImageView.backgroundColor = [HelperMethods getStuffColor:LINE];
    
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
    
    /** select first menu item*/
    NSIndexPath *defaultSelectedCell= [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [_menuTableView selectRowAtIndexPath:defaultSelectedCell animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    
    NewsContentViewController* newsContentViewController = (NewsContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"newsContentViewController"];
    newsContentViewController.category = _menuItems[indexPath.row];
    UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
    [nav setViewControllers: [NSArray arrayWithObject: newsContentViewController]
                                                        animated: NO];
    [nav popToRootViewControllerAnimated:YES];
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
