//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chart.h"
#import <QuartzCore/QuartzCore.h>
#import "YAxis.h"
#import "AutoCompleteDelegate.h"
#import "BaseViewController.h"

@interface ProductGraphViewController : BaseViewController <UIAlertViewDelegate> {
    Chart *candleChart;
    UIView *toolBar;
    UIView *candleChartFreqView;
    NSString *lastTime;
    NSTimer *timer;
    UILabel *security;
    int tradeStatus;
    int chartMode;
    NSString *req_freq;
    NSString *req_type;
}
@property (strong, nonatomic) NSDictionary* contractInfo;
@property (nonatomic,retain) Chart *candleChart;
@property (nonatomic,retain) UIView *toolBar;
@property (nonatomic,retain) UIView *candleChartFreqView;
@property (nonatomic) int chartMode;
@property (nonatomic) int tradeStatus;
@property (nonatomic,retain) NSString *lastTime;
@property (nonatomic,retain) UILabel *status;
@property (nonatomic,retain) NSString *req_freq;
@property (nonatomic,retain) NSString *req_type;
@property (nonatomic,retain) NSString *req_url;
@property (nonatomic,retain) NSString *req_security_id;
@property (strong, nonatomic) NSArray* productHistorydArray;
@property (assign, nonatomic) BOOL isWatchList;

-(void)initChart;
-(void)generateData:(NSMutableDictionary *)dic From:(NSArray *)data;
-(void)setData:(NSDictionary *)dic;
-(void)setCategory:(NSArray *)category;
-(BOOL)isCodesExpired;
-(void)setOptions:(NSDictionary *)options ForSerie:(NSMutableDictionary *)serie;
- (void) getProductHistory;
- (void) drawGraph:(NSDictionary*) period;
@end
