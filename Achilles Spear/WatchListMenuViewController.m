//
//  WatchListMenuViewController.m
//  Achilles Spear
//
//  Created by KP on 5/10/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "HelperMethods.h"
#import "WatchListMenuViewController.h"
#import "Util.h"
#import "ProductDetailViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface WatchListMenuViewController ()

@end

@implementation WatchListMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentView.frame = CGRectMake(0, 0, SUBMENU_WIDTH, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _watchListContracts =  [[NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:WATCHLIST]] mutableCopy];
    [_watchListMenuTableView reloadData];

    [_watchListMenuTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_watchListContracts != nil && [_watchListContracts count] > 0)
            [self selectItem:0];
        else
            [self selectItem:-1];
    });
    [HelperMethods addNotificationObserver:self withName:@"deleteItemFromWatchList" useSelector:@selector(deleteItemFromWatchList:)];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_watchListContracts count];
}
- (void) deleteItemFromWatchList: (NSNotification*) notification {
    NSDictionary *item = notification.userInfo;
    [_watchListContracts removeObject:item];
    [_watchListMenuTableView reloadData]; // tell table to refresh now
    [HelperMethods deleteFromWatchList:item];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_watchListContracts count] > 0)
            [self selectItem:0];
        else
            [self selectItem:-1];
    });
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        NSDictionary *item = _watchListContracts[indexPath.row];
        [_watchListContracts removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
        [HelperMethods deleteFromWatchList:item];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_watchListContracts count] > 0)
                [self selectItem:0];
            else
                [self selectItem:-1];
        });
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton* nextArrowButton = (UIButton*)[cell viewWithTag:1];
    
    NSDictionary *item = _watchListContracts[indexPath.row];
    NSString* title = [NSString stringWithFormat:@"%@ - %@", item[@"product_name"], item[@"contract"]];
    cell.textLabel.text = title;
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.textLabel.textColor = [HelperMethods getStuffColor:TEXT];
    
    [nextArrowButton setHidden:YES];
    
    // This is how you change the background color
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];

    bgColorView.backgroundColor = [HelperMethods getStuffColor:LINE];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
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
    [self selectItem:indexPath.row];
    
}
- (void) selectItem: (NSInteger) index {
    if (index == -1) {
        UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
        [nav setViewControllers: [NSArray arrayWithObject: [[UIViewController alloc] init]] animated: NO];
        [nav popToRootViewControllerAnimated:YES];
        [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:@"WatchList"];
        return;
    }
    
    NSDictionary *item = _watchListContracts[index];
    ProductDetailViewController* productDetailViewController = (ProductDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"productDetailViewController"];
    productDetailViewController.contractInfo = item;
    productDetailViewController.isWatchList = YES;
    UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
    [nav setViewControllers: [NSArray arrayWithObject: productDetailViewController] animated: NO];
    [nav popToRootViewControllerAnimated:YES];
    
    NSString* title = [NSString stringWithFormat:@"%@ - %@", item[@"product_name"], item[@"contract"]];
    [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:title];
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
