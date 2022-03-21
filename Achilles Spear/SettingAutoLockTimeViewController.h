//
//  SettingAutoLockTimeViewController.h
//  Achilles Spear
//
//  Created by KP on 2/12/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingAutoLockTimeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *lockTimeTableView;
@property (weak, nonatomic) IBOutlet UILabel *lockTimeLabel;
@end
