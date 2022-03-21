//
//  CategoryMenuViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "CategoryMenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "CategoryContentViewController.h"
#import "Util.h"
#import "MainViewController.h"
#import "ProductDetailViewController.h"
#import "BaseNavigationViewController.h"
#import "CategoryViewController.h"
#import "HelperMethods.h"

@interface CategoryMenuViewController ()
@property (nonatomic, strong) NSMutableArray *categoryItems;
@property (nonatomic, strong) NSMutableArray *currentItems;
@end

@implementation CategoryMenuViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /** set menu layout width */
    _contentView.frame = CGRectMake(0, 0, SUBMENU_WIDTH, self.view.frame.size.height);
    
    if (![_itemDic[@"c_id"] isEqualToString:@"c_0"]) {
        [HelperMethods postNotificationWithName:@"showBackButton" withCategoryId:@"1"];
    } else {
        [HelperMethods postNotificationWithName:@"showBackButton" withCategoryId:@"0"];
    }
    
    _categoryItems =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:CATEGORYMENU]];
    
    [_categoryMenuTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
    
    [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:[self getPathName:_itemDic[@"c_id"]]];
    [HelperMethods postNotificationWithName:@"showCategoryItems" withUserInfoDict:_itemDic];
    [HelperMethods addNotificationObserver:self withName:@"refreshMenuList" useSelector:@selector(refreshMenuList:)];
    [HelperMethods postNotificationWithName:@"refreshMenuList"];
}
- (void) refreshMenuList:(NSNotification *) notification {
    _currentItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_categoryItems count]; i++) {
        NSDictionary* item = _categoryItems[i];
        if ([_itemDic[@"c_id"] isEqualToString:item[@"parent_c_id"]]) {
            [_currentItems addObject:item];
        }
    }
    [_categoryMenuTableView reloadData];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [HelperMethods postNotificationWithName:@"showBackButton" withCategoryId:@"0"];
    [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
}
- (void) setItemDic:(NSDictionary *)itemDic {
    _itemDic = itemDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*) getPathName: (NSString*) c_id {
    for (int i = 0;i < [_categoryItems count]; i++) {
        NSDictionary* item = _categoryItems[i];
        if ([item[@"c_id"] isEqualToString:c_id]) {
            return [NSString stringWithFormat:@"%@ / %@", [self getPathName:item[@"parent_c_id"]], item[@"name"]];
        }
            
    }
    return @"Categories";
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
    return [_currentItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView* nextArrowImageView = (UIImageView*)[cell viewWithTag:400];
    
    NSDictionary *item = _currentItems[indexPath.row];
    cell.textLabel.text = item[@"name"];
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.textLabel.textColor = [HelperMethods getStuffColor:TEXT];
    
    if ([item[@"is_product"] intValue] == 1) {
        BOOL existingInFavourites = [HelperMethods existingInFavourites:item];
        if (existingInFavourites) {
            [nextArrowImageView setHidden:NO];
            [nextArrowImageView setImage:[UIImage imageNamed:@"fav_arrow.png"]];
        } else {
            [nextArrowImageView setHidden:YES];
        }

    } else {
        [nextArrowImageView setImage:[UIImage imageNamed:@"next_arrow.png"]];
        [nextArrowImageView setHidden:NO];
    }
    // This is how you change the background color
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];

    bgColorView.backgroundColor = [HelperMethods getStuffColor:LINE];
    [cell setSelectedBackgroundView:bgColorView];
    
    nextArrowImageView.image = [nextArrowImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [nextArrowImageView setTintColor:[HelperMethods getStuffColor:TEXT]];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* item = _currentItems[indexPath.row];
    
    if ([item[@"is_product"] intValue] == 1) {
        [HelperMethods postNotificationWithName:@"showCategoryProducts" withUserInfoDict:item];
        return;
    }
    
    CategoryViewController* categoryViewController = (CategoryViewController*) self.sidePanelController;
    [categoryViewController selectCategory:item];
}

@end
