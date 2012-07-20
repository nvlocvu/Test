//
//  mAds.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "mAds.h"


@implementation mAds

@synthesize ImageResource;
@synthesize Click2Call;
@synthesize Click2Email;
@synthesize Click2SMS;
@synthesize Click2Video;
@synthesize CallNumber;
@synthesize Email_To;
@synthesize Email_CC;
@synthesize Email_BCC;
@synthesize Email_Subject;
@synthesize Email_Text;
@synthesize SMSNumber;
@synthesize SMSText;
@synthesize URL;


- (void) dealloc {
	
    [ImageResource release];
    [CallNumber release];
    [Email_To release];
    [Email_CC release];
    [Email_BCC release];
    [Email_Subject release];
    [Email_Text release];
    [SMSNumber release];
    [SMSText release];
    [URL release];
    
    [super dealloc];
}

@end







	
	