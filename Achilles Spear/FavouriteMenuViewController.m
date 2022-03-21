//
//  FavouriteMenuViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "FavouriteMenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "ProductDetailViewController.h"
#import "Util.h"
#import "HelperMethods.h"
#import "MainViewController.h"

@interface FavouriteMenuViewController ()
@end

@implementation FavouriteMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /** set menu layout width */
    _contentView.frame = CGRectMake(0, 0, SUBMENU_WIDTH, self.view.frame.size.height);

}
- (void) deleteItemFromFavourites: (NSNotification*) notification {
    
    NSDictionary *item = notification.userInfo;
    [_favouriteProducts removeObject:item];
    [_favouriteMenuTableView reloadData]; // tell table to refresh now
    [HelperMethods deleteFromFavourites:item];
    
    if ([_favouriteProducts count] > 0)
        [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"3"];
    else
        [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_favouriteProducts count] > 0)
            [self selectItem:0];
        else
            [self selectItem:-1];
    });
}
- (void) refreshFavouriteMenuList:(NSNotification *) notification {
    [_favouriteMenuTableView reloadData];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _favouriteProducts =  [[NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:FAVOURITES]] mutableCopy];
    [_favouriteMenuTableView reloadData];

    [_favouriteMenuTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_favouriteProducts != nil && [_favouriteProducts count] > 0)
            [self selectItem:0];
        else
            [self selectItem:-1];
    });
    [HelperMethods addNotificationObserver:self withName:@"deleteItemFromFavourites" useSelector:@selector(deleteItemFromFavourites:)];
    [HelperMethods addNotificationObserver:self withName:@"refreshFavouriteMenuList" useSelector:@selector(refreshFavouriteMenuList:)];
}
- (void) selectItem:(NSInteger) index {
    if (index == -1) {
        [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:@"Favourites"];
        [HelperMethods postNotificationWithName:@"showFavouriteProducts" withCategoryId:[NSString stringWithFormat:@"%ld", index]];
        return;
    }
    [_favouriteMenuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [HelperMethods postNotificationWithName:@"showFavouriteProducts" withCategoryId:[NSString stringWithFormat:@"%ld", index]];
    
    NSDictionary *item = _favouriteProducts[index];
    NSString* title = item[@"name"];
    [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:title];
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

#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_favouriteProducts count];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        NSDictionary *item = _favouriteProducts[indexPath.row];
        [_favouriteProducts removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
        [HelperMethods deleteFromFavourites:item];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_favouriteProducts count] > 0)
                [self selectItem:0];
            else
                [self selectItem:-1];
        });
        if ([_favouriteProducts count] > 0)
            [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"3"];
        else
            [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton* nextArrowButton = (UIButton*)[cell viewWithTag:1];
    
    NSDictionary *item = _favouriteProducts[indexPath.row];
    cell.textLabel.text = item[@"name"];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.textLabel.textColor = [HelperMethods getStuffColor:TEXT];
    [nextArrowButton setHidden:YES];
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self selectItem:indexPath.row];
    });
    
}

@end
