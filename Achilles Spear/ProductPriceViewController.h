//
//  ProductPriceViewController.h
//  Achilles Spear
//
//  Created by KP on 4/14/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProductPriceViewController : UIViewController {
    
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *openPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *closePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *highPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumnLabel;
@property (weak, nonatomic) IBOutlet UILabel *settleLabel;
@property (strong, nonatomic) NSDictionary* contractInfo;
@end
