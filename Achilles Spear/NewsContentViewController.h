//
//  NewsContentViewController.h
//  Achilles Spear
//
//  Created by KP on 3/24/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsContentViewController : BaseViewController <UIAlertViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray* newsList;
}
@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSString *category;
- (void) getCategoryNews;
@end
