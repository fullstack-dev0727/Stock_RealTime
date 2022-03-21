//
//  CategoryContentViewController.m
//  Achilles Spear
//
//  Created by KP on 3/31/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.

#import "CategoryContentViewController.h"
#import "Util.h"
#import "MainViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "HelperMethods.h"
#import "ProductDetailViewController.h"
#import "BaseNavigationViewController.h"
#import "KxMenu.h"
#import "HelperMethods.h"

@interface CategoryContentViewController ()
@property (nonatomic, strong) NSMutableArray *currentItems;

@end

@implementation CategoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height);
    [HelperMethods addNotificationObserver:self withName:@"showCategoryItems" useSelector:@selector(showCategoryItems:)];
    [HelperMethods addNotificationObserver:self withName:@"showCategoryProducts" useSelector:@selector(showCategoryProducts:)];
    [HelperMethods addNotificationObserver:self withName:@"showProductMenu" useSelector:@selector(showProductMenu:)];
    [HelperMethods addNotificationObserver:self withName:@"showProductContracts" useSelector:@selector(showProductContracts:)];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isProduct]) {
        [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"1"];
    } else {
        [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
    }
    [_categoryProductTableView reloadData];
    [_categoryProductTableView setSeparatorColor:[HelperMethods getStuffColor:LINE]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showCategoryItems:(NSNotification *) notification {
    BaseNavigationViewController* centerNav = (BaseNavigationViewController*) self.sidePanelController.centerPanel;
    if ([centerNav.viewControllers count] > 1) {
        [centerNav popToRootViewControllerAnimated:NO];
    }
    _currentProduct = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isProduct]) {
            [HelperMethods postNotificationWithName:@"showProductContracts"];
            [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"1"];
        } else {
            [HelperMethods postNotificationWithName:@"showCategoryProducts"];
            [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
        }
    });
}
- (BOOL) isProduct {
    if ([_currentProduct[@"is_product"] intValue] == 1)
        return YES;
    else
        return NO;
}
- (void) showProductContracts:(NSNotification *) notification {
    _currentItems = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        _currentItems = [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:[NSString stringWithFormat:PRODUCT_CONTRACTS, _currentProduct[@"c_id"]]]];
        [_categoryProductTableView reloadData];
        [self getProductContracts];
    });
}
- (void) showCategoryProducts:(NSNotification *) notification {
    _currentItems = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        _currentItems = [HelperMethods getProductsForCategory:_currentProduct[@"c_id"]];
        [_categoryProductTableView reloadData];
        
    });
}
- (void) getProductContracts {
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    NSString* product_id = _currentProduct[@"id"];
    [HelperMethods getProductContracts:access_token productId:product_id completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    NSString* message = [response objectForKey:@"errors"];
                    if ([message isEqualToString:@"Your session is expired. Please sign in again."]) {
                        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    } else {
                        [HelperMethods showMessage:message];
                    }
                } else {
                    NSArray* data = response[@"data"];
                    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:[NSString stringWithFormat:PRODUCT_CONTRACTS, _currentProduct[@"c_id"]]];
                    [HelperMethods postNotificationWithName:@"showProductContracts"];
                }
            }
        });
    }];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    /* Create custom view to display section header... */
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, tableView.frame.size.width - 40, 15)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setText:@"Name"];
    [label1 setTextColor:[UIColor grayColor]];
    [view addSubview:label1];
    [view setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 15)];
    [label2 setFont:[UIFont systemFontOfSize:13]];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setText:@"Last"];
    [label2 setTextColor:[UIColor grayColor]];
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width - 40, 15)];
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [label3 setTextAlignment:NSTextAlignmentRight];
    [label3 setText:@"Change"];
    [label3 setTextColor:[UIColor grayColor]];
    [view addSubview:label3];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* contractNameLabel = (UILabel*) [cell viewWithTag:2];
    UILabel* updateLabel = (UILabel*) [cell viewWithTag:3];
    UILabel* lastPriceLabel = (UILabel*) [cell viewWithTag:4];
    UILabel* unitLabel = (UILabel*) [cell viewWithTag:5];
    UILabel* changeRateLabel = (UILabel*) [cell viewWithTag:6];
    UILabel* changePriceLabel = (UILabel*) [cell viewWithTag:7];
    
    contractNameLabel.textColor = [HelperMethods getStuffColor:TEXT];
    updateLabel.textColor = [HelperMethods getStuffColor:TEXT];
    lastPriceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    unitLabel.textColor = [HelperMethods getStuffColor:TEXT];
    changeRateLabel.textColor = [HelperMethods getStuffColor:TEXT];
    changePriceLabel.textColor = [HelperMethods getStuffColor:TEXT];

    NSDictionary *item = _currentItems[indexPath.row];
    contractNameLabel.text = [self isProduct]?item[@"contract"]:item[@"name"];
    updateLabel.text = [NSString fixedDateTime:[self isProduct]?item[@"datetime"]:item[@"last_updated_at"]];
    changeRateLabel.textColor = UIColorFromRGB(0x767676);
    changePriceLabel.textColor = UIColorFromRGB(0x767676);
    
    if (item[@"settle"] != nil && (NSString *)[NSNull null] != item[@"settle"]) {
        float lastPrice = [item[@"settle"] floatValue];
        lastPriceLabel.text = [NSString getDecialFormat:lastPrice];
        unitLabel.text = [item[@"unit"] lowercaseString];
    } else {
        unitLabel.text = @"";
        lastPriceLabel.text = @"-";
    }
    
    if (item[@"change"] == nil || (NSString *)[NSNull null] == item[@"change"]) {
        changeRateLabel.text = @"";
        changePriceLabel.text = @"";
    } else {
        if (item[@"settle"] != nil && (NSString *)[NSNull null] != item[@"settle"]) {
            float changePrice = [item[@"change"] floatValue];
            float lastPrice = [item[@"settle"] floatValue];
            
            changePriceLabel.text = [NSString getDecialFormat:changePrice];
            changeRateLabel.text = [NSString stringWithFormat:@"%.2f%@", 100 * changePrice / lastPrice, @"%"];
            
            if (changePrice > 0) {
                changeRateLabel.textColor = UIColorFromRGB(0x04e42e);
                changePriceLabel.textColor = UIColorFromRGB(0x04e42e);
            } else if (changePrice < 0) {
                changeRateLabel.textColor = UIColorFromRGB(0xdd1b07);
                changePriceLabel.textColor = UIColorFromRGB(0xdd1b07);
            }
        }
    }

    [cell setBackgroundColor:[UIColor clearColor]];

    // This is how you change the background color
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = _currentItems[indexPath.row];
    
    if ([self isProduct]) {
        [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
        ProductDetailViewController* productDetailViewController = (ProductDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"productDetailViewController"];
        productDetailViewController.contractInfo = item;
        UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
        [nav pushViewController:productDetailViewController animated:NO];

    } else {
        [HelperMethods postNotificationWithName:@"showCategoryItems" withUserInfoDict:item];
    }
}
- (void) showProductMenu:(NSNotification *) notification {
    [self showMenu];
    
}
- (void)showMenu {
    BOOL isExistedInFavourites = [HelperMethods existingInFavourites:_currentProduct];
    
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:isExistedInFavourites?@"Delete from Favourites":@"Add to Favourites"
                  secretId:@"1"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Share"
                  secretId:@"2"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Print"
                  secretId:@"3"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    for (KxMenuItem* item in menuItems) {
        item.foreColor = [HelperMethods getStuffColor:TEXT];
    }
    [KxMenu showMenuInView:_contentView
                  fromRect:CGRectMake(_contentView.frame.size.width - 60, 0, 60, 0)
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem* item = (KxMenuItem*) sender;
    NSString* secretId = item.secretId;
    if ([secretId isEqualToString:@"1"]) {
        // add to favourites
        if ([item.title isEqualToString:@"Add to Favourites"]) {
            [HelperMethods addToFavourites:_currentProduct];
        } else {
            [HelperMethods deleteFromFavourites:_currentProduct];
        }
        [HelperMethods postNotificationWithName:@"refreshMenuList"];
    } else if ([secretId isEqualToString:@"2"]) {
        // share
    } else if ([secretId isEqualToString:@"3"]) {
        // print
    }
}

@end
