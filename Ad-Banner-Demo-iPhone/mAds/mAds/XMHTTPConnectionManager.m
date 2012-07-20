//
//  XMURLDownloader.m
//  XMBase
//
//  Created by Quan Dang Dinh on 8/27/10.
//  Copyright 2010 Nhat Viet Group. All rights reserved.
//

#import "XMHTTPConnectionManager.h"
#import "XMHTTPConnectionManagerDelegate.h"
#import "XMURLConnection.h"

@interface XMHTTPConnectionManager (Private)

- (NSMutableData *)getDataForConnection:(XMURLConnection *)connection;

- (NSMutableData *)getDataByTag:(NSString *)tag;

@end

@implementation XMHTTPConnectionManager

#pragma mark Constructors

- (id)init{
    self = [super init];
	if (self) {
		if (_listReceivedData == nil) {
			_listReceivedData = [[NSMutableDictionary alloc] init];
		}
		if (_listDelegate == nil) {
			_listDelegate = [[NSMutableDictionary alloc] init];
		}
		if (_listUrlConnection == nil) {
			_listUrlConnection = [[NSMutableDictionary alloc] init];
		}
	}
	
	return self;
}

#pragma mark Private Functions
- (NSMutableData *)getDataForConnection:(XMURLConnection *)connection{
	return [self getDataByTag:connection.Tag];
}

- (NSMutableData *)getDataByTag:(NSString *)tag{
	return [_listReceivedData objectForKey:tag];
}

- (id<XMHTTPConnectionManagerDelegate>)getDelegateByTag:(NSString *)tag{
	return [_listDelegate objectForKey:tag];
}

- (id<XMHTTPConnectionManagerDelegate>)getDelegateForConnection:(XMURLConnection *)connection{
	return [self getDelegateByTag:connection.Tag];
}

- (XMURLConnection *)getConnectionByTag:(NSString *)tag{
	return [_listUrlConnection objectForKey:tag];
}

- (void)removeConnectionFromListByTag:(NSString *)tag{
	// Remove URLConnection, Delegate, ReceivedData from the list by tag
	[_listReceivedData removeObjectForKey:tag];
	[_listDelegate removeObjectForKey:tag];
	[_listUrlConnection removeObjectForKey:tag];
}

