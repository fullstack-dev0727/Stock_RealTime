//
//  MainViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationViewController.h"
#import "Util.h"
#import "CategoryViewController.h"
#import "MBProgressHUD.h"
#import "HelperMethods.h"
#import "AppDelegate.h"
#import "NewsViewController.h"
#import "SRWebSocket.h"

@interface MainViewController () <SRWebSocketDelegate>

@end

@implementation MainViewController {
    SRWebSocket *_webSocket;
}
#pragma mark -
#pragma mark Handling idle timeout
- (void)resetIdleTimer:(NSNotification*) notification {
    NSInteger interval = [notification.object integerValue];
    
    if (idleTimer) {
        [idleTimer invalidate];
        idleTimer = nil;
    }
    if (interval > 0) {
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                     target:self
                                                   selector:@selector(idleTimerExceeded)
                                                   userInfo:nil
                                                    repeats:NO];
        long starttime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
        [HelperMethods setUserPreference:@(starttime) forKey:STARTTIME];
    }
    
}
- (void)idleTimerExceeded {
    idleTimer = nil;
    [self logout];
}

- (UIResponder *)nextResponder {
    [HelperMethods postNotificationWithName:@"resetIdleTimer" withCategoryId:[HelperMethods getUserPreference:LOCKTIME]];
    return [super nextResponder];
}
#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    [_webSocket send:@"test - message"];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);

}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"Websocket received pong");
}
- (void)sendPing:(id)sender;
{
    [_webSocket sendPing:nil];
}
- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:BASEURL, SOCKET_PATH]]]];
    _webSocket.delegate = self;

    [_webSocket open];
    
}
- (void) viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* appDelegate = APPDELEGATE;
    appDelegate.mainVC = self;
    [HelperMethods addNotificationObserver:self withName:@"resetIdleTimer" useSelector:@selector(resetIdleTimer:)];
    [HelperMethods postNotificationWithName:@"resetIdleTimer" withCategoryId:[HelperMethods getUserPreference:LOCKTIME]];
    [HelperMethods addNotificationObserver:self withName:@"main_refreshColorTheme" useSelector:@selector(refreshColorTheme:)];
    [HelperMethods addNotificationObserver:self withName:@"showBackButton" useSelector:@selector(showBackButton:)];
    [HelperMethods addNotificationObserver:self withName:@"showMenuButton" useSelector:@selector(showMenuButton:)];
    [HelperMethods addNotificationObserver:self withName:@"setTitle" useSelector:@selector(setTitle:)];
    
    self.leftFixedWidth = MENU_WIDTH;
    self.topMenuPadding = 64;
    self.titleView.frame = CGRectMake(MENU_WIDTH + SUBMENU_WIDTH, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height);
    [self initLayout];
    
    _menuViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"menuViewController"];
    [self setLeftPanel:_menuViewController];
    BaseNavigationViewController* nav = [[BaseNavigationViewController alloc] init];
    if (_newsViewController == nil) {
        _newsViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"newsViewController"];
    }
    if (_categoryViewController == nil) {
        _categoryViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"categoryViewController"];
    }
    if (_favouriteViewController == nil) {
        _favouriteViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"favouriteViewController"];
    }
    if (_watchlistViewController == nil) {
        _watchlistViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"watchListViewController"];
    }
    if (_settingViewController == nil) {
        _settingViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"settingViewController"];
    }
    nav.viewControllers = [[NSArray alloc] initWithObjects:_newsViewController, nil];
    [self setCenterPanel:nav];
    [self toggleLeftPanel:nil];

    [self refreshColorTheme:nil];
}
- (void) refreshColorTheme:(NSNotification *) notification {
    UIColor* topColor = [HelperMethods getHightLightColor:[HelperMethods getStuffColor:BACKGROUND]];
    UIColor* bottomColor = [HelperMethods getStuffColor:BACKGROUND];
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    
    //Add gradient to view
    self.contentView.layer.sublayers = nil;
    [self.contentView.layer insertSublayer:theViewGradient atIndex:0];
    UIImageView* helmetImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [helmetImageView setImage:[UIImage imageNamed:@"helmet.png"]];
    [helmetImageView setContentMode:UIViewContentModeScaleAspectFit];
    helmetImageView.alpha = 0.05f;
    [self.contentView.layer insertSublayer:helmetImageView.layer atIndex:1];
    
    _logoImageView.image = [_logoImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_logoImageView setTintColor:[HelperMethods getStuffColor:TEXT]];

    UIImage* image = [UIImage imageNamed:@"back_arrow.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_backButton setImage:image forState:UIControlStateNormal];
    _backButton.tintColor = [HelperMethods getStuffColor:TEXT];
    
    UIImage* image1 = [UIImage imageNamed:@"menu_arrow.png"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_menuButton setImage:image1 forState:UIControlStateNormal];
    _menuButton.tintColor = [HelperMethods getStuffColor:TEXT];
    
    _titleLabel.textColor = [HelperMethods getStuffColor:TEXT];
    
    UIImageView* lineImageView = (UIImageView*) [self.view viewWithTag:100];
    [lineImageView setBackgroundColor:[HelperMethods getStuffColor:LINE]];
    
    [_menuViewController refreshColorTheme];
}
- (void) setTitle:(NSNotification *) notification {
    [_titleLabel setText:notification.object];
}
- (void) showBackButton:(NSNotification *) notification {
    if ([notification.object isEqualToString:@"1"])
        [_backButton setHidden:NO];
    else
        [_backButton setHidden:YES];
}
- (void) showMenuButton:(NSNotification *) notification {
    if ([notification.object isEqualToString:@"0"])
        [_menuButton setHidden:YES];
    else
        [_menuButton setHidden:NO];
    [_menuButton setTag:[notification.object integerValue]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _reconnect];
}
- (void)stylePanel:(UIView *)panel {
    [super stylePanel:panel];
    [panel.layer setCornerRadius:0.0f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onMenuClick:(id)sender {
    NSInteger tag = _menuButton.tag;
    if (tag == 1)
        [HelperMethods postNotificationWithName:@"showProductMenu"];
    else if (tag == 2)
        [HelperMethods postNotificationWithName:@"showContractMenu"];
    else if (tag == 3)
        [HelperMethods postNotificationWithName:@"showFavouriteProductMenu"];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self logout];
    }
   
}
- (IBAction)onBackClick:(id)sender {
    BaseNavigationViewController* nav = (BaseNavigationViewController*) self.centerPanel;
    UIViewController* currentViewController = nav.viewControllers[0];
    if ([currentViewController isKindOfClass:[CategoryViewController class]]) {
        CategoryViewController* categoryViewController = (CategoryViewController*) currentViewController;
        [categoryViewController backFunc];
    } else if ([currentViewController isKindOfClass:[NewsViewController class]]) {
        NewsViewController* newsViewController = (NewsViewController*) currentViewController;
        [newsViewController backFunc];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
