//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import "ProductGraphViewController.h"
#import "ASIHTTPRequest.h"
#import "ResourceHelper.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "Util.h"
#import "HelperMethods.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "CategoryContentViewController.h"
#import "MainViewController.h"

@implementation ProductGraphViewController

@synthesize candleChart;
@synthesize toolBar;
@synthesize candleChartFreqView;
@synthesize chartMode;
@synthesize tradeStatus;
@synthesize lastTime;
@synthesize status;
@synthesize req_freq;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height - 200);
    
    //add notification observer
    [HelperMethods addNotificationObserver:self withName:@"drawGraph" useSelector:@selector(drawGraph:)];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(doNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];

    //init vars
    self.chartMode  = 1; //1,candleChart
    self.tradeStatus= 1;
    self.req_freq   = @"d";
    self.req_type   = @"H";

    //candleChart
    self.candleChart = [[Chart alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    [self.view addSubview:candleChart];

    //toolbar
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [self.view addSubview:toolBar];


    UIImage *btnImg = [ResourceHelper loadImage:@"candle_chart"];
    UIImage *btnImgBg = [ResourceHelper loadImage:[@"candle_chart" stringByAppendingFormat:@"_%@",@"selected"]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.tag = 2;
    [btn setFrame:CGRectMake(0,0, 80, 40)];
    [btn setTitle:@"Interval" forState:UIControlStateNormal];
    [btn setTitleColor:[HelperMethods getStuffColor:TEXT] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:btn];


    //candleChart freqView
    self.candleChartFreqView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 120, 120)];
    [self.candleChartFreqView setBackgroundColor:[HelperMethods getHightLightColor:[HelperMethods getStuffColor:BACKGROUND]]];
    [self.candleChartFreqView setHidden:YES];
    
    btnImg = [ResourceHelper loadImage:@"k1d"];
    btnImgBg = [ResourceHelper loadImage:[@"k1d" stringByAppendingFormat:@"_%@",@"selected"]];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 26;
    [btn setFrame:CGRectMake(0,0, 120, 40)];
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn setImage:btnImgBg forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [candleChartFreqView addSubview:btn];

    btnImg = [ResourceHelper loadImage:@"k1w"];
    btnImgBg = [ResourceHelper loadImage:[@"k1w" stringByAppendingFormat:@"_%@",@"selected"]];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 27;
    [btn setFrame:CGRectMake(0,40, 120, 40)];
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn setImage:btnImgBg forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [candleChartFreqView addSubview:btn];

    btnImg = [ResourceHelper loadImage:@"k1m"];
    btnImgBg = [ResourceHelper loadImage:[@"k1m" stringByAppendingFormat:@"_%@",@"selected"]];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 28;
    [btn setFrame:CGRectMake(0,80, 120, 40)];
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn setImage:btnImgBg forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [candleChartFreqView addSubview:btn];

    [self.toolBar addSubview:candleChartFreqView];
    
    //init chart
    [self initChart];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isWatchList) {
            _productHistorydArray = [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:[NSString stringWithFormat:PRODUCTHISTORYFORWATCHLIST, _contractInfo[@"id"]]]];
            [HelperMethods postNotificationWithName:@"drawGraph" withCategoryId:@"d"];
        } else {
            _productHistorydArray = [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:[NSString stringWithFormat:PRODUCTHISTORY, _contractInfo[@"id"]]]];
            [self getProductHistory];
            [HelperMethods postNotificationWithName:@"drawGraph" withCategoryId:@"d"];
        }
    });
}

