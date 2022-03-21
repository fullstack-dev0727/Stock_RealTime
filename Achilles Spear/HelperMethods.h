//
//  HelperMethods.h
//  AyahADay
//
//  Created by Nisha Ravindranath on 2015-02-05.
//  Copyright (c) 2015 mpyre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppConstants.h"
#import "Http.h"

#define ACCESSTOKEN                         @"access_token"
#define USERID                              @"user_id"
#define SECRETQUESTIONS                     @"secret_questions"
#define LOGGEDIN                            @"isloggedin"
#define CATEGORYMENU                        @"category_menu"
#define FAVOURITES                          @"favourites"
#define WATCHLIST                           @"watchlist"
#define PRODUCTHISTORY                      @"product_history%@"
#define PRODUCTHISTORYFORWATCHLIST          @"product_history_watchlist%@"
#define PRODUCT_CONTRACTS                   @"product_contracts%@"
#define NEWS                                @"news"

@interface HelperMethods : NSObject
+(id)getUserPreference:(NSString*)forKey;
+(void)setUserPreference:(id)value forKey:(NSString*)key;
+ (void)resetDefaults;
+(void)removeKeyUserPreference:(NSString*)forKey;
+(void) showMessage: (NSString*) message;
+(BOOL) isValidEmail: (NSString*) email;
+ (void) loginFunc:(NSString*) username_or_email password:(NSString*) password completion:(ShareCompletionBlock)completion;
+ (void) getSecretQuestions:(ShareCompletionBlock)completion;
+ (void) signupFunc:(NSString*) email username:(NSString*) username
                                      password:(NSString*) password
                         password_confirmation:(NSString*) password_confirmation
                                    first_name:(NSString*) first_name
                                     last_name:(NSString*) last_name
                          security_question_id:(NSString*) security_question_id
                               security_answer:(NSString*) security_answer
                                    completion:(ShareCompletionBlock)completion;
+ (void) getUserSecretQuestions:(NSString*)token completion:(ShareCompletionBlock)completion;
+ (void) updateUserSecretQuestions:(NSString*)token security_question_id:(NSString*)security_question_id security_answer:(NSString*)security_answer completion:(ShareCompletionBlock)completion;
+ (void) authorizeUserSecretQuestions:(NSString*)token security_answer:(NSString*)security_answer completion:(ShareCompletionBlock)completion;
+ (void) getCategoryMenu:(NSString*)token completion:(ShareCompletionBlock)completion;
+ (void) getProductHistory:(NSString*)token contractId:(NSString*)contractId completion:(ShareCompletionBlock)completion;
+ (void) getProductContracts:(NSString*)token productId:(NSString*)productId completion:(ShareCompletionBlock)completion;
+ (void) getNews:(NSString*)token category:(NSString*)category completion:(ShareCompletionBlock)completion;
+ (void) deleteFromFavourites: (NSDictionary*) productInfo;
+ (void) addToFavourites: (NSDictionary*) productInfo;
+ (BOOL) existingInFavourites: (NSDictionary*) productInfo;
+ (void) deleteFromWatchList: (NSDictionary*) contractInfo;
+ (void) addToWatchList: (NSDictionary*) contractInfo;
+ (BOOL) existingInWatchList: (NSDictionary*) contractInfo;
+ (UIColor*) getStuffColor: (NSString*) category;
+ (void) setColorThemeData;
+ (UIColor*) getHightLightColor: (UIColor*) color;
+ (NSDictionary*) getItemDicMenu:(NSString*) c_id;
+ (NSMutableArray*) getProductsForCategory: (NSString*) c_id;
+(void) addNotificationObserver:(id)observer withName:(NSString *) notificationName useSelector:(SEL)selector;
+(void) postNotificationWithName: (NSString *) notificationName;
+(void) postNotificationWithName:(NSString *)notificationName withUserInfoDict: (NSDictionary*) dict;
+(void) postNotificationWithName:(NSString *)notificationName withCategoryId: (NSString*) c_id;
@end
