//
//  FavouriteMenuViewController.h
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuBaseViewController.h"

@interface FavouriteMenuViewController : MenuBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (strong, nonatomic) NSMutableArray* favouriteProducts;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *favouriteMenuTableView;
@property (strong, nonatomic) IBOutlet UIView *rootMenuView;
- (void) selectItem:(NSInteger) index;
- (void) refreshFavouriteMenuList:(NSNotification *) notification;
- (void) deleteItemFromFavourites: (NSNotification*) notification;
@end