- (void) drawGraph:(NSNotification *) notification {
    _productHistorydArray = [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:[NSString stringWithFormat:PRODUCTHISTORY, _contractInfo[@"id"]]]];
    if (_productHistorydArray == nil || [_productHistorydArray count] < 2) {
        [self.candleChart setHidden:YES];
        return;
    } else {
        [self.candleChart setHidden:NO];
    }
        
    self.status.text = @"";
    NSMutableArray *data =[[NSMutableArray alloc] init];
    NSMutableArray *category =[[NSMutableArray alloc] init];
    
    NSInteger idx;
    for (idx = [_productHistorydArray count] - 1; idx > 0; idx--) {
        NSDictionary* dic = [_productHistorydArray objectAtIndex:idx];
        [category addObject:[NSString fixedDateTime:dic[@"datetime"]]];
        
        NSMutableArray *item =[[NSMutableArray alloc] init];
        NSString* settle = dic[@"settle"];
        if (dic[@"settle"] == nil || (NSString *)[NSNull null] == dic[@"settle"]) {
            settle = @"0";
        }
        if (dic[@"open_price"] == nil || (NSString *)[NSNull null] == dic[@"open_price"]) {
            [item addObject:settle];
        } else {
            [item addObject:dic[@"open_price"]];
        }
        if (dic[@"last_price"] == nil || (NSString *)[NSNull null] == dic[@"last_price"]) {
            [item addObject:settle];
        } else {
            [item addObject:dic[@"last_price"]];
        }
        if (dic[@"high_price"] == nil || (NSString *)[NSNull null] == dic[@"high_price"]) {
            [item addObject:settle];
        } else {
            [item addObject:dic[@"high_price"]];
        }
        if (dic[@"low_price"] == nil || (NSString *)[NSNull null] == dic[@"low_price"]) {
            [item addObject:settle];
        } else {
            [item addObject:dic[@"low_price"]];
        }
        if (dic[@"volume"] == nil || (NSString *)[NSNull null] == dic[@"volume"]) {
            [item addObject:@0];
        } else {
            [item addObject:dic[@"volume"]];
        }
        [data addObject:item];
    }
    
    if(data.count==0){
        self.status.text = @"Error!";
        return;
    }
    NSMutableArray *filteredData =[[NSMutableArray alloc] init];
    NSMutableArray *filteredCategory =[[NSMutableArray alloc] init];
    if ([@"d" isEqualToString:notification.object]) {
        filteredData = [data copy];
        filteredCategory = [category copy];
    }
    if ([@"w" isEqualToString:notification.object]) {
        NSString* mondayDate = @"";
        NSString* open_price = @"";
        NSString* last_price = @"";
        NSString* high_price = @"";
        NSString* low_price = @"";
        float volume = 0.0f;
        for (int i = 0;i < [category count]; i++) {
            NSString* weekDay = [NSString getWeekDayFromDate:category[i]];
            NSLog(@"%@", weekDay);
            if ([@"Monday" isEqualToString:weekDay]) {
                mondayDate = category[i];
                int index = i;
                BOOL flag = YES;
                NSMutableArray* item = data[index++];
                
                do {
                    if (index >= [category count]) {
                        flag = NO;
                    }
                    else {
                        NSString* weekDay = [NSString getWeekDayFromDate:category[index]];
                        if ([weekDay isEqualToString:@"Monday"]) {
                            flag = NO;
                        } else {
                            NSMutableArray* temp = data[index++];
                            open_price = temp[0];
                            last_price = temp[1];
                            high_price = temp[2];
                            low_price = temp[3];
                            volume = [temp[4] floatValue];
                            item[1] = last_price;
                            item[2] = item[2] < high_price ? high_price : item[2];
                            item[3] = item[3] > low_price ? low_price : item[2];
                            float sum = [item[4] floatValue] + volume;
                            item[4] = [NSString stringWithFormat:@"%.1f", sum];
                        }
                    }
                    if (!flag) {
                        float value = [item[4] floatValue] / (index - i);
                        item[4] = [NSString stringWithFormat:@"%.1f", value];
                    }
                } while (flag);
                
                [filteredCategory addObject:mondayDate];
                [filteredData addObject:item];
                
            }
        }
    }
    if ([@"m" isEqualToString:notification.object]) {
        NSString* mondayDate = @"";
        NSString* open_price = @"";
        NSString* last_price = @"";
        NSString* high_price = @"";
        NSString* low_price = @"";
        float volume = 0.0f;
        
        NSInteger month = [NSString getMonthFromDate:category[0]];
        for (int i = 0;i < [category count]; i++) {
            int index = i;
            BOOL flag = YES;
            mondayDate = category[i];
            NSMutableArray* item = data[i];
            do {
                NSInteger temp = [NSString getMonthFromDate:category[index++]];
                if (index >= [category count]) {
                    flag = NO;
                } else {
                    if (month == temp) {
                        NSMutableArray* temp = data[index];
                        open_price = temp[0];
                        last_price = temp[1];
                        high_price = temp[2];
                        low_price = temp[3];
                        volume = [temp[4] floatValue];
                        item[1] = last_price;
                        item[2] = item[2] < high_price ? high_price : item[2];
                        item[3] = item[3] > low_price ? low_price : item[2];
                        float sum = [item[4] floatValue] + volume;
                        item[4] = [NSString stringWithFormat:@"%.1f", sum];
                    }
                    else {
                        flag = NO;
                    }
                }
                
                if (!flag) {
                    float value = [item[4] floatValue] / (index - i);
                    item[4] = [NSString stringWithFormat:@"%.1f", value];
                    i = index;
                    month = temp;
                }
            } while (flag);
            [filteredCategory addObject:mondayDate];
            [filteredData addObject:item];
        }
    }
    [self.candleChart reset];
    [self.candleChart clearData];
    [self.candleChart clearCategory];
    
    self.lastTime = [filteredCategory lastObject];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [self generateData:dic From:filteredData];
    [self setData:dic];
    
    NSMutableArray *cate = [[NSMutableArray alloc] init];
    for(int i=0;i<filteredCategory.count;i++){
        [cate addObject:filteredCategory[i]];
    }
    [self setCategory:cate];
    
    [self.candleChart setNeedsDisplay];
}
- (void) getProductHistory {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    NSString* contract_id = _contractInfo[@"id"];
    [HelperMethods getProductHistory:access_token contractId:contract_id completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    NSString* message = [response objectForKey:@"errors"];
                    if ([message isEqualToString:@"Your session is expired. Please sign in again."]) {
                        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    } else {
                        [HelperMethods showMessage:message];
                    }
                } else {
                    NSArray* data = response[@"data"];
                    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:[NSString stringWithFormat:PRODUCTHISTORY, contract_id]];
                    [HelperMethods postNotificationWithName:@"drawGraph" withCategoryId:@"d"];
                }
            }
        });
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self logout];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)initChart{
    NSMutableArray *padding = [@[@"20", @"20", @"20", @"20"] mutableCopy];
    [self.candleChart setPadding:padding];
    NSMutableArray *secs = [[NSMutableArray alloc] init];
    [secs addObject:@"4"];
    [secs addObject:@"1"];
    [self.candleChart addSections:2 withRatios:secs];
    [[self.candleChart sections][0] addYAxis:0];
    [[self.candleChart sections][1] addYAxis:0];

    [self.candleChart getYAxis:0 withIndex:0].ext = 0.05;
    NSMutableArray *series = [[NSMutableArray alloc] init];
    NSMutableArray *secOne = [[NSMutableArray alloc] init];
    NSMutableArray *secTwo = [[NSMutableArray alloc] init];

    //price
    NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"price";
    serie[@"label"] = @"Price";
    serie[@"data"] = data;
    serie[@"type"] = @"candle";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"0";
    serie[@"color"] = @"249,222,170";
    serie[@"negativeColor"] = @"249,222,170";
    serie[@"selectedColor"] = @"249,222,170";
    serie[@"negativeSelectedColor"] = @"249,222,17/**/0";
    serie[@"labelColor"] = @"22,176,51";
    serie[@"labelNegativeColor"] = @"221,27,7";
    [series addObject:serie];
    [secOne addObject:serie];

    //VOL
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"vol";
    serie[@"label"] = @"VOL";
    serie[@"data"] = data;
    serie[@"type"] = @"column";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"decimal"] = @"0";
    serie[@"color"] = @"22,176,51";
    serie[@"negativeColor"] = @"221,27,7";
    serie[@"selectedColor"] = @"22,176,51";
    serie[@"negativeSelectedColor"] = @"221,27,7";
    [series addObject:serie];
    [secTwo addObject:serie];

    //candleChart init
    [self.candleChart setSeries:series];

    [[self.candleChart sections][0] setSeries:secOne];
    [[self.candleChart sections][1] setSeries:secTwo];

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0/**/;
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [self.candleChart.layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

}

