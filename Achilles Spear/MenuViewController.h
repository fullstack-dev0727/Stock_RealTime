//
//  MenuViewController.h
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuBaseViewController.h"

@interface MenuViewController : MenuBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    NSInteger currentPos;
}
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *menuContentView;
@property (strong, nonatomic) IBOutlet UIView *rootMenuView;
- (void) refreshColorTheme;
@end
