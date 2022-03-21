//
//  Util.mm
//  MyndDot
//
//  Created by Jonathan Chandler on 4/30/14.
//  Copyright (c) 2014 Jonathan Chandler. All rights reserved.
//

#import "Util.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


// View
@implementation UIView(Custom)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    [self setOrigin:CGPointMake(x, self.y)];
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    [self setOrigin:CGPointMake(self.x, y)];
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)point
{
    [self setFrame:CGRectMake(point.x, point.y, self.width, self.height)];
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    [self setSize:CGSizeMake(width, self.height)];
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    [self setSize:CGSizeMake(self.width, height)];
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    [self setFrame:CGRectMake(self.x, self.y, size.width, size.height)];
}

- (CGFloat)right
{
    return [self x] + [self width];
}

- (void)setRight:(CGFloat)right
{
    self.x = right - self.width;
}

- (CGFloat)bottom
{
    return [self y] + [self height];
}

- (void)setBottom:(CGFloat)bottom
{
    self.y = bottom - self.height;
}

- (void)removeSubviews
{
    NSArray* subviews = self.subviews;
    for(int i = 0; i < [subviews count]; ++i)
    {
        UIView* subview = [subviews objectAtIndex:i];
        [subview removeFromSuperview];
    }
}

@end



// Color
@implementation UIColor(Custom)

+ (UIColor*)withRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (UIColor*)adjustBrightness:(float)percent
{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return [UIColor colorWithRed:components[0] * percent
                           green:components[1] * percent
                            blue:components[2] * percent
                           alpha:components[3]];
}

@end



// String
@implementation NSString(Custom)

- (BOOL)contains:(NSString*)str
{
    return [self rangeOfString:str].location != NSNotFound;
}

- (NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)withLong:(long)value
{
    return [NSString stringWithFormat:@"%li", value];
}
+ (NSString*) getDecialFormat:(float) value {
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1]; // Set this if you need 1 digits
    NSString * newString =  [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    return newString;
}
+ (NSString*) fixedDateTime: (NSString*) datetime {
    if (datetime == nil || (NSString *)[NSNull null] == datetime) {
        return @"";
    }
    datetime = [datetime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return [datetime substringToIndex:[datetime length] - 5];
}
+ (NSDate*) getDateFromString: (NSString*) value {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:gmt];
    NSDate *date = [formatter dateFromString:value];
    return date;
}
+ (NSString*) getWeekDayFromDate: (NSString*) dateTime {
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay =  [theDateFormatter stringFromDate:[self getDateFromString:dateTime]];
    return weekDay;
}
+ (NSInteger) getMonthFromDate: (NSString*) dateTime {
    NSDate* date = [self getDateFromString:dateTime];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger month = [components month];
    return month;
}
+ (NSString*) getTimeFromDate: (NSString*) dateTime {
    NSDate* date = [self getDateFromString:dateTime];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    return [NSString stringWithFormat:@"%ld:%ld", hour, minute];
}
+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate{
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSString *durationString;
    
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour=[components hour];
    minutes=[components minute];
    
    if(days>0){
        
        if(days>1){
            durationString=[NSString stringWithFormat:@"%ld days",days];
        }
        else{
            durationString=[NSString stringWithFormat:@"%ld day",days];
            
        }
        return durationString;
    }
    
    if(hour>0){
        
        if(hour>1){
            durationString=[NSString stringWithFormat:@"%ld hours",hour];
        }
        else{
            durationString=[NSString stringWithFormat:@"%ld hour",hour];
            
        }
        return durationString;
    }
    
    if(minutes>0){
        
        if(minutes>1){
            durationString=[NSString stringWithFormat:@"%ld minutes",minutes];
        }
        else{
            durationString=[NSString stringWithFormat:@"%ld minute",minutes];
            
        }
        return durationString;
    }
    
    return @"";
}
+ (NSString*)durationSince:(long)start compressed:(BOOL)compressed
{
    long time = [[NSDate date] timeIntervalSince1970];  // seconds
    int duration = (int)((time - start) / 60);
    
    int count = duration % 60;
    NSString* minutes = [NSString stringWithFormat:@"%i %@", count, [@"minute" pluralize:count]];
    if(duration < 60)
    {
        return minutes;
    }
    
    duration /= 60;
    count = duration % 24;
    NSString* hours = [NSString stringWithFormat:@"%i %@", count, [@"hour" pluralize:count]];
    if(duration < 24)
    {
        if(compressed)
        {
            return hours;
        }
        return [NSString stringWithFormat:@"%@ %@", hours, minutes];
    }
    
    duration /= 24;
    count = duration % 7;
    NSString* days = [NSString stringWithFormat:@"%i %@", count, [@"day" pluralize:count]];
    if(duration < 7)
    {
        if(compressed)
        {
            return days;
        }
        return [NSString stringWithFormat:@"%@ %@", days, hours];
    }
    
    duration /= 7;
    NSString* weeks = [NSString stringWithFormat:@"%i %@", duration, [@"week" pluralize:duration]];
    if(compressed)
    {
        return weeks;
    }
    return [NSString stringWithFormat:@"%@ %@", weeks, days];
}

