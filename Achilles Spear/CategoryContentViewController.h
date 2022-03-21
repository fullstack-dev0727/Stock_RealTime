//
//  CategoryContentViewController.h
//  Achilles Spear
//
//  Created by KP on 3/31/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "BaseViewController.h"

@interface CategoryContentViewController : UIViewController {
    NSString* titleName;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *categoryProductTableView;
@property (strong, nonatomic) NSDictionary* currentProduct;
- (void) showCategoryItems:(NSNotification *)notification;
- (void) showProductMenu:(NSNotification *) notification;
- (void) showProductContracts:(NSNotification *) notification;
- (void) showCategoryProducts:(NSNotification *) notification;
- (void)showMenu;
- (void) getProductContracts;
- (BOOL) isProduct;
@end
