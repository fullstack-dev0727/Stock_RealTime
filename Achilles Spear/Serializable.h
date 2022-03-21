//
//  Serializable.h
//  PicPic Social
//
//  Created by Jonathan Chandler on 11/11/14.
//  Copyright (c) 2014 Ovation Experiential, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol Serializable <NSObject>

//---- FACTORIES
+ (id<Serializable>)fromDictionary:(NSDictionary*)dictionary;

//---- METHODS
- (NSDictionary*)dictionary;

@end
