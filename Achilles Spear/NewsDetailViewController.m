//
//  NewsDetailViewController.m
//  Achilles Spear
//
//  Created by KP on 5/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "NewsDetailViewController.h"
#import "Util.h"
#import "HelperMethods.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.contentView setBackgroundColor:[HelperMethods getStuffColor:BACKGROUND]];
    
    screenWidth = self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH);
    screenHeight = self.view.frame.size.height;
    
    self.contentView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    self.scrollView.clipsToBounds = NO;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentSize:CGSizeMake(screenWidth * [_newsList count], 0)];
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (int i = 0; i < [_newsList count]; i++) {
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, self.view.frame.size.height)];
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setOpaque:NO];
        [self.scrollView addSubview:webView];
        NSDictionary* item = _newsList[i];
        NSURL *nsUrl = [NSURL URLWithString: item[@"url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
        [webView loadRequest:request];
    }
    [self.scrollView setContentOffset:CGPointMake(screenWidth * _selIndex, 0) animated:NO];
}
- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