-(void)setOptions:(NSDictionary *)options ForSerie:(NSMutableDictionary *)serie;{
    serie[@"name"] = options[@"name"];
    serie[@"label"] = options[@"label"];
    serie[@"type"] = options[@"type"];
    serie[@"yAxis"] = options[@"yAxis"];
    serie[@"section"] = options[@"section"];
    serie[@"color"] = options[@"color"];
    serie[@"negativeColor"] = options[@"negativeColor"];
    serie[@"selectedColor"] = options[@"selectedColor"];
    serie[@"negativeSelectedColor"] = options[@"negativeSelectedColor"];
}

-(void)buttonPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;

    if(index !=2){
        [self.candleChartFreqView setHidden:YES];
    }

    if(index>=21 && index<=28){
        for (UIView *subview in self.candleChartFreqView.subviews){
            UIButton *btn = (UIButton *)subview;
            btn.selected = NO;
        }
    }
    btn.selected = YES;

    switch (index) {
        case 1:{
            UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
            sel.selected = NO;
            self.chartMode  = 0;
            self.req_freq   = @"1m";
            self.req_type   = @"T";
            [HelperMethods postNotificationWithName:@"drawGraph" withCategoryId:@"d"];
            break;
        }
        case 2:{
            UIButton *sel = (UIButton *)[self.toolBar viewWithTag:1];
            sel.selected = NO;
            if(self.candleChartFreqView.hidden == YES){
                self.candleChartFreqView.hidden = NO;
            } else{
                btn.selected = NO;
                sel.selected = NO;
                [self.candleChartFreqView setHidden:YES];
            }
            break;
        }
        case 26:{
            UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
            sel.selected = NO;
            self.chartMode  = 1;
            self.req_freq   = @"d";
            self.req_type   = @"H";
            [HelperMethods postNotificationWithName:@"drawGraph" withCategoryId:self.req_freq];
            break;
        }
        case 27:{
            UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
            sel.selected = NO;
            self.chartMode  = 1;
            self.req_freq   = @"w";
            self.req_type   = @"H";
            [HelperMethods postNotificationWithName:@"drawGraph" withCategoryId:self.req_freq];
            break;

        }
        case 28:{
            UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
            sel.selected = NO;
            self.chartMode  = 1;
            self.req_freq   = @"m";
            self.req_type   = @"H";
            [HelperMethods postNotificationWithName:@"drawGraph" withCategoryId:self.req_freq];
            break;

        }
        case 50:{
            UIGraphicsBeginImageContext(self.candleChart.bounds.size);
            [self.candleChart.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(anImage,nil,nil,nil);
            break;
        }
        default:
            break;
    }

}

