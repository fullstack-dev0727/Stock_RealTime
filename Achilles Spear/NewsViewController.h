//
//  NewsViewController.h
//  Achilles Spear
//
//  Created by KP on 2/10/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "Http.h"
#import "JASidePanelController.h"
#import "NewsMenuViewController.h"

@interface NewsViewController : JASidePanelController {
    
}
@property (strong, nonatomic) NewsMenuViewController* newsMenuViewController;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (void) backFunc;
@end
