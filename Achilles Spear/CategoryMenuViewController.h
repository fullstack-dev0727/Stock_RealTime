//
//  CategoryMenuViewController.h
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MenuBaseViewController.h"

@interface CategoryMenuViewController : MenuBaseViewController <UITableViewDataSource, UITableViewDelegate> {

}
@property (weak, nonatomic) NSDictionary* itemDic;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *categoryMenuTableView;
@property (strong, nonatomic) IBOutlet UIView *rootMenuView;
- (NSString*) getPathName: (NSString*) c_id;
- (void) refreshMenuList:(NSNotification *) notification;
@end
