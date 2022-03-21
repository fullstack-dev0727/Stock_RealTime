//
//  FavouriteContentViewController.m
//  Achilles Spear
//
//  Created by KP on 5/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "HelperMethods.h"
#import "BaseNavigationViewController.h"
#import "FavouriteContentViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "Util.h"
#import "ProductDetailViewController.h"
#import "KxMenu.h"

@interface FavouriteContentViewController ()
@property (strong, nonatomic) NSArray* favouriteProducts;
@property (nonatomic, strong) NSMutableArray *productContracts;
@end

@implementation FavouriteContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height);
    [HelperMethods addNotificationObserver:self withName:@"showFavouriteProducts" useSelector:@selector(showFavouriteProducts:)];
    [HelperMethods addNotificationObserver:self withName:@"showFavouriteProductMenu" useSelector:@selector(showProductMenu:)];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _favouriteProducts =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:FAVOURITES]];
    if ([_favouriteProducts count] > 0)
        [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"3"];
    else
        [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) showFavouriteProducts:(NSNotification *) notification {
    BaseNavigationViewController* centerNav = (BaseNavigationViewController*) self.sidePanelController.centerPanel;
    if ([centerNav.viewControllers count] > 1) {
        [centerNav popToRootViewControllerAnimated:NO];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _productContracts = [[NSMutableArray alloc] init];
        if ([notification.object integerValue] == -1) {
            [_categoryProductTableView reloadData];
            return;
        }
        NSInteger index = [notification.object integerValue];
        _currentProduct = _favouriteProducts[index];
        NSArray* categoryItems =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:CATEGORYMENU]];
        NSString* c_id = _currentProduct[@"c_id"];
        for (int i = 0; i < [categoryItems count]; i++) {
            NSDictionary* item = categoryItems[i];
            if ([item[@"c_id"] isEqualToString:c_id]) {
                _currentProduct = item;
                break;
            }
        }
        _productContracts = _currentProduct[@"contracts"];
        [_categoryProductTableView reloadData];
    });
}
#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_productContracts count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_productContracts count] > 0)
        return 25;
    else
        return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    /* Create custom view to display section header... */
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, tableView.frame.size.width - 40, 15)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setText:@"Contract"];
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
    UILabel* categoryNameLabel = (UILabel*) [cell viewWithTag:1];
    UILabel* contractNameLabel = (UILabel*) [cell viewWithTag:2];
    UILabel* updateLabel = (UILabel*) [cell viewWithTag:3];
    UILabel* lastPriceLabel = (UILabel*) [cell viewWithTag:4];
    UILabel* unitLabel = (UILabel*) [cell viewWithTag:5];
    UILabel* changeRateLabel = (UILabel*) [cell viewWithTag:6];
    UILabel* changePriceLabel = (UILabel*) [cell viewWithTag:7];
    
    categoryNameLabel.textColor = [HelperMethods getStuffColor:TEXT];
    contractNameLabel.textColor = [HelperMethods getStuffColor:TEXT];
    updateLabel.textColor = [HelperMethods getStuffColor:TEXT];
    lastPriceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    unitLabel.textColor = [HelperMethods getStuffColor:TEXT];
    changeRateLabel.textColor = [HelperMethods getStuffColor:TEXT];
    changePriceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    
    NSDictionary *item = _productContracts[indexPath.row];
    [contractNameLabel setHidden:NO];
    [updateLabel setHidden:NO];
    [lastPriceLabel setHidden:NO];
    [unitLabel setHidden:NO];
    [changeRateLabel setHidden:NO];
    [changePriceLabel setHidden:NO];
    [categoryNameLabel setHidden:YES];
    
    contractNameLabel.text = item[@"contract"];
    updateLabel.text = [NSString fixedDateTime:item[@"datetime"]];
    changeRateLabel.textColor = UIColorFromRGB(0x767676);
    changePriceLabel.textColor = UIColorFromRGB(0x767676);
    
    if (item[@"last_price"] == nil || (NSString *)[NSNull null] == item[@"last_price"]) {
        changeRateLabel.text = @"";
        changePriceLabel.text = @"";
        unitLabel.text = @"";
        lastPriceLabel.text = @"-";
    } else {
        float changePrice = [item[@"change"] floatValue];
        float lastPrice = [item[@"last_price"] floatValue];
        
        lastPriceLabel.text = [NSString getDecialFormat:lastPrice];
        unitLabel.text = [item[@"unit"] lowercaseString];
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
    
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.textLabel.textColor = [HelperMethods getStuffColor:TEXT];
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
    
    NSDictionary *item = _productContracts[indexPath.row];
    
    ProductDetailViewController* productDetailViewController = (ProductDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"productDetailViewController"];
    productDetailViewController.contractInfo = item;
    UINavigationController* nav = (UINavigationController*) self.sidePanelController.centerPanel;
    [nav pushViewController:productDetailViewController animated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
            [HelperMethods postNotificationWithName:@"refreshFavouriteMenuList"];
        } else {
            [HelperMethods postNotificationWithName:@"deleteItemFromFavourites" withUserInfoDict:_currentProduct];
        }
    } else if ([secretId isEqualToString:@"2"]) {
        // share
    } else if ([secretId isEqualToString:@"3"]) {
        // print
    }
}

@end