#pragma mark NSURLConnection delegate handlers
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSMutableData *dataForConnection = [self getDataForConnection:(XMURLConnection*)connection];
	[dataForConnection setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSMutableData *dataForConnection = [self getDataForConnection:(XMURLConnection*)connection];
	[dataForConnection appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	XMURLConnection *__currentConnection = (XMURLConnection *)connection;
	NSMutableData *__receivedData = [self getDataForConnection:__currentConnection];
	id<XMHTTPConnectionManagerDelegate> __currentDelegate = [self getDelegateForConnection:__currentConnection];
	
    if (__currentDelegate && [__currentDelegate respondsToSelector:@selector(finishedDownloadWithTag:downloadedData:)]) {
		[__currentDelegate finishedDownloadWithTag:__currentConnection.Tag downloadedData:__receivedData];
		
		[self removeConnectionFromListByTag:__currentConnection.Tag];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	XMURLConnection *__currentConnection = (XMURLConnection *)connection;
	id<XMHTTPConnectionManagerDelegate> __currentDelegate = [self getDelegateForConnection:__currentConnection];
	
	if (__currentDelegate && [__currentDelegate respondsToSelector:@selector(errorDownloadWithTag:error:)]) {
		[__currentDelegate errorDownloadWithTag:__currentConnection.Tag error:error];
		
		[self removeConnectionFromListByTag:__currentConnection.Tag];
	}
}

#pragma mark Custom delegate handlers
- (void)downloadDataFromURL:(NSString *)url withTag:(NSString *)tag delegate:(id<XMHTTPConnectionManagerDelegate>)delegate{
	
	NSURL *__url = [NSURL URLWithString:url];  
	NSMutableURLRequest* __newRequest = [[NSMutableURLRequest alloc] initWithURL:__url]; 
	[__newRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
	//NSURLRequest *__newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	XMURLConnection *__newConnection = [[XMURLConnection alloc] initWithRequest:__newRequest delegate:self startImmediately:YES tag:tag];

	if (__newConnection) {
		[_listReceivedData setObject:[NSMutableData data] forKey:tag];
		[_listDelegate setObject:delegate forKey:tag];
		[_listUrlConnection setObject:__newConnection forKey:tag];
		
		if (delegate && [delegate respondsToSelector:@selector(startedDownloadWithTag:)]) {
			[delegate startedDownloadWithTag:tag];
		}
	}
	
	[__newConnection release];
	[__newRequest release];
}

- (void)downloadDataFromURL:(NSString *)url withTag:(NSString *)tag cacheAllowance:(BOOL)cacheAllowance cacheTimeout:(int)cacheTimeout delegate:(id<XMHTTPConnectionManagerDelegate>)delegate{
	NSURLRequest *__newRequest;
	if (cacheAllowance) {
		__newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:cacheTimeout];
	}
	else {
		__newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	}

	XMURLConnection *__newConnection = [[XMURLConnection alloc] initWithRequest:__newRequest delegate:self startImmediately:YES tag:tag];
	
	if (__newConnection) {
		[_listReceivedData setObject:[NSMutableData data] forKey:tag];
		[_listDelegate setObject:delegate forKey:tag];
		[_listUrlConnection setObject:__newConnection forKey:tag];
		
		if (delegate && [delegate respondsToSelector:@selector(startedDownloadWithTag:)]) {
			[delegate startedDownloadWithTag:tag];
		}
	}
	
	[__newConnection release];
	[__newRequest release];
}

- (void)postData:(NSString *)data toURL:(NSString *)url withTag:(NSString *)tag delegate:(id <XMHTTPConnectionManagerDelegate>)delegate{
	NSMutableURLRequest *__newRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	NSData *__requestData = [data dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	
	[__newRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[__newRequest setValue:[@"" stringByAppendingFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
	[__newRequest setHTTPMethod:@"POST"];
	[__newRequest setHTTPBody:__requestData];
	
	XMURLConnection *__newConnection = [[XMURLConnection alloc] initWithRequest:__newRequest delegate:self startImmediately:YES tag:tag];
	
	if (__newConnection) {
		[_listReceivedData setObject:[NSMutableData data] forKey:tag];
		[_listDelegate setObject:delegate forKey:tag];
		[_listUrlConnection setObject:__newConnection forKey:tag];
		
		if (delegate && [delegate respondsToSelector:@selector(startedDownloadWithTag:)]) {
			[delegate startedDownloadWithTag:tag];
		}
	}
	
	[__newConnection release];
	[__newRequest release];
}

- (void)downloadDataWithConnection:(XMURLConnection *)connection delegate:(id<XMHTTPConnectionManagerDelegate>)delegate{
	if (connection) {
		[_listReceivedData setObject:[NSMutableData data] forKey:connection.Tag];
		[_listDelegate setObject:delegate forKey:connection.Tag];
		[_listUrlConnection setObject:connection forKey:connection.Tag];
		
		if (delegate && [delegate respondsToSelector:@selector(startedDownloadWithTag:)]) {
			[delegate startedDownloadWithTag:connection.Tag];
		}
	}
}

- (void)cancelDownloadWithTag:(NSString *)tag{
	XMURLConnection *__connectionToBeCanceled = [self getConnectionByTag:tag];
	[__connectionToBeCanceled cancel];
	id<XMHTTPConnectionManagerDelegate> __delegateToBeNotified = [self getDelegateByTag:tag];
	if (__delegateToBeNotified && [__delegateToBeNotified respondsToSelector:@selector(canceledDownloadWithTag:)]) {
		[__delegateToBeNotified canceledDownloadWithTag:tag];
	}
	
	[self removeConnectionFromListByTag:tag];
}

#pragma mark Destructor
- (void)dealloc{
	[_listReceivedData release];
	[_listDelegate release];
	[_listUrlConnection release];
	
	[super dealloc];
}
@end
