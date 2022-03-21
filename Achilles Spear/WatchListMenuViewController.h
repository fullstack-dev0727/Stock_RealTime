//
//  WatchListMenuViewController.h
//  Achilles Spear
//
//  Created by KP on 5/10/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuBaseViewController.h"

@interface WatchListMenuViewController : MenuBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (strong, nonatomic) NSMutableArray* watchListContracts;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *watchListMenuTableView;
- (void) selectItem: (NSInteger) index;
- (void) deleteItemFromWatchList: (NSNotification*) notification;
@end