- (NSString*)pluralize:(int)count
{
    if(count == 1)
    {
        return self;
    }
    
    return [self stringByAppendingString:@"s"];
}

- (NSString*)md5
{
    const char* cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString*)hmacSHA256:(NSString*)key
{
    NSData* keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, inputData.bytes, inputData.length, hash.mutableBytes);
    
    NSString* output = [[NSString alloc] initWithData:hash encoding:NSASCIIStringEncoding];
    return [output toHex];
}

- (NSString*)encodeBase64
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data encodeBase64];
}

- (NSString*)decodeBase64
{
    NSData* data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [data string];
}

- (NSString*)toHex
{
    NSMutableString* hex = [NSMutableString string];
    for(int i = 0; i < [self length]; ++i)
    {
        char buff[10];
        sprintf(buff, "%02x", [self characterAtIndex:i]);
        [hex appendString:[NSString stringWithCString:buff encoding:NSUTF8StringEncoding]];
    }
    
    return hex;
}

@end



// Array
@implementation NSArray(Custom)

- (NSArray*)notFoundIn:(NSArray*)compList
{
    NSMutableArray* missingList = [NSMutableArray array];
    for(int i = 0; i < [self count]; ++i)
    {
        id obj = [self objectAtIndex:i];
        
        BOOL found = NO;
        for(int j = 0; j < [compList count]; ++j)
        {
            id comp = [compList objectAtIndex:j];
            if([obj isEqual:comp])
            {
                found = YES;
                break;
            }
        }
        
        if(!found)
        {
            [missingList addObject:obj];
        }
    }
    
    return missingList;
}

- (id)objectTagged:(NSInteger)tag
{
    for(int i = 0; i < [self count]; ++i)
    {
        id obj = [self objectAtIndex:i];
        if([obj tag] == tag)
        {
            return obj;
        }
    }
    
    return nil;
}

- (NSArray*) arrayWithBase64Strings {
    NSMutableArray* encodedArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    NSObject* encodedValue = @"";
    
    
    for (NSObject* value in self) {

        if ([value isKindOfClass:[NSString class]])
            encodedValue = [(NSString*)value encodeBase64];
        else if ([value isKindOfClass:[NSArray class]])
            encodedValue = [(NSArray*)value arrayWithBase64Strings];
        else if ([value isKindOfClass:[NSDictionary class]])
            encodedValue = [(NSDictionary*)value dictionaryWithBase64Strings];
        else
            encodedValue = value;
        
        [encodedArray addObject:encodedValue];
    }
    
    return [NSArray arrayWithArray:encodedArray];
}

@end



// Error
@implementation NSError(Custom)

+ (NSError*)withDescription:(NSString*)description
{
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey : description};
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:0
                           userInfo:userInfo];
}

+ (NSError*) connectionFailedWithMessage:(NSString*)message {
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey : message};
    return [NSError errorWithDomain:@"NSURLErrorDomain"
                               code:-1009
                           userInfo:userInfo];
}

@end

// Timer
@implementation NSTimer(Custom)

+ (NSTimer*)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats
{
    NSTimer* timer = [self timerWithTimeInterval:timeInterval
                                          target:self
                                        selector:@selector(run:)
                                        userInfo:block
                                         repeats:repeats];
    
    return timer;
}

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)())block repeats:(BOOL)repeats
{
    NSTimer* timer = [self scheduledTimerWithTimeInterval:timeInterval
                                                   target:self
                                                 selector:@selector(run:)
                                                 userInfo:block
                                                  repeats:repeats];
    return timer;
}

