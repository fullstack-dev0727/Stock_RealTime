//
//  ProductNewsViewController.h
//  Achilles Spear
//
//  Created by KP on 4/14/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "BaseViewController.h"

@interface ProductNewsViewController : BaseViewController <UIAlertViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray* newsList;
}
@property (strong, nonatomic) NSDictionary* contractInfo;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSString *category;
@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;

@end
