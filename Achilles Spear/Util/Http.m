//
//  Http.m
//  PlanSource
//
//  Created by Jonathan Chandler on 10/16/14.
//  Copyright (c) 2014 PlanSource. All rights reserved.
//

#import "Http.h"

#import "Util.h"


//---- CONSTANTS
#define MULTIPART_BOUNDARY @"[)===----++++____~__x_Xx__~___~_++++----===(]"



// Error handling
BOOL isOffline(NSError* error)
{
    return [error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1009;
}

BOOL isTimeout(NSError* error)
{
    return [error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1001;
}

BOOL is200(NSURLResponse* response)
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    return statusCode - statusCode % 100 == 200;
}

NSError* httpErrorSub(NSURLResponse* response, NSData* data, NSError* error)
{
    if(error)
    {
        if([(error).domain isEqualToString:@"WebKitErrorDomain"] &&
           (error).code == 102)
        {
            return nil;
        }
        
        return error;
    }
    
    NSDictionary* unknownError = @{NSLocalizedDescriptionKey : @"Unknown server error."};
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:0
                           userInfo:unknownError];
}

NSDictionary* jsonResponse(NSURLResponse* response, NSData* data, NSError** error)
{
    if(data)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
        if(json)
        {
            NSLog(@"RESPONSE:\n%@\n\n", json);
            if(!is200(response))
            {
                NSDictionary* knownError = @{NSLocalizedDescriptionKey : [json objectForKey:@"message"]};
                *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                             code:0
                                         userInfo:knownError];
            }
            
            return json;
        }
    }
    
    *error = httpErrorSub(response, data, *error);
    return nil;
}

NSError* httpError(NSURLResponse* response, NSData* data, NSError* error)
{
    if(is200(response))
    {
        return nil;
    }
    
    return httpErrorSub(response, data, error);
}



// Requests
NSString* httpEncode(NSString* original)
{
    if([original isKindOfClass:[NSNumber class]])
    {
        original = [(NSNumber*)original stringValue];
    }
    
    NSString* encoded = [original stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Encode special characters not handled by above method
    encoded = [encoded stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"^" withString:@"%5E"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"*" withString:@"%2A"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@")" withString:@"%29"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"_" withString:@"%5F"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"." withString:@"%2E"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    
    return encoded;
    return encoded;
}

NSString* query(NSDictionary* params)
{
    NSMutableString* query = [[NSMutableString alloc] init];
    
    NSArray* key = [params allKeys];
    NSArray* value = [params allValues];
    for(int i = 0; i < [key count]; ++i)
    {
        if(i != 0)
        {
            [query appendString:@"&"];
        }
        
        NSString* keyValue = [NSString stringWithFormat:@"%@=%@",
                              [key objectAtIndex:i],
                              httpEncode([value objectAtIndex:i])];
        [query appendString:keyValue];
    }
    
    return query;
}

NSString* methodName(HttpMethod method)
{
    switch(method)
    {
        case HttpGet:
            return @"GET";
            
        case HttpPost:
            return @"POST";
            
        case HttpPut:
            return @"PUT";
            
        case HttpDelete:
            return @"DELETE";
    }
}

NSString* contentTypeName(ContentType contentType)
{
    switch(contentType)
    {
        case ContentTypeForm:
            return @"application/x-www-form-urlencoded";
            
        case ContentTypeJson:
            return @"application/json";
            
        case ContentTypeMultipart:
            return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", MULTIPART_BOUNDARY];
    }
}

// Accepts NSString, NSNumber, and Attachment params
NSData* multipartData(NSDictionary* params)
{
    NSMutableData* data = [NSMutableData data];
    
    NSArray* keys = [params allKeys];
    NSArray* values = [params allValues];
    for(int i = 0; i < [params count]; ++i)
    {
        NSString* key = [keys objectAtIndex:i];
        id value = [values objectAtIndex:i];
        if(null(value))
        {
            continue;
        }
        
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", MULTIPART_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
        {
            [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value]
                              dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else if([value isKindOfClass:[Attachment class]])
        {
            [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, [value fileName]]
                              dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [value mimeType]]
                              dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[value data]];
        }
    }
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", MULTIPART_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSString* postContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"MULTIPART:\n%@", postContent);
    
    return data;
}

NSData* bodyData(ContentType contentType, NSDictionary* params)
{
    switch(contentType)
    {
        case ContentTypeForm:
            return [query(params) dataUsingEncoding:NSUTF8StringEncoding];
            
        case ContentTypeJson:
            return [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
            
        case ContentTypeMultipart:
            return multipartData(params);
    }
}

NSMutableURLRequest*
getBaseRequest(NSURL* url, HttpMethod method)
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:methodName(method)];
    [request setTimeoutInterval:HTTP_TIMEOUT];
    
    // Headers
    [request setValue:@"1" forHTTPHeaderField:@"Is-Device"];
    
    NSLog(@"REQUEST:\n%@\n\n", url);
    return request;
}