- (void)doNotification:(NSNotification *)notification{
    UIButton *sel = (UIButton *)[self.toolBar viewWithTag:1];
    [self buttonPressed:sel];
}
-(BOOL)isCodesExpired{
    NSDate *date = [NSDate date];
    double now = [date timeIntervalSince1970];
    double last = now;
    NSString *autocompTime = (NSString *)[ResourceHelper  getUserDefaults:@"autocompTime"];
    if(autocompTime!=nil){
        last = [autocompTime doubleValue];
        if(now - last >3600*8){
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

-(void)generateData:(NSMutableDictionary *)dic From:(NSArray *)data{
    //price
    NSMutableArray *price = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        [price addObject:data[i]];
    }
    dic[@"price"] = price;
    
    //VOL
    NSMutableArray *vol = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",[[data[i] objectAtIndex:4] floatValue]/100]];
        [vol addObject:item];
    }
    dic[@"vol"] = vol;
}

-(void)setData:(NSDictionary *)dic{
    [self.candleChart appendToData:dic[@"price"] forName:@"price"];
    [self.candleChart appendToData:dic[@"vol"] forName:@"vol"];

    [self.candleChart appendToData:dic[@"ma10"] forName:@"ma10"];
    [self.candleChart appendToData:dic[@"ma30"] forName:@"ma30"];
    [self.candleChart appendToData:dic[@"ma60"] forName:@"ma60"];

    [self.candleChart appendToData:dic[@"rsi6"] forName:@"rsi6"];
    [self.candleChart appendToData:dic[@"rsi12"] forName:@"rsi12"];

    [self.candleChart appendToData:dic[@"wr"] forName:@"wr"];
    [self.candleChart appendToData:dic[@"vr"] forName:@"vr"];

    [self.candleChart appendToData:dic[@"kdj_k"] forName:@"kdj_k"];
    [self.candleChart appendToData:dic[@"kdj_d"] forName:@"kdj_d"];
    [self.candleChart appendToData:dic[@"kdj_j"] forName:@"kdj_j"];

    NSMutableDictionary *serie = [self.candleChart getSerie:@"price"];
    if(serie == nil)
        return;
    if(self.chartMode == 1){
        serie[@"type"] = @"candle";
    }else{
        serie[@"type"] = @"line";
    }
}

-(void)setCategory:(NSArray *)category{
    [self.candleChart appendToCategory:category forName:@"price"];
    [self.candleChart appendToCategory:category forName:@"line"];

}

- (void)requestFailed:(ASIHTTPRequest *)request{
    self.status.text = @"Error!";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
