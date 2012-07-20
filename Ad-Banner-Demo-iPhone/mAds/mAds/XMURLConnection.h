//
//  XMURLConnection.h
//  XMBase
//
//  Created by Quan Dang Dinh on 8/27/10.
//  Copyright 2010 Nhat Viet Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MESSAGE_GET_CONNECTION_INVALID_PRAMETER_VALUE @"Current instant of XMURLConnection using GET method. Parameter values must be string instead of others."

@interface XMURLConnection : NSURLConnection {
	@private
	NSString *_tag;
	BOOL _usePOST;
    NSDictionary *_parameterList;
}

@property (nonatomic, retain) NSString *Tag;
@property (nonatomic) BOOL UsePOST;
 
- (id)initWithURL:(NSString *)url tag:(NSString *)tag usePOST:(BOOL)usePOST;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSString *)tag;

- (void)addParameter:(NSString *)parameterName withValue:(id)value;

- (void)removeParameter:(NSString *)parameterName;

- (id)getValueForParameter:(NSString *)parameterName;

@end