NSURLRequest*
httpGetRequest(NSURL* url, NSDictionary* params, NSDictionary* otherHeaders)
{
    // Setup request
    if([params count] > 0)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", url.absoluteString, query(params)]];
    }
    NSMutableURLRequest* request = getBaseRequest(url, HttpGet);
    NSArray* keys = [otherHeaders allKeys];
    NSArray* values = [otherHeaders allValues];
    for(int i = 0; i < [otherHeaders count]; ++i)
    {
        [request setValue:[values objectAtIndex:i] forHTTPHeaderField:[keys objectAtIndex:i]];
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

NSURLRequest*
httpRequest(NSURL* url, HttpMethod method, ContentType contentType,
            NSDictionary* params, NSDictionary* otherHeaders)
{
    if(method == HttpGet)
    {
        return httpGetRequest(url, params, otherHeaders);
    }
    
    // Setup request
    NSMutableURLRequest* request = getBaseRequest(url, method);
    
    // Headers
    [request setValue:contentTypeName(contentType) forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSArray* keys = [otherHeaders allKeys];
    NSArray* values = [otherHeaders allValues];
    for(int i = 0; i < [otherHeaders count]; ++i)
    {
        [request setValue:[values objectAtIndex:i] forHTTPHeaderField:[keys objectAtIndex:i]];
    }
    
    // Body data
    [request setHTTPBody:bodyData(contentType, params)];
    
    return request;
}

NSDictionary*
queryParameters(NSURL* url)
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    // Remove site address
    NSString* path = url.absoluteString;
    NSRange range = [path rangeOfString:@"?"];
    if(range.length == 0)
    {
        return params;
    }
    
    path = [path substringFromIndex:range.location + range.length];
    
    NSArray* pairs = [path componentsSeparatedByString:@"&"];
    for(int i = 0; i < [pairs count]; ++i)
    {
        NSString* pair = [pairs objectAtIndex:i];
        NSArray* components = [pair componentsSeparatedByString:@"="];
        [params setObject:[components objectAtIndex:1] forKey:[components objectAtIndex:0]];
    }
    
    return params;
}

NSString*
basicAuth(NSString* username, NSString* password)
{
    NSString* auth = @"Basic ";
    NSString* cred = [NSString stringWithFormat:@"%@:%@", username, password];
    
    return [auth stringByAppendingString:[cred encodeBase64]];
}

void
clearCookies()
{
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for(NSHTTPCookie* cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookie];
    }
}


// Multipart attachments
NSString* mimeTypeName(MimeType mimeType)
{
    switch(mimeType)
    {
        case MimeTypeJPEG:
            return @"image/jpeg";
        case MimeTypePNG:
            return @"image/png";
        case MimeTypeMOV:
            return @"video/quicktime";
        case MimeTypeMP4:
            return @"video/mp4";
        case MimeTypeGif:
            return @"image/gif";
    }
}



@interface Attachment ()
{
    NSNumber* _mimeType;
}

@end

@implementation Attachment

//---- SETUP
- (id)initWithObject:(NSData*)data fileName:(NSString*)fileName filePath:(NSString*)filePath mimeType:(MimeType)mimeType
{
    self = [super init];
    
    if(self)
    {
        _data = data;
        _fileName = fileName;
        _filePath = filePath;
        _mimeType = @(mimeType);
    }
    
    return self;
}


//---- METHODS
- (NSString*)mimeType
{
    return mimeTypeName(_mimeType.intValue);
}

- (NSString*)mediaType
{
    switch(_mimeType.intValue)
    {
        case MimeTypePNG:
        case MimeTypeJPEG:
            return @"image";
        case MimeTypeGif:
            return @"gif";
        case MimeTypeMOV:
        case MimeTypeMP4:
            return @"video";
    };
    
    return nil;
}


//---- Serializable
+ (id<Serializable>)fromDictionary:(NSDictionary *)dictionary
{
    NSData* data = [dictionary objectForKey:@"data"];
    NSString* fileName = [dictionary objectForKey:@"fileName"];
    NSString* filePath = [dictionary objectForKey:@"filePath"];
    NSNumber* mimeType = [dictionary objectForKey:@"mimeType"];
    
    return [[Attachment alloc] initWithObject:data fileName:fileName filePath:filePath mimeType:mimeType.intValue];
}

- (NSDictionary*)dictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:_data forKey:@"data"];
    [dictionary setObject:_fileName forKey:@"fileName"];
    [dictionary setObject:_filePath forKey:@"filePath"];
    [dictionary setObject:_mimeType forKey:@"mimeType"];
    
    return dictionary;
}

@end


//---- HELPERS
MediaType
mediaTypeFromExtension(NSString* extension)
{
    if([extension isEqualToString:@"jpeg"] ||
       [extension isEqualToString:@"jpg"] ||
       [extension isEqualToString:@"png"])
    {
        return MediaImage;
    }
    
    if ([extension isEqualToString:@"gif"])
    {
        return MediaGif;
    }
    
    if([extension isEqualToString:@"mov"] ||
       [extension isEqualToString:@"mp4"])
    {
        return MediaVideo;
    }
    
    
    
    return MediaInvalid;
}
