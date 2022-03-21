//
//  Util.h
//  MyndDot
//
//  Created by Jonathan Chandler on 4/30/14.
//  Copyright (c) 2014 Jonathan Chandler. All rights reserved.
//
#import <UIKit/UIKit.h>
#define ARC4RANDOM_MAX                  0x100000000
#define MENU_WIDTH                      110
#define SUBMENU_WIDTH                   200
#define COLORTHEME                      @"colortheme"
#define FIRSTTIME                       @"firsttime"
#define BACKGROUND                      @"backgroundcolor"
#define TEXT                            @"textcolor"
#define LINE                            @"linecolor"
#define DIVLINE                         @"divlinecolor"
#define LOCKTIME                        @"locktime"
#define STARTTIME                       @"starttime"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]


// View
@interface UIView(Custom)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGPoint origin;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

- (void)removeSubviews;

@end


// Color
@interface UIColor(Custom)

+ (UIColor*)withRGBHex:(UInt32)hex;
- (UIColor*)adjustBrightness:(float)percent;

@end


// String
@interface NSString(Custom)

- (BOOL)contains:(NSString*) str;
- (NSString*)trim;

+ (NSString*)withLong:(long)value;

+ (NSString*)durationSince:(long)start compressed:(BOOL)compressed;
- (NSString*)pluralize:(int)count;

- (NSString*)md5;
- (NSString*)hmacSHA256:(NSString*)key;
- (NSString*)encodeBase64;
- (NSString*)decodeBase64;
- (NSString*)toHex;
+ (NSString*) getDecialFormat:(float) value;
+ (NSString*) fixedDateTime: (NSString*) datetime;
+ (NSDate*) getDateFromString: (NSString*) value;
+ (NSString*) getWeekDayFromDate: (NSString*) dateTime;
+ (NSInteger) getMonthFromDate: (NSString*) dateTime;
+ (NSString*) getTimeFromDate: (NSString*) dateTime;
+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate;
@end


// Array
@interface NSArray(Custom)

- (NSArray*)notFoundIn:(NSArray*)compList;
- (id)objectTagged:(NSInteger)tag;
- (NSArray*) arrayWithBase64Strings;

@end


// Error
@interface NSError(Custom)

+ (NSError*)withDescription:(NSString*)description;
+ (NSError*)connectionFailedWithMessage:(NSString*)message;

@end


// Image
@interface UIImage(Custom)

- (UIImage*)squareImage:(BOOL)showBorders;
- (UIImage*)scaleImage:(float)scale;
- (UIImage*)resizeImage:(CGSize)size;
- (UIImage*)maskImage:(UIImage*)maskImage;
- (UIImage*)overlayImage:(UIImage*)overlayImage;

@end


// ImageView
@interface UIImageView(Custom)

+ (UIImageView*)withImage:(UIImage*)image;

@end


// Button
@interface UIButton(Custom)

+ (UIButton*)withImage:(UIImage*)image;

@end


// Timer
@interface NSTimer(Custom)

+ (NSTimer*)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats;
+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats;

@end


// Data
@interface NSData(Custom)

+ (NSData*)readFile:(NSString*)filePath;
- (BOOL)writeFile:(NSString*)filePath;
- (NSString*)string;

- (NSString*)encodeBase64;
- (NSString*)decodeBase64;

@end


// Dictionary
@interface NSDictionary(Custom)

- (BOOL)writeFile:(NSString*)filePath;

- (NSString*)json;

- (NSDictionary*) dictionaryWithBase64Strings;

@end


// FileManager
@interface NSFileManager(Custom)

+ (NSArray*)filesInDir:(NSString*)dirPath;

@end


// Files
NSString* documentsFilePath(NSString* fileName);
NSString* resourcesFilePath(NSString* fileName);
NSString* fileExtension(NSString* fileName);

BOOL createDirectory(NSString* filePath);
BOOL deleteFile(NSString* filePath);


// Validation
BOOL null(id obj);
BOOL nullOrEmpty(id obj);
BOOL validEmail(NSString* email);


double clamp(double value, double min, double max);
int32_t bytesToInt(Byte* b);
CGSize aspectFit(CGSize limit, CGSize size);


// JSON
NSDictionary* getJSON(NSString* json);