+ (void)run:(NSTimer*)timer;
{
    if([timer userInfo])
    {
        void (^block)() = (void (^)())[timer userInfo];
        block();
    }
}

@end



// Data
@implementation NSData(Custom)

- (NSString*)string
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

+ (NSData*)readFile:(NSString*)filePath
{
    NSError* error;
    NSData* data = [[NSData alloc] initWithContentsOfFile:filePath options:0 error:&error];
    if(error)
    {

    }
    
    return data;
}

- (BOOL)writeFile:(NSString*)filePath
{
    createDirectory(filePath);
    
    NSError* error;
    [self writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if(error)
    {
        
    }
    
    return error == nil;
}

- (NSString*)encodeBase64
{
    return [self base64EncodedStringWithOptions:0];
}

- (NSString*)decodeBase64
{
    NSData* data = [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [data string];
}

@end



// FileManager
@implementation NSFileManager(Custom)

+ (NSArray*)filesInDir:(NSString*)dirPath
{
    NSError* error;
    NSFileManager* filemanager = [NSFileManager defaultManager];
    NSArray* contents = [filemanager contentsOfDirectoryAtPath:dirPath error:&error];
    if(error)
    {
        return nil;
    }
    
    NSMutableArray* files = [NSMutableArray array];
    for(int i = 0; i < [contents count]; ++i)
    {
        NSString* filePath = [dirPath stringByAppendingPathComponent:[contents objectAtIndex:i]];
        
        BOOL isDir;
        if([filemanager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
        {
            [files addObject:filePath];
        }
    }
    
    return files;
}

@end



// Dictionary
@implementation NSDictionary(Custom)

- (BOOL)writeFile:(NSString*)filePath
{
    createDirectory(filePath);    
    return [self writeToFile:filePath atomically:YES];
}

- (NSString*)json
{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if(error)
    {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSDictionary*) dictionaryWithBase64Strings {
    NSMutableDictionary* encodedDictionary = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    NSObject* value = nil;
    NSObject* encodedValue = @"";
    
    
    for (NSString* key in self.allKeys) {
        value = [self objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
            encodedValue = [(NSString*)value encodeBase64];
        else if ([value isKindOfClass:[NSArray class]])
            encodedValue = [(NSArray*)value arrayWithBase64Strings];
        else if ([value isKindOfClass:[NSDictionary class]])
            encodedValue = [(NSDictionary*)value dictionaryWithBase64Strings];
        else
            encodedValue = value;
        
        [encodedDictionary setObject:encodedValue forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:encodedDictionary];
}

@end

// Files
NSString* documentsFilePath(NSString* fileName)
{
    NSURL* url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] firstObject];
    return [NSString stringWithFormat:@"%@/%@", [url path], fileName];
}

NSString* resourcesFilePath(NSString* fileName)
{
    NSURL* url = [[NSBundle mainBundle] resourceURL];
    return [NSString stringWithFormat:@"%@/%@", [url path], fileName];
}

NSString* fileExtension(NSString* fileName)
{
    NSArray* components = [fileName componentsSeparatedByString:@"."];
    return [components lastObject];
}

BOOL createDirectory(NSString* filePath)
{
    NSError* error;
    NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.length > 0)
    {
        NSString* dir = [filePath substringToIndex:range.location + range.length];
        
        NSFileManager* mgr = [NSFileManager defaultManager];
        if(![mgr fileExistsAtPath:dir])
        {
            [mgr createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
        
    if(error)
    {
        
    }
    return error == nil;
}

BOOL deleteFile(NSString* filePath)
{
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    
    if(error)
    {
        
    }
    return error == nil;
}



// Validation
BOOL null(id obj)
{
    return obj == nil || [obj isKindOfClass:[NSNull class]];
}

BOOL nullOrEmpty(id obj)
{
    if([obj respondsToSelector:@selector(count)])
    {
        return obj == nil || [obj count] == 0;
    }
    
    if([obj respondsToSelector:@selector(length)])
    {
        return obj == nil || [obj length] == 0;
    }
    
    return null(obj);
}


double clamp(double value, double min, double max)
{
    value = fmax(min, value);
    value = fmin(max, value);
    return value;
}

int32_t bytesToInt(Byte* b)
{
    return (b[0] << 24) | (b[1] << 16) | (b[2] << 8) | b[3];
}
// JSON
NSDictionary* getJSON(NSString* json)
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
