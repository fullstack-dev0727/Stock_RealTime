//
//  SettingColorThemeViewController.h
//  Achilles Spear
//
//  Created by KP on 2/23/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "BaseViewController.h"
#import "DRColorPicker.h"

@interface SettingColorThemeViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIColor* backgroundColor;
    NSInteger colorTheme;
    UIColor* textColor;
    UIColor* lineColor;
    UIColor* divLineColor;
}
@property (weak, nonatomic) IBOutlet UIButton *colorThemeButton;
@property (weak, nonatomic) IBOutlet UIButton *fontColorButton;
@property (weak, nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *themeView;
@property (weak, nonatomic) IBOutlet UIView *previewBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *keepButton;
@property (weak, nonatomic) IBOutlet UILabel *previewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewFavouriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewWatchListLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewSettingLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewSecretAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewLockTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewColorThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewLogoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *backgroundColorLabel;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (nonatomic, strong) DRColorPickerColor* color;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;

- (IBAction)onFontColorClick:(id)sender;
- (IBAction)onBackgroundColorClick:(id)sender;
- (IBAction)onColorThemeClick:(id)sender;
- (IBAction)onKeepClick:(id)sender;
- (void) showColorPicker: (BOOL) isFontColor;
- (void) setGradientBackgroundColor: (UIColor*) color;
- (void) setLineColors: (UIColor*) color;
- (void) setDivColors: (UIColor*) color;
- (void) setTextColors: (UIColor*) color;
- (void) setIconColors: (UIColor*) color;
- (void) refreshColorTheme;
@end
