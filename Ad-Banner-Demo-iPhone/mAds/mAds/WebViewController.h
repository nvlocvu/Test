//
//  WebViewController.h
//  mAds
//
//  Created by Loc VK on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *URL;

- (id)initWithURL:(NSString *)url;

@end
