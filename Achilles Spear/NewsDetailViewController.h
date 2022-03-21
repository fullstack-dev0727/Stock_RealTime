//
//  NewsDetailViewController.h
//  Achilles Spear
//
//  Created by KP on 5/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsDetailViewController : BaseViewController {
    int screenWidth;
    int screenHeight;
}
@property (assign, nonatomic) NSInteger selIndex;
@property (strong, nonatomic) NSMutableArray* newsList;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
