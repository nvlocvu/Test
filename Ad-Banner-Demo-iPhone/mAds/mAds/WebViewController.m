//
//  WebViewController.m
//  mAds
//
//  Created by Loc VK on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController (Private)

- (void)loadWebWithURL;

@end

@implementation WebViewController

@synthesize webView;
@synthesize URL;

#pragma mark -
#pragma mark Init

- (id)initWithURL:(NSString *)url{
    self = [super init];
    
    if (self) {
        self.URL = url;
    }

    return self;
}

#pragma mark -
#pragma mark View Delegate

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadWebWithURL];
}

#pragma mark -
#pragma mark Private Function

- (void)loadWebWithURL{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
	NSURL *__url = [[NSURL alloc] initWithString:self.URL];
    NSMutableURLRequest *__request = [NSMutableURLRequest requestWithURL:__url]; 
    [__request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
	[self.webView loadRequest:__request];
	[__url release];	
    
}

#pragma mark -
#pragma mark Memory Manager




@end
