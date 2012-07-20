//
//  ViewController.m
//  mAds
//
//  Created by Loc VK on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "XMLParser.h"
#import "WebViewController.h"
#import "MailController.h"
#import "MovieViewController.h"


@interface ViewController (Private)

- (void)loadXMLWithData:(NSData *)data;
- (void)showAds;
- (void)removeAds;
- (void)autoLoadAds;

@end

@implementation ViewController

@synthesize ImagePath;

#pragma mark -
#pragma mark View Delegate

- (void)viewDidLoad{
    [super viewDidLoad];
    [self autoLoadAds];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self removeAds];
}

#pragma mark -
#pragma mark Web View Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (_urlDownloader == nil) {
        _urlDownloader = [[XMHTTPConnectionManager alloc] init];
    }
    
    NSArray *__paths = NSSearchPathForDirectoriesInDomains(
                                                           NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *__documentsDirectory = [__paths objectAtIndex:0];
    
    NSFileManager *__fileManger = [NSFileManager defaultManager];
    
    NSString *__tempXML = [_webView stringByEvaluatingJavaScriptFromString:@" function getiAd(){ var descendants = document.getElementsByTagName('iad'); if(descendants.length) {  return descendants[0].innerHTML;} return null} getiAd(); "];
    
    
    if ([__tempXML isEqualToString:@""]) {
        _isWeb = YES;
        
        NSString *__strImage = [_webView stringByEvaluatingJavaScriptFromString:@"function getTabImage(){ var descendants = document.getElementsByTagName('img'); if(descendants.length) {  return descendants[0].getAttribute('src');} return null} getTabImage(); "];
        
        NSString *__tag = [__strImage stringByReplacingOccurrencesOfString:@":" withString:@""];
        __tag = [__tag stringByReplacingOccurrencesOfString:@"/" withString:@""];
        __tag = [__tag stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        self.ImagePath = [__documentsDirectory stringByAppendingPathComponent: 
                               [NSString stringWithFormat: @"%@.jpg",__tag] ];
        
        if ([__fileManger fileExistsAtPath:self.ImagePath] ) {
            [self showAds];
        }
        else {
            [_urlDownloader downloadDataFromURL:__strImage withTag:__tag delegate:self];
        }
    }
    else {
        _isWeb = NO;
        
        NSString *__strImage = [_webView stringByEvaluatingJavaScriptFromString:@"function getTabImage(){ var descendants = document.getElementsByTagName('img'); if(descendants.length) {  return descendants[descendants.length-1].getAttribute('src');} return null} getTabImage(); "];
        
        NSString *__strImageXML = [NSString stringWithFormat:@"<img>%@</img>",__strImage];
        
        NSString *__click2Call = [_webView stringByEvaluatingJavaScriptFromString:@" function getiAd(){ var descendants = document.getElementsByTagName('click2call'); if(descendants.length) {  return descendants[0].innerHTML;} return null} getiAd(); "];
        __click2Call = [__click2Call stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        __click2Call = [__click2Call stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        __click2Call = [__click2Call stringByReplacingOccurrencesOfString:@" " withString:@""];
        __click2Call = [__click2Call stringByReplacingOccurrencesOfString:@"phonenumber" withString:@"callnumber"];
        __click2Call = [NSString stringWithFormat:@"<click2call>%@</click2call>",__click2Call];
        
        NSString *__click2Email = [_webView stringByEvaluatingJavaScriptFromString:@" function getiAd(){ var descendants = document.getElementsByTagName('click2mail'); if(descendants.length) {  return descendants[0].innerHTML;} return null} getiAd(); "];
        __click2Email = [__click2Email stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        __click2Email = [__click2Email stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        __click2Email = [NSString stringWithFormat:@"<click2mail>%@</click2mail>",__click2Email];
        
        NSString *__click2SMS = [_webView stringByEvaluatingJavaScriptFromString:@" function getiAd(){ var descendants = document.getElementsByTagName('click2sms'); if(descendants.length) {  return descendants[0].innerHTML;} return null} getiAd(); "];
        __click2SMS = [__click2SMS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        __click2SMS = [__click2SMS stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        __click2SMS = [__click2SMS stringByReplacingOccurrencesOfString:@"phonenumber" withString:@"smsnumber"];
        __click2SMS = [__click2SMS stringByReplacingOccurrencesOfString:@"text" withString:@"smstext"];
        __click2SMS = [NSString stringWithFormat:@"<click2sms>%@</click2sms>",__click2SMS];
        
        NSString *__click2Video = [_webView stringByEvaluatingJavaScriptFromString:@" function getiAd(){ var descendants = document.getElementsByTagName('click2video'); if(descendants.length) {  return descendants[0].innerHTML;} return null} getiAd(); "];
        __click2Video = [__click2Video stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        __click2Video = [__click2Video stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        __click2Video = [NSString stringWithFormat:@"<click2video>%@</click2video>",__click2Video];
        
        NSString *__result = [NSString stringWithFormat:@"<iad>%@%@%@%@%@</iad>",__strImageXML,__click2Call,__click2Email,__click2SMS,__click2Video];
        
        NSData *__data = [__result dataUsingEncoding:NSUTF8StringEncoding];
        
        [self loadXMLWithData:__data];
        
        if ([__strImage isEqualToString:@""]) {
            _haveImage = NO;
            [self showAds];
        }
        else {
            _haveImage = YES;
            NSString *__tag = [__strImage stringByReplacingOccurrencesOfString:@":" withString:@""];
            __tag = [__tag stringByReplacingOccurrencesOfString:@"/" withString:@""];
            __tag = [__tag stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            
            self.ImagePath = [__documentsDirectory stringByAppendingPathComponent: 
                              [NSString stringWithFormat: @"%@.jpg",__tag] ];
            
            if ([__fileManger fileExistsAtPath:self.ImagePath] ) {
                [self showAds];
            }
            else {
                [_urlDownloader downloadDataFromURL:__strImage withTag:__tag delegate:self];
            }
        }
    }
}

#pragma mark -
#pragma mark XMHTTPConnectionManager Handlers
- (void)finishedDownloadWithTag:(NSString *)tag downloadedData:(NSMutableData *)data{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIImage *__image = [UIImage imageWithData:data];
    [UIImagePNGRepresentation(__image) writeToFile:self.ImagePath atomically:YES];
    
    [self showAds];
}

- (void)startedDownloadWithTag:(NSString *)tag{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)errorDownloadWithTag:(NSString *)tag error:(NSError *)error{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark Private Function

- (void)loadXMLWithData:(NSData *)data{
    
    if (_mAds != nil) {
        [_mAds release];
        _mAds = nil;
    }
    _mAds = [[mAds alloc] init];
    
    XMLParser *__parseDelegate = [[XMLParser alloc] initXMLParserWithObject:_mAds];
    
    NSXMLParser *__XMLParser = [[NSXMLParser alloc] initWithData:data];
    [__XMLParser setDelegate:__parseDelegate];
    
    [__XMLParser parse];
}

- (void)autoLoadAds{
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 200, 320, 400);
    _webView.delegate = self;
    
    NSString *__strHTML = [NSString stringWithFormat:@"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head></head> <body><script language=\"javascript\">document.write('<scr'+'ipt language=\"javascript1.1\" src=\"http://a.adtech.de/addyn/3.0/780.1/0/0/-1/ADTECH;loc=100;grp=[group];alias=home-en-middle-4;misc='+new Date().getTime()+'\"></scri'+'pt>');</script></body></html>"];
    
    [_webView loadHTMLString:__strHTML baseURL:nil];
}

- (IBAction)loadAds{
    
    [self removeAds];
    
    NSString *__language = nil;
    NSString *__viewHomeOrList = nil;
    
    NSInteger __indexLanguage = _segmentLanguage.selectedSegmentIndex;
    NSInteger __indexView = _segmentView.selectedSegmentIndex;
    
    switch (__indexLanguage) {
		case 0:{
            __language = @"en";
        }
			break;
            
		case 1:{
            __language = @"it";
        }
			break;
            
		case 2:{
            __language = @"de";
        }
			break;
            
        case 3:{
            __language = @"fr";
        }
			break;
            
		default:
			break;
	}
    
    switch (__indexView) {
		case 0:{
            __viewHomeOrList = @"home";
        }
			break;
            
		case 1:{
            __viewHomeOrList = @"list";
        }
			break;
        default:
			break;
	}
    
    UIScreen *__mainScreen = [UIScreen mainScreen];
    UIScreenMode *__screenMode = [__mainScreen currentMode];
    CGSize __size = [__screenMode size]; 
    
    int __screenSize = 1;
    
    if (__size.height == 480){
        __screenSize = 4;
    }
    else if (__size.height == 960) {
        __screenSize = 5;
    }
    else if (__size.height == 1024) {
        __screenSize = 4;
    }
    
    
    
    
    
    NSString *__strHTML = [NSString stringWithFormat:@"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head></head> <body><script language=\"javascript\">document.write('<scr'+'ipt language=\"javascript1.1\" src=\"http://a.adtech.de/addyn/3.0/780.1/0/0/-1/ADTECH;loc=100;grp=[group];alias=%@-%@-middle-%d;misc='+new Date().getTime()+'\"></scri'+'pt>');</script></body></html>",__viewHomeOrList,__language,__screenSize];
    
    [_webView loadHTMLString:__strHTML baseURL:nil];

}

- (void)removeAds{
    [self.navigationController setNavigationBarHidden:NO];
    if (_adsView != nil) {
        if ([_adsView superview]) {
            [_adsView removeFromSuperview];
            _adsView = nil;
        }
    }
}

- (void)showAds{
    
    if (_adsView != nil) {
        [_adsView release];
        _adsView = nil;
    }
    _adsView = [[UIView alloc] init];
    
    UIButton *__btnAction = [[UIButton alloc] init];
    UIButton *__btnClose = [[UIButton alloc] init];
    
    if (_isWeb) {
        [self.navigationController setNavigationBarHidden:YES];
        UIImage *__image = [UIImage imageWithContentsOfFile:self.ImagePath];
        CGFloat __flameWidth;
        CGFloat __flameHeight;
        
        if (__image.size.width > 320) {
            __flameWidth = 320;
            __flameHeight = 320 * __image.size.height / __image.size.width;
        }
        
        if (__image.size.height > 300) {
            _adsView.frame = CGRectMake(0, 0, __flameWidth, __flameHeight);
        }
        else {
            _adsView.frame = CGRectMake(0, 300, __flameWidth, __flameHeight);
        }
        
        __btnAction.frame = CGRectMake(0, 0, __flameWidth, __flameHeight);
        [__btnAction setBackgroundImage:__image forState:UIControlStateNormal];
        [__btnAction addTarget:self action:@selector(click2WebView) forControlEvents:UIControlEventTouchUpInside];
        
        __btnClose.frame = CGRectMake(250, 30, 43, 43);
        [__btnClose setBackgroundImage:[UIImage imageNamed:@"close_Notification.png"] forState:UIControlStateNormal];
        [__btnClose addTarget:self action:@selector(removeAds) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        if (_haveImage) {
            UIImage *__image = [UIImage imageWithContentsOfFile:self.ImagePath];
            CGFloat __flameWidth;
            CGFloat __flameHeight;
            
            if (__image.size.width > 320) {
                __flameWidth = 320;
                __flameHeight = 320 * __image.size.height / __image.size.width;
            }
            
            if (__image.size.height > 300) {
                _adsView.frame = CGRectMake(0, 0, __flameWidth, __flameHeight);
            }
            else {
                _adsView.frame = CGRectMake(0, 300, __flameWidth, __flameHeight);
            }
            
            __btnAction.frame = CGRectMake(0, 0, __flameWidth, __flameHeight);
            [__btnAction setBackgroundImage:__image forState:UIControlStateNormal];
            
            if (_mAds.Click2Call) {
                [__btnAction addTarget:self action:@selector(click2Call) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (_mAds.Click2Email) {
                [__btnAction addTarget:self action:@selector(click2Email) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (_mAds.Click2SMS) {
                [__btnAction addTarget:self action:@selector(click2SMS) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (_mAds.Click2Video) {
                [__btnAction addTarget:self action:@selector(click2Video) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        else {
            _adsView.frame = CGRectMake(0, 300, 320, 100);
            __btnAction.frame = CGRectMake(133.5, 0, 53, 46);
            
            if (_mAds.Click2Call) {
                [__btnAction addTarget:self action:@selector(click2Call) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (_mAds.Click2Email) {
                [__btnAction setBackgroundImage:[UIImage imageNamed:@"10.png"] forState:UIControlStateNormal];
                [__btnAction addTarget:self action:@selector(click2Email) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (_mAds.Click2SMS) {
                [__btnAction setBackgroundImage:[UIImage imageNamed:@"16.png"] forState:UIControlStateNormal];
                [__btnAction addTarget:self action:@selector(click2SMS) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (_mAds.Click2Video) {
                [__btnAction addTarget:self action:@selector(click2Video) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    [_adsView addSubview:__btnAction];
    [__btnAction release];
    
    if (_isWeb) {
        [_adsView addSubview:__btnClose];
    }
    [__btnClose release];
    
    [self.view addSubview:_adsView];
    [_adsView release];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled){
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent"); 
    }
    else {
        NSLog(@"Message failed"); 
    }
}


#pragma mark -
#pragma mark Action From Ads

- (void)click2WebView{
    NSLog(@"Web");
    [self.navigationController setNavigationBarHidden:NO];
    NSString *__click2URL  = [_webView stringByEvaluatingJavaScriptFromString:@"function getTabA(){ var descendants = document.getElementsByTagName('a'); if(descendants.length) {  return descendants[0].getAttribute('href');} return null} getTabA(); "];
    
    WebViewController *__webView = [[WebViewController alloc] initWithURL:__click2URL];
    [self.navigationController pushViewController:__webView animated:YES];
    [__webView release];
}

- (void)click2Call{
    NSLog(@"Call : %@",_mAds.CallNumber);
    NSString * __urlPhoneOffice = [NSString stringWithFormat:@"tel://%@",_mAds.CallNumber];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: __urlPhoneOffice]];
    
}

- (void)click2Email{
    NSLog(@"Email : %@",_mAds.Email_To);
    
    MailController *__mailView = [[MailController alloc] init];
    __mailView.rootController = self;
    [__mailView showPickerComposeMail:_mAds.Email_To EmailCC:_mAds.Email_CC EmailBCC:_mAds.Email_BCC EmailBody:_mAds.Email_Text EmailSubject:_mAds.Email_Subject];
}

- (void)click2SMS{
    
    NSLog(@"SMS : %@",_mAds.SMSNumber);
    
    NSArray *__arrayNumber = [[NSArray alloc] initWithObjects:_mAds.SMSNumber, nil];
    
    MFMessageComposeViewController *__controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    
    if([MFMessageComposeViewController canSendText]){
        __controller.body = _mAds.SMSText;    
        __controller.recipients = __arrayNumber;
        __controller.messageComposeDelegate = self;
        [self presentModalViewController:__controller animated:YES];
    }   
    [__arrayNumber release];
}

- (void)click2Video{
    NSLog(@"Video : %@",_mAds.URL);
    MovieViewController *__movieView = [[[MovieViewController alloc] initWithPath:_mAds.URL] autorelease];
    [self presentModalViewController:__movieView animated:YES];
    [__movieView readyPlayer];  
}

#pragma mark -
#pragma mark Memory Manager


@end
