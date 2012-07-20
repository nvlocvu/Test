//
//  XMURLDownloaderDelegate.h
//  XMBase
//
//  Created by Quan Dang Dinh on 8/27/10.
//  Copyright 2010 Nhat Viet Group. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol XMHTTPConnectionManagerDelegate<NSObject>

@required
- (void)startedDownloadWithTag:(NSString *)tag;
- (void)finishedDownloadWithTag:(NSString *)tag downloadedData:(NSMutableData *)data;

@optional
- (void)errorDownloadWithTag:(NSString *)tag error:(NSError *)error;
- (void)canceledDownloadWithTag:(NSString *)tag;

@end

