//
//  ProductDetailViewController.h
//  Achilles Spear
//
//  Created by KP on 3/17/16.
//  Copyright © 2016 ;; Balkans. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductPriceViewController.h"
#import "ProductGraphViewController.h"
#import "ProductNewsViewController.h"

@interface ProductDetailViewController : UIViewController {
    int pageIndex;
    ProductPriceViewController* productPriceViewController;
    ProductGraphViewController* productGraphViewController;
    ProductNewsViewController* productNewsViewController;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *galleryView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) NSUInteger pagesCount;
@property (assign, nonatomic) BOOL loading;
@property (assign, nonatomic) BOOL isWatchList;
@property (strong, nonatomic) NSDictionary* contractInfo;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePriceRate;
@property (weak, nonatomic) IBOutlet UILabel *changePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeSymbolLabel;
@property (weak, nonatomic) IBOutlet UIButton *changePriceButton;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

- (void) showContractMenu:(NSNotification *) notification;
- (void)showMenu;
@end
