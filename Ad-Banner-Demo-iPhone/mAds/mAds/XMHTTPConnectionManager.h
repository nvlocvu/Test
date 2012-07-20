//
//  XMURLDownloader.h
//  XMBase
//
//  Created by Quan Dang Dinh on 8/27/10.
//  Copyright 2010 Nhat Viet Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMHTTPConnectionManagerDelegate.h"
#import "XMURLConnection.h"

@interface XMHTTPConnectionManager : NSObject {
	
@private
	NSMutableDictionary *_listReceivedData;
	NSMutableDictionary *_listUrlConnection;
	NSMutableDictionary *_listDelegate;
}

- (id)init;

- (id<XMHTTPConnectionManagerDelegate>)getDelegateByTag:(NSString *)tag;

- (id<XMHTTPConnectionManagerDelegate>)getDelegateForConnection:(XMURLConnection *)connection;

- (void)downloadDataFromURL:(NSString *)url withTag:(NSString *)tag delegate:(id<XMHTTPConnectionManagerDelegate>)delegate;

- (void)downloadDataFromURL:(NSString *)url withTag:(NSString *)tag cacheAllowance:(BOOL)cacheAllowance cacheTimeout:(int)cacheTimeout delegate:(id<XMHTTPConnectionManagerDelegate>)delegate;

- (void)postData:(NSString *)data toURL:(NSString *)url withTag:(NSString *)tag delegate:(id <XMHTTPConnectionManagerDelegate>)delegate;

- (void)downloadDataWithConnection:(XMURLConnection *)connection delegate:(id<XMHTTPConnectionManagerDelegate>)delegate;

- (void)cancelDownloadWithTag:(NSString *)tag;

- (void)removeConnectionFromListByTag:(NSString *)tag;

@end
