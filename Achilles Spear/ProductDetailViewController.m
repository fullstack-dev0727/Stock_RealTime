//
//  ProductDetailViewController.m
//  Achilles Spear
//
//  Created by KP on 3/17/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "BaseNavigationViewController.h"
#import "ProductDetailViewController.h"
#import "Util.h"
#import "MainViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "MBProgressHUD.h"
#import "HelperMethods.h"
#import "KxMenu.h"
#import "HelperMethods.h"

@interface ProductDetailViewController () 

@end

@implementation ProductDetailViewController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.loading = NO;
    self.changePriceButton.layer.cornerRadius = 5;
    [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"2"];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [HelperMethods postNotificationWithName:@"showMenuButton" withCategoryId:@"0"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    int width = self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH);
    int height = self.view.frame.size.height - 150;
    
    self.contentView.frame = CGRectMake(0, 0, width, self.view.frame.size.height);
    
    productPriceViewController = (ProductPriceViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"productprice"];
    productPriceViewController.contractInfo = _contractInfo;
    productGraphViewController = (ProductGraphViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"productgraph"];
    productGraphViewController.contractInfo = _contractInfo;
    productGraphViewController.isWatchList = _isWatchList;
    productNewsViewController = (ProductNewsViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"productnews"];
    productNewsViewController.contractInfo = _contractInfo;
    
    self.scrollView.frame = CGRectMake(0, 0, width, height);
    
    [self.scrollView addSubview:productPriceViewController.view];
    [self.scrollView addSubview:productGraphViewController.view];
    [self.scrollView addSubview:productNewsViewController.view];
    
    self.scrollView.clipsToBounds = NO;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.pagingEnabled = YES;
    
    [productPriceViewController.view setFrame:CGRectMake(0, 0, width, height)];
    [productGraphViewController.view setFrame:CGRectMake(width, 0, width, height)];
    [productNewsViewController.view setFrame:CGRectMake(2 * width, 0, width, height)];

    [self.scrollView setContentSize:CGSizeMake(width * 3, 0)];
    
    [_updatedLabel setText:[NSString fixedDateTime:_contractInfo[@"datetime"]]];
    [_changeSymbolLabel setHidden:NO];
    
    if (_contractInfo[@"settle"] == nil || (NSString *)[NSNull null] == _contractInfo[@"settle"]) {
        _changePriceLabel.text = @"0.0";
        _changePriceRate.text = @"0.00%";
        _priceLabel.text = @"-";
        _changePriceButton.backgroundColor = UIColorFromRGB(0x767676);
    } else {
        float price = [_contractInfo[@"settle"] floatValue];
        [_priceLabel setText:[NSString getDecialFormat:price]];
        if (_contractInfo[@"change"] == nil || (NSString *)[NSNull null] == _contractInfo[@"change"]) {
            _changePriceLabel.text = @"";
            _changePriceRate.text = @"";
            [_changeSymbolLabel setHidden:YES];
            _changePriceButton.backgroundColor = UIColorFromRGB(0x767676);
        } else {
            float change = [_contractInfo[@"change"] floatValue];
            [_changePriceLabel setText:[NSString getDecialFormat:change]];
            if (price != 0)
                _changePriceRate.text = [NSString stringWithFormat:@"%.2f%@", 100 * change / price, @"%"];
            else
                _changePriceRate.text = @"0.00%";
            if (change > 0) {
                _changePriceButton.backgroundColor = UIColorFromRGB(0x16b033);
            } else {
                _changePriceButton.backgroundColor = UIColorFromRGB(0xdd1b07);
            }
        }
        
    }
    [HelperMethods addNotificationObserver:self withName:@"showContractMenu" useSelector:@selector(showContractMenu:)];
    
    _priceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    _updatedLabel.textColor = [HelperMethods getStuffColor:TEXT];
    _lineImageView.backgroundColor = [HelperMethods getStuffColor:LINE];
}
- (void) showContractMenu:(NSNotification *) notification {
    [self showMenu];
}

- (void)showMenu {
    BOOL isExistedInWatchList = [HelperMethods existingInWatchList:_contractInfo];
    
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:isExistedInWatchList?@"Delete from WatchList":@"Add to WatchList"
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
        if ([item.title isEqualToString:@"Delete from WatchList"]) {
            [HelperMethods postNotificationWithName:@"deleteItemFromWatchList" withUserInfoDict:_contractInfo];
            [HelperMethods removeKeyUserPreference:[NSString stringWithFormat:PRODUCTHISTORYFORWATCHLIST, _contractInfo[@"id"]]];
        } else {
            [HelperMethods addToWatchList:_contractInfo];
            NSArray* _productHistorydArray = [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:[NSString stringWithFormat:PRODUCTHISTORY, _contractInfo[@"id"]]]];
            [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:_productHistorydArray] forKey:[NSString stringWithFormat:PRODUCTHISTORYFORWATCHLIST, _contractInfo[@"id"]]];
        }
    } else if ([secretId isEqualToString:@"2"]) {
        // share
    } else if ([secretId isEqualToString:@"3"]) {
        // print
    }
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

@end
