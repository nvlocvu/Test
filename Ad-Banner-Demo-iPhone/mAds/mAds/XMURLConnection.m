//
//  XMURLConnection.m
//  XMBase
//
//  Created by Quan Dang Dinh on 8/27/10.
//  Copyright 2010 Nhat Viet Group. All rights reserved.
//

#import "XMURLConnection.h"

#pragma mark Class implementation
@implementation XMURLConnection

@synthesize Tag = _tag;
@synthesize UsePOST = _usePOST;

#pragma mark Constructors
- (id)initWithURL:(NSString *)url tag:(NSString *)tag usePOST:(BOOL)usePOST{
	if (self = [super init]) {
		_tag = [tag retain];
		_usePOST = usePOST;
		_parameterList = [[NSDictionary alloc] init];
	}
	
	return self;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSString *)tag{
	if (self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately]) {
		_tag = [tag retain];
		_usePOST = NO;
		_parameterList = [[NSDictionary alloc] init];
	}
	
	return self;
}

- (void)prepareConnection{

}

#pragma mark Parameters hander functions
- (void)addParameter:(NSString *)parameterName withValue:(id)value{
	[_parameterList setValue:value forKey:parameterName];
}

- (void)removeParameter:(NSString *)parameterName{
    [_parameterList setNilValueForKey:parameterName];
}

- (id)getValueForParameter:(NSString *)parameterName{
    return [_parameterList valueForKey:parameterName];
}

#pragma mark Destructor
- (void)dealloc{
	[_tag release];
	[_parameterList release];
	[super dealloc];
}
@end
