//
//  ProductPriceViewController.m
//  Achilles Spear
//
//  Created by KP on 4/14/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "ProductPriceViewController.h"
#import "Util.h"
#import "HelperMethods.h"

@interface ProductPriceViewController ()

@end

@implementation ProductPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* currency = [_contractInfo[@"currency"] lowercaseString];
    NSString* unit = [_contractInfo[@"unit"] lowercaseString];
    
    _closePriceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    _openPriceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    _highPriceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    _lowPriceLabel.textColor = [HelperMethods getStuffColor:TEXT];
    _volumnLabel.textColor = [HelperMethods getStuffColor:TEXT];
    _settleLabel.textColor = [HelperMethods getStuffColor:TEXT];
    
    for (int tag = 200; tag < 206; tag++) {
        UILabel* textLabel = (UILabel*) [self.view viewWithTag:tag];
        [textLabel setTextColor:[HelperMethods getStuffColor:TEXT]];
    }
    
    if (_contractInfo[@"last_price"] == nil || (NSString *)[NSNull null] == _contractInfo[@"last_price"]) {
        [_closePriceLabel setText:@"-"];
    } else {
        [_closePriceLabel setText:[NSString stringWithFormat:@"%@ %@", [NSString getDecialFormat:[_contractInfo[@"last_price"] floatValue]], currency]];
    }
    if (_contractInfo[@"open_price"] == nil || (NSString *)[NSNull null] == _contractInfo[@"open_price"]) {
        [_openPriceLabel setText:@"-"];
    } else {
        [_openPriceLabel setText:[NSString stringWithFormat:@"%@ %@", [NSString getDecialFormat:[_contractInfo[@"open_price"] floatValue]], currency]];
    }
    if (_contractInfo[@"high_price"] == nil || (NSString *)[NSNull null] == _contractInfo[@"high_price"]) {
        [_highPriceLabel setText:@"-"];
    } else {
        [_highPriceLabel setText:[NSString stringWithFormat:@"%@ %@", [NSString getDecialFormat:[_contractInfo[@"high_price"] floatValue]], currency]];
    }
    if (_contractInfo[@"low_price"] == nil || (NSString *)[NSNull null] == _contractInfo[@"low_price"]) {
        [_lowPriceLabel setText:@"-"];
    } else {
        [_lowPriceLabel setText:[NSString stringWithFormat:@"%@ %@", [NSString getDecialFormat:[_contractInfo[@"low_price"] floatValue]], currency]];
    }
    if (_contractInfo[@"volume"] == nil || (NSString *)[NSNull null] == _contractInfo[@"volume"]) {
        [_volumnLabel setText:@"-"];
    } else {
        [_volumnLabel setText:[NSString stringWithFormat:@"%@ %@", [NSString getDecialFormat:[_contractInfo[@"volume"] floatValue]], unit]];
    }
    if (_contractInfo[@"settle"] == nil || (NSString *)[NSNull null] == _contractInfo[@"settle"]) {
        [_settleLabel setText:@"-"];
    } else {
        [_settleLabel setText:[NSString stringWithFormat:@"%@ %@", [NSString getDecialFormat:[_contractInfo[@"settle"] floatValue]], currency]];
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
