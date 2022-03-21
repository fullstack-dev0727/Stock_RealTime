//
//  CategoryViewController.h
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "JASidePanelController.h"

@interface CategoryViewController : JASidePanelController {
    
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (void) backFunc;
- (void) selectCategory: (NSDictionary*) item;
- (void) popToRootViewController;
- (void) getCategoryMenu;
@end
