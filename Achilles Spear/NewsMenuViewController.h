//
//  NewsMenuViewController.h
//  Achilles Spear
//
//  Created by KP on 3/24/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuBaseViewController.h"

@interface NewsMenuViewController : MenuBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;



@end
