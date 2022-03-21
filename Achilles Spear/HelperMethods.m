//
//  HelperMethods.m
//  AyahADay
//
//  Created by Nisha Ravindranath on 2015-02-05.
//  Copyright (c) 2015 mpyre. All rights reserved.
//

#import "HelperMethods.h"
#import "Util.h"

@implementation HelperMethods

+(void) addNotificationObserver:(id)observer withName:(NSString *) notificationName useSelector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:notificationName object:nil];
}

+(void) postNotificationWithName: (NSString *) notificationName {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

+(void) postNotificationWithName:(NSString *)notificationName withUserInfoDict: (NSDictionary*) dict {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dict];
}

+(void) postNotificationWithName:(NSString *)notificationName withCategoryId: (NSString*) c_id {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:c_id];
}

+(BOOL) isValidEmail: (NSString*) email
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(id)getUserPreference:(NSString*)forKey
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:forKey];
}
+(void)removeKeyUserPreference:(NSString*)forKey
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs removeObjectForKey:forKey];
    [defs synchronize];
}
+ (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
+(void)setUserPreference:(id)value forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
+ (UIColor*) getStuffColor: (NSString*) category {
    NSData* foregroundColorData = [HelperMethods getUserPreference:category];
    UIColor* color = [NSKeyedUnarchiver unarchiveObjectWithData:foregroundColorData];
    return color;
}
+ (void) setColorThemeData {
    NSInteger firstTime = [[HelperMethods getUserPreference:FIRSTTIME] integerValue];
    if (firstTime == 0) {
        UIColor* backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        UIColor* lineColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
        UIColor* textColor = [UIColor whiteColor];
        UIColor* divLineColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundColor];
        [HelperMethods setUserPreference:backgroundColorData forKey:BACKGROUND];
        
        NSData *lineColorData = [NSKeyedArchiver archivedDataWithRootObject:lineColor];
        [HelperMethods setUserPreference:lineColorData forKey:LINE];
        
        NSData *textColorData = [NSKeyedArchiver archivedDataWithRootObject:textColor];
        [HelperMethods setUserPreference:textColorData forKey:TEXT];
        
        NSData *divLineColorData = [NSKeyedArchiver archivedDataWithRootObject:divLineColor];
        [HelperMethods setUserPreference:divLineColorData forKey:DIVLINE];
        
        [HelperMethods setUserPreference:@1 forKey:FIRSTTIME];
        [HelperMethods setUserPreference:@0 forKey:COLORTHEME];
        [HelperMethods setUserPreference:@30 forKey:LOCKTIME];
    }
}
+ (void) deleteFromFavourites: (NSDictionary*) productInfo {
    NSMutableArray* favouriteProducts =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:FAVOURITES]];
    for (int i = 0; i < [favouriteProducts count]; i ++) {
        NSDictionary* item = favouriteProducts[i];
        if ([item[@"c_id"] isEqualToString:productInfo[@"c_id"]]) {
            [favouriteProducts removeObjectAtIndex:i];
            break;
        }
    }
    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:favouriteProducts] forKey:FAVOURITES];
}
+ (void) addToFavourites: (NSDictionary*) productInfo {
    NSMutableArray* favouriteProducts =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:FAVOURITES]];
    if (favouriteProducts == nil)
        favouriteProducts = [[NSMutableArray alloc] init];
    [favouriteProducts addObject:productInfo];
    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:favouriteProducts] forKey:FAVOURITES];
}
+ (BOOL) existingInFavourites: (NSDictionary*) productInfo {
    NSArray* favouriteProducts=  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:FAVOURITES]];
    if (favouriteProducts == nil)
        return NO;
    for (int i = 0; i < [favouriteProducts count]; i ++) {
        NSDictionary* item = favouriteProducts[i];
        if ([item[@"c_id"] isEqualToString:productInfo[@"c_id"]]) {
            return YES;
        }
    }
    return NO;
}
+ (void) deleteFromWatchList: (NSDictionary*) contractInfo {
    NSMutableArray* watchListContracts =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:WATCHLIST]];
    for (int i = 0; i < [watchListContracts count]; i ++) {
        NSDictionary* item = watchListContracts[i];
        if ([item[@"id"] intValue] == [contractInfo[@"id"] intValue]) {
            [watchListContracts removeObjectAtIndex:i];
            break;
        }
    }
    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:watchListContracts] forKey:WATCHLIST];
}
+ (void) addToWatchList: (NSDictionary*) contractInfo {
    NSMutableArray* watchListContracts =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:WATCHLIST]];
    if (watchListContracts == nil)
        watchListContracts = [[NSMutableArray alloc] init];
    [watchListContracts addObject:contractInfo];
    [HelperMethods setUserPreference:[NSKeyedArchiver archivedDataWithRootObject:watchListContracts] forKey:WATCHLIST];
}
+ (BOOL) existingInWatchList: (NSDictionary*) contractInfo {
    NSArray* watchListContracts=  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:WATCHLIST]];
    if (watchListContracts == nil)
        return NO;
    for (int i = 0; i < [watchListContracts count]; i ++) {
        NSDictionary* item = watchListContracts[i];
        if ([item[@"id"] intValue] == [contractInfo[@"id"] intValue]) {
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary*) getItemDicMenu:(NSString*) c_id {
    NSArray* categoryItems = [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:CATEGORYMENU]];
    if (categoryItems != nil && [categoryItems count] > 0) {
        for (NSDictionary* item in categoryItems) {
            if ([item[@"c_id"] isEqualToString:c_id])
                return item;
        }
    }
    return nil;
}
+ (NSMutableArray*) getProductsForCategory: (NSString*) c_id {
    NSMutableArray* products = [[NSMutableArray alloc] init];
    NSArray* categoryItems =  [NSKeyedUnarchiver unarchiveObjectWithData:[HelperMethods getUserPreference:CATEGORYMENU]];
    for (int i = 0; i < [categoryItems count]; i++) {
        NSDictionary* item = categoryItems[i];
        if ([item[@"is_product"] intValue] == 1 && [item[@"class_id"] hasPrefix:c_id]) {
            [products addObject:item];
        }
    }
    return products;
}
+(void) showMessage: (NSString*) message {
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

+ (void) loginFunc:(NSString*) username_or_email password:(NSString*) password completion:(ShareCompletionBlock)completion {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, LOGIN]];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:username_or_email forKey:@"username_or_email"];
    [params setObject:password forKey:@"password"];
    NSURLRequest* request = httpRequest(url, HttpPost, ContentTypeJson, params, nil);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) signupFunc:(NSString*) email username:(NSString*) username
                                      password:(NSString*) password
                         password_confirmation:(NSString*) password_confirmation
                                    first_name:(NSString*) first_name
                                     last_name:(NSString*) last_name
                          security_question_id:(NSString*) security_question_id
                               security_answer:(NSString*) security_answer
                                    completion:(ShareCompletionBlock)completion {
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, SIGNUP]];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:password_confirmation forKey:@"password_confirmation"];
    [params setObject:first_name forKey:@"first_name"];
    [params setObject:last_name forKey:@"last_name"];
    [params setObject:security_question_id forKey:@"security_question_id"];
    [params setObject:security_answer forKey:@"security_answer"];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setObject:params forKey:@"user"];

    NSURLRequest* request = httpRequest(url, HttpPost, ContentTypeJson, userDic, nil);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) getSecretQuestions:(ShareCompletionBlock)completion {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, SECRET_QUESTIONS]];
    NSURLRequest* request = httpRequest(url, HttpGet, ContentTypeJson, nil, nil);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) getUserSecretQuestions:(NSString*)token completion:(ShareCompletionBlock)completion {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, USER_SECRET_QUESTIONS]];
    NSMutableDictionary* headers = [NSMutableDictionary dictionary];
    [headers setObject:token forKey:@"X-ACCESS-TOKEN"];
    NSURLRequest* request = httpRequest(url, HttpGet, ContentTypeJson, nil, headers);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) authorizeUserSecretQuestions:(NSString*)token security_answer:(NSString*)security_answer completion:(ShareCompletionBlock)completion {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, AUTHORIZE_SECRET_QUESTIONS]];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:security_answer forKey:@"security_answer"];
    NSMutableDictionary* headers = [NSMutableDictionary dictionary];
    [headers setObject:token forKey:@"X-ACCESS-TOKEN"];
    NSURLRequest* request = httpRequest(url, HttpPost, ContentTypeJson, params, headers);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) updateUserSecretQuestions:(NSString*)token security_question_id:(NSString*)security_question_id security_answer:(NSString*)security_answer completion:(ShareCompletionBlock)completion {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, UPDATE_SECRET_QUESTIONS]];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:security_answer forKey:@"security_answer"];
    [params setObject:security_question_id forKey:@"security_question_id"];
    NSMutableDictionary* headers = [NSMutableDictionary dictionary];
    [headers setObject:token forKey:@"X-ACCESS-TOKEN"];
    NSURLRequest* request = httpRequest(url, HttpPost, ContentTypeJson, params, headers);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) getCategoryMenu:(NSString*)token completion:(ShareCompletionBlock)completion {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, GET_MENU]];
    NSMutableDictionary* headers = [NSMutableDictionary dictionary];
    [headers setObject:token forKey:@"X-ACCESS-TOKEN"];
    NSURLRequest* request = httpRequest(url, HttpGet, ContentTypeJson, nil, headers);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) getProductHistory:(NSString*)token contractId:(NSString*)contractId completion:(ShareCompletionBlock)completion {
    NSString* contractKey = [NSString stringWithFormat:GET_PRODUCT_HISTORY, contractId];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, contractKey]];
    NSMutableDictionary* headers = [NSMutableDictionary dictionary];
    [headers setObject:token forKey:@"X-ACCESS-TOKEN"];
    NSURLRequest* request = httpRequest(url, HttpGet, ContentTypeJson, nil, headers);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) getProductContracts:(NSString*)token productId:(NSString*)productId completion:(ShareCompletionBlock)completion {
    NSString* contractKey = [NSString stringWithFormat:GET_PRODUCT_CONTRACTS, productId];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, contractKey]];
    NSMutableDictionary* headers = [NSMutableDictionary dictionary];
    [headers setObject:token forKey:@"X-ACCESS-TOKEN"];
    NSURLRequest* request = httpRequest(url, HttpGet, ContentTypeJson, nil, headers);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (void) getNews:(NSString*)token category:(NSString*)category completion:(ShareCompletionBlock)completion {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:BASEURL, GET_NEWS]];
    NSMutableDictionary* headers = [NSMutableDictionary dictionary];
    [headers setObject:token forKey:@"X-ACCESS-TOKEN"];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:category forKey:@"category"];
    NSURLRequest* request = httpRequest(url, HttpGet, ContentTypeJson, params, headers);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (data == nil)
             return completion(nil);
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
         NSLog(@"RESPONSE:\n%@\n\n", json);
         return completion(json);
     }];
}
+ (UIColor*) getHightLightColor: (UIColor*) color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    if (red > 0.5f)
        red = red - 0.2f;
    else
        red = red + 0.2f;
    
    if (green > 0.5f)
        green = green - 0.2f;
    else
        green = green + 0.2f;
    
    if (blue > 0.5f)
        blue = blue - 0.2f;
    else
        blue = blue + 0.2f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end

