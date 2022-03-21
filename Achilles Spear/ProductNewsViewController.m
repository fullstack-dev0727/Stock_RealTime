//
//  ProductNewsViewController.m
//  Achilles Spear
//
//  Created by KP on 4/14/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "ProductNewsViewController.h"
#import "MBProgressHUD.h"
#import "HelperMethods.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Util.h"

@interface ProductNewsViewController ()

@end

@implementation ProductNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _category = @"Energy";
    newsList =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:[NSString stringWithFormat:@"%@-%@", NEWS, _category]]];
    [_newsCollectionView reloadData];
    [self getCategoryNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getCategoryNews {
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    [HelperMethods getNews:access_token category:[_category lowercaseString] completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response == nil) {

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
                    newsList = response[@"data"];
                    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:newsList] forKey:[NSString stringWithFormat:@"%@-%@", NEWS, _category]];
                    [_newsCollectionView reloadData];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [newsList count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    UIImageView* thumbImageView = (UIImageView*) [cell viewWithTag:1];
    UILabel* timeLabel = (UILabel*) [cell viewWithTag:2];
    UILabel* titleLabel = (UILabel*) [cell viewWithTag:3];
    UILabel* timeAgoLabel = (UILabel*) [cell viewWithTag:4];
    
    NSDictionary* item = newsList[indexPath.row];
    [thumbImageView setImage:[UIImage imageNamed:@"helmet1.png"]];
    [thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [titleLabel setText:item[@"title"]];
    NSString* postTime = [NSString fixedDateTime:item[@"posted_at"]];
    [timeLabel setText:[NSString getTimeFromDate:postTime]];
    
    NSDate* postedDate = [NSString getDateFromString:postTime];
    [timeAgoLabel setText:[NSString stringWithFormat:@"%@ ago",[NSString remaningTime:postedDate endDate:[NSDate date]]]];

    NSString* imageUrl = item[@"img_url"];
    if (imageUrl != nil && (NSString *)[NSNull null] != imageUrl) {
        [thumbImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:nil
                                   options:SDWebImageProgressiveDownload
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      
                                  }
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_contentView.frame.size.width - 10) / 3, (_contentView.frame.size.width - 10) / 3);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* item = newsList[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: item[@"url"]]];
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
