//
//  ViewController.h
//  mAds
//
//  Created by Loc VK on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mAds.h"
#import "XMHTTPConnectionManager.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface ViewController : UIViewController <UIWebViewDelegate , XMHTTPConnectionManagerDelegate , MFMessageComposeViewControllerDelegate> {
    
    XMHTTPConnectionManager *_urlDownloader;
    mAds *_mAds;
    
    IBOutlet UISegmentedControl *_segmentLanguage;
    IBOutlet UISegmentedControl *_segmentView;
    IBOutlet UIButton *_btnGo;
    
    UIWebView *_webView;
    
    UIView *_adsView;
    
    BOOL _isWeb;
    BOOL _haveImage;
}

@property (nonatomic, retain) NSString *ImagePath;

- (IBAction)loadAds;


@end
