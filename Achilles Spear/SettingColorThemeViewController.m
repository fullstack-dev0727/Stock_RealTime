//
//  SettingColorThemeViewController.m
//  Achilles Spear
//
//  Created by KP on 2/23/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "SplashViewController.h"
#import "SettingColorThemeViewController.h"
#import "KxMenu.h"
#import "Util.h"
#import "MainViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "HelperMethods.h"

@interface SettingColorThemeViewController ()

@end

@implementation SettingColorThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height);
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    backgroundColor = [HelperMethods getStuffColor:BACKGROUND];
    colorTheme = [[HelperMethods getUserPreference:COLORTHEME] integerValue];
    lineColor = [HelperMethods getStuffColor:LINE];
    textColor = [HelperMethods getStuffColor:TEXT];
    divLineColor = [HelperMethods getStuffColor:DIVLINE];
    
    self.color = [[DRColorPickerColor alloc] initWithColor:[UIColor blackColor]];
    
    [self refreshColorTheme];
}
- (void) refreshPreviewView {
    [self setGradientBackgroundColor:backgroundColor];
    [self setLineColors:lineColor];
    [self setTextColors:textColor];
    [self setDivColors:divLineColor];
    [self setIconColors:textColor];
    
    switch (colorTheme) {
        case 0:
            [_colorThemeButton setTitle:@"Black Theme" forState:UIControlStateNormal];
            break;
        case 1:
            [_colorThemeButton setTitle:@"Gray Theme" forState:UIControlStateNormal];
            break;
        case 2:
            [_colorThemeButton setTitle:@"White Theme" forState:UIControlStateNormal];
            break;
        case 3:
            [_colorThemeButton setTitle:@"Custom Theme" forState:UIControlStateNormal];
            [_fontColorButton setEnabled:YES];
            [_backgroundColorButton setEnabled:YES];
            break;
        default:
            break;
    }
}
- (void) refreshColorTheme {
    [self refreshPreviewView];
    
    [[_keepButton layer] setBorderWidth:1.0f];
    [[_keepButton layer] setBorderColor:[HelperMethods getStuffColor:LINE].CGColor];
    
    [[_colorThemeButton layer] setBorderWidth:1.0f];
    [[_colorThemeButton layer] setBorderColor:[HelperMethods getStuffColor:LINE].CGColor];
    
    [[_fontColorButton layer] setBorderWidth:1.0f];
    [[_fontColorButton layer] setBorderColor:[HelperMethods getStuffColor:LINE].CGColor];
    
    [[_backgroundColorButton layer] setBorderWidth:1.0f];
    [[_backgroundColorButton layer] setBorderColor:[HelperMethods getStuffColor:LINE].CGColor];
    
    [[_previewView layer] setBorderWidth:1.0f];
    [[_previewView layer] setBorderColor:[HelperMethods getStuffColor:LINE].CGColor];
    
    _fontColorLabel.textColor = textColor;
    _backgroundColorLabel.textColor = textColor;
}
- (void) setGradientBackgroundColor: (UIColor*) color {
    UIColor* topColor = [HelperMethods getHightLightColor:color];
    UIColor* bottomColor = color;
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = CGRectMake(0, 0, self.previewBackgroundView.frame.size.width, self.previewBackgroundView.frame.size.height);
    //Add gradient to view
    self.previewBackgroundView.layer.sublayers = nil;
    [self.previewBackgroundView.layer addSublayer:theViewGradient];
    [[_previewBackgroundView layer] setBorderWidth:1.0f];
    [[_previewBackgroundView layer] setBorderColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f].CGColor];

}
- (void) setLineColors: (UIColor*) color {
    for (int tag = 100; tag < 112; tag++) {
        UIImageView* lineImageView = (UIImageView*) [self.view viewWithTag:tag];
        [lineImageView setBackgroundColor:color];
    }
}
- (void) setDivColors: (UIColor*) color {
    for (int tag = 200; tag < 205; tag++) {
        UIImageView* lineImageView = (UIImageView*) [self.view viewWithTag:tag];
        [lineImageView setBackgroundColor:color];
    }
}
- (void) setTextColors: (UIColor*) color {
    for (int tag = 300; tag < 311; tag++) {
        UILabel* textLabel = (UILabel*) [self.view viewWithTag:tag];
        [textLabel setTextColor:color];
    }
}
- (void) setIconColors: (UIColor*) color {
    for (int tag = 400; tag < 406; tag++) {
        UIImageView* imageView = (UIImageView*) [self.view viewWithTag:tag];
        imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imageView setTintColor:color];
    }
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_fontColorButton setEnabled:NO];
    [_backgroundColorButton setEnabled:NO];
    [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:@"Setting / ColorTheme"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Black Theme"
       secretId:@"1"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Gray Theme"
       secretId:@"1"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"White Theme"
       secretId:@"1"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Custom Theme"
       secretId:@"1"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    for (KxMenuItem* item in menuItems) {
        item.foreColor = [HelperMethods getStuffColor:TEXT];
    }
    [KxMenu showMenuInView:self.view
                  fromRect:_themeView.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem* item = (KxMenuItem*) sender;
    [_colorThemeButton setTitle:item.title forState:UIControlStateNormal];
    [_fontColorButton setEnabled:NO];
    [_backgroundColorButton setEnabled:NO];
    
    if ([item.title isEqualToString:@"Black Theme"]) {
        colorTheme = 0;
        
        [_fontColorButton setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        [_backgroundColorButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        backgroundColor = [UIColor blackColor];
        lineColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
        textColor = [UIColor whiteColor];
        divLineColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        [self refreshPreviewView];
        
    } else if ([item.title isEqualToString:@"Gray Theme"]) {
        colorTheme = 1;
        
        [_fontColorButton setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        [_backgroundColorButton setBackgroundColor:[UIColor colorWithRed:48.0f / 255 green:48.0f / 255 blue:48.0f / 255 alpha:1.0f]];
        
        backgroundColor = [UIColor grayColor];
        lineColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
        textColor = [UIColor whiteColor];
        divLineColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        [self refreshPreviewView];
        
    } else if ([item.title isEqualToString:@"White Theme"]) {
        colorTheme = 2;
        
        [_fontColorButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        [_backgroundColorButton setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        
        backgroundColor = [UIColor whiteColor];
        lineColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
        textColor = [UIColor blackColor];
        divLineColor = [UIColor whiteColor];
        [self refreshPreviewView];
    } else if ([item.title isEqualToString:@"Custom Theme"]) {
        colorTheme = 3;
        [_fontColorButton setEnabled:YES];
        [_backgroundColorButton setEnabled:YES];
    }
    
}

- (IBAction)onFontColorClick:(id)sender {
    [self showColorPicker:YES];
}

- (IBAction)onBackgroundColorClick:(id)sender {
    [self showColorPicker:NO];
}

- (IBAction)onColorThemeClick:(id)sender {
    [self showMenu:sender];
}

- (IBAction)onKeepClick:(id)sender {
    [HelperMethods setUserPreference:@(colorTheme) forKey:COLORTHEME];
    
    NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundColor];
    [HelperMethods setUserPreference:backgroundColorData forKey:BACKGROUND];
    
    NSData *lineColorData = [NSKeyedArchiver archivedDataWithRootObject:lineColor];
    [HelperMethods setUserPreference:lineColorData forKey:LINE];
    
    NSData *textColorData = [NSKeyedArchiver archivedDataWithRootObject:textColor];
    [HelperMethods setUserPreference:textColorData forKey:TEXT];
    
    NSData *divLineColorData = [NSKeyedArchiver archivedDataWithRootObject:divLineColor];
    [HelperMethods setUserPreference:divLineColorData forKey:DIVLINE];
    
    [HelperMethods postNotificationWithName:@"main_refreshColorTheme"];
    [HelperMethods postNotificationWithName:@"setting_menu_refreshColorTheme"];
    [self refreshColorTheme];
}
- (void) showColorPicker: (BOOL) isFontColor {
    // background color of each view
    DRColorPickerBackgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // border color of the color thumbnails
    DRColorPickerBorderColor = [UIColor blackColor];
    
    // font for any labels in the color picker
    DRColorPickerFont = [UIFont systemFontOfSize:16.0f];
    
    // font color for labels in the color picker
    DRColorPickerLabelColor = [UIColor blackColor];
    // END REQUIRED SETUP
    
    // OPTIONAL SETUP....................
    // max number of colors in the recent and favorites - default is 200
    DRColorPickerStoreMaxColors = 200;
    
    // show a saturation bar in the color wheel view - default is NO
    DRColorPickerShowSaturationBar = YES;
    
    // highlight the last hue in the hue view - default is NO
    DRColorPickerHighlightLastHue = YES;
    
    // use JPEG2000, not PNG which is the default
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerUsePNG = NO;
    
    // JPEG2000 quality default is 0.9, which really reduces the file size but still keeps a nice looking image
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerJPEG2000Quality = 0.9f;
    
    // set to your shared app group to use the same color picker settings with multiple apps and extensions
    DRColorPickerSharedAppGroup = nil;
    // END OPTIONAL SETUP
    
    // create the color picker
    DRColorPickerViewController* vc = [DRColorPickerViewController newColorPickerWithColor:self.color];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.rootViewController.showAlphaSlider = NO; // default is YES, set to NO to hide the alpha slider
    
    NSInteger theme = 2; // 0 = default, 1 = dark, 2 = light
    
    // in addition to the default images, you can set the images for a light or dark navigation bar / toolbar theme, these are built-in to the color picker bundle
    if (theme == 0)
    {
        // setting these to nil (the default) tells it to use the built-in default images
        vc.rootViewController.addToFavoritesImage = nil;
        vc.rootViewController.favoritesImage = nil;
        vc.rootViewController.hueImage = nil;
        vc.rootViewController.wheelImage = nil;
        vc.rootViewController.importImage = nil;
    }
    else if (theme == 1)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-addtofavorites-dark.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-favorites-dark.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/dark/drcolorpicker-hue-v3-dark.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/dark/drcolorpicker-wheel-dark.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/dark/drcolorpicker-import-dark.png");
    }
    else if (theme == 2)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-addtofavorites-light.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-favorites-light.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/light/drcolorpicker-hue-v3-light.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/light/drcolorpicker-wheel-light.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/light/drcolorpicker-import-light.png");
    }
    
    // assign a weak reference to the color picker, need this for UIImagePickerController delegate
    self.colorPickerVC = vc;
    
    // make an import block, this allows using images as colors, this import block uses the UIImagePickerController,
    // but in You Doodle for iOS, I have a more complex import that allows importing from many different sources
    // *** Leave this as nil to not allowing import of textures ***
    vc.rootViewController.importBlock = ^(UINavigationController* navVC, DRColorPickerHomeViewController* rootVC, NSString* title)
    {
        UIImagePickerController* p = [[UIImagePickerController alloc] init];
        p.delegate = self;
        p.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.colorPickerVC presentViewController:p animated:YES completion:nil];
    };
    
    // dismiss the color picker
    vc.rootViewController.dismissBlock = ^(BOOL cancel)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    // a color was selected, do something with it, but do NOT dismiss the color picker, that happens in the dismissBlock
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* color, DRColorPickerBaseViewController* vc)
    {
        UIColor* selectedColor = [UIColor clearColor];
        self.color = color;
        if (color.rgbColor == nil)
        {
            selectedColor = [UIColor colorWithPatternImage:color.image];
        }
        else
        {
            selectedColor = color.rgbColor;
        }
        if (isFontColor) {
            _fontColorButton.backgroundColor = selectedColor;
            textColor = selectedColor;
            [self refreshPreviewView];
        } else {
            _backgroundColorButton.backgroundColor = selectedColor;
            backgroundColor =  selectedColor;
            divLineColor = backgroundColor;
            [self refreshPreviewView];
        }
    };
    
    // finally, present the color picker
    [self presentViewController:vc animated:YES completion:nil];
}

@end
