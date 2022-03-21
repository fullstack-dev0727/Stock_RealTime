//
//  MenuViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "Util.h"
#import "MainViewController.h"
#import "HelperMethods.h"

@interface MenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /** set menu layout width */
    _menuContentView.frame = CGRectMake(0, 0, MENU_WIDTH, self.view.frame.size.height);
    
    /** set the color of search bar*/
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]];
    
    /** select first menu item*/
    NSIndexPath *defaultSelectedCell= [NSIndexPath indexPathForRow:0 inSection:0];
    [_menuTableView selectRowAtIndexPath:defaultSelectedCell animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    
}
- (void) refreshColorTheme {
    [_menuTableView reloadData];
    UIImageView* lineImageView = (UIImageView*) [self.view viewWithTag:101];
    [lineImageView setBackgroundColor:[HelperMethods getStuffColor:LINE]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    _menuItems = @[@"News", @"Categories", @"Favourites", @"WatchList", @"Setting"];
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
    static NSString *CellIdentifier = @"NewsMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *cellImageView = [cell viewWithTag:1];
    UILabel *cellLabel = [cell viewWithTag:2];
    
    UIImageView* lineImageView = (UIImageView*) [cell viewWithTag:100];
    [lineImageView setBackgroundColor:[HelperMethods getStuffColor:LINE]];
    
    UIImageView* divLineImageView = (UIImageView*) [cell viewWithTag:200];
    [divLineImageView setBackgroundColor:[HelperMethods getStuffColor:DIVLINE]];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    cellLabel.text = menuItem;

    cellLabel.textColor = [HelperMethods getStuffColor:TEXT];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    switch (indexPath.row) {
        case 0:
            cellImageView.image = [UIImage imageNamed:@"ic_news"];
            break;
        case 1:
            cellImageView.image = [UIImage imageNamed:@"ic_category"];
            break;
        case 2:
            cellImageView.image = [UIImage imageNamed:@"ic_favourite"];
            break;
        case 3:
            cellImageView.image = [UIImage imageNamed:@"ic_watchlist"];
            break;
        case 4:
            cellImageView.image = [UIImage imageNamed:@"ic_setting"];
            break;
        default:
            break;
    }
    
    cellImageView.image = [cellImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cellImageView setTintColor:cellLabel.textColor];
    
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
    
    MainViewController* mainViewController = (MainViewController*) self.sidePanelController;
    UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
    
    switch (indexPath.row) {
        case 0:
            nav.viewControllers = [[NSArray alloc] initWithObjects:mainViewController.newsViewController, nil];
            break;
        case 1:
            if (currentPos == indexPath.row)
                [mainViewController.categoryViewController popToRootViewController];
            nav.viewControllers = [[NSArray alloc] initWithObjects:mainViewController.categoryViewController, nil];
            break;
        case 2:
            nav.viewControllers = [[NSArray alloc] initWithObjects:mainViewController.favouriteViewController, nil];
            break;
        case 3:
            nav.viewControllers = [[NSArray alloc] initWithObjects:mainViewController.watchlistViewController, nil];
            break;
        case 4:
            nav.viewControllers = [[NSArray alloc] initWithObjects:mainViewController.settingViewController, nil];
            break;
        default:
            break;
    }
    
    currentPos = indexPath.row;
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
