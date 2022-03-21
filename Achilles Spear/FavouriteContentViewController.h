//
//  FavouriteContentViewController.h
//  Achilles Spear
//
//  Created by KP on 5/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "BaseViewController.h"

@interface FavouriteContentViewController : UIViewController {

}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *categoryProductTableView;
@property (strong, nonatomic) NSDictionary* currentProduct;
- (void) showFavouriteProducts:(NSNotification *) notification;
- (void) showProductMenu:(NSNotification *) notification;
@end
