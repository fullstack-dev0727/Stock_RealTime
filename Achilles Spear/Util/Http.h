//
//  Http.h
//  PlanSource
//
//  Created by Jonathan Chandler on 10/16/14.
//  Copyright (c) 2014 PlanSource. All rights reserved.
//

#import "Serializable.h"

// Error handling
BOOL is200(NSURLResponse* response);
BOOL isOffline(NSError* error);
BOOL isTimeout(NSError* error);

//NSDictionary* jsonResponse(NSURLResponse* response, NSData* data, NSError** error);
//NSError* httpError(NSURLResponse* response, NSData* data, NSError* error);


// Requests
typedef enum
{
  HttpGet,
  HttpPost,
  HttpPut,
  HttpDelete
} HttpMethod;

typedef enum
{
  ContentTypeForm,
  ContentTypeJson,
  ContentTypeMultipart
} ContentType;


NSURLRequest*
httpGetRequest(NSURL* url, NSDictionary* params, NSDictionary* otherHeaders);
NSURLRequest* httpRequest(NSURL* url, HttpMethod method, ContentType contentType,
                          NSDictionary* params, NSDictionary* otherHeaders);

NSDictionary* queryParameters(NSURL* url);
NSString* basicAuth(NSString* username, NSString* password);
void clearCookies();


// Multipart attachments
typedef enum
{
    MediaInvalid,
    MediaImage,
    MediaGif,
    MediaVideo
} MediaType;

typedef enum
{
    MimeTypeJPEG,
    MimeTypePNG,
    MimeTypeGif,
    MimeTypeMOV,
    MimeTypeMP4
} MimeType;


@interface Attachment
: NSObject <Serializable>

//---- SETUP
- (id)initWithObject:(NSData*)data fileName:(NSString*)fileName filePath:(NSString*)filePath mimeType:(MimeType)mimeType;

//---- MEMBERS
@property (readonly) NSData* data;
@property (readonly) NSString* fileName;
@property (readonly) NSString* filePath;
@property (nonatomic, strong) NSString* micrositeUrl;
@property (nonatomic, strong) NSString* micrositeId;

@property (readonly, nonatomic) NSString* mimeType;

@property (readonly, nonatomic) NSString* mediaType;

@end

const static long HTTP_TIMEOUT = 15;
//typedef void (^ShareCompletionBlock)(NSError* error);
typedef void (^ShareCompletionBlock)(NSDictionary* response);
//---- HELPER
MediaType mediaTypeFromExtension(NSString* extension);

