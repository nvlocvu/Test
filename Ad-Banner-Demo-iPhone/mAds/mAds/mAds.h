//
//  mAds.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>


@interface mAds : NSObject {

    NSString *ImageResource;
    
    BOOL Click2Call;
    BOOL Click2Email;
    BOOL Click2SMS;
    BOOL Click2Video;
    
    NSString *CallNumber;
    
    NSString *Email_To;
    NSString *Email_CC;
    NSString *Email_BCC;
    NSString *Email_Subject;
    NSString *Email_Text;
    
    NSString *SMSNumber;
    NSString *SMSText;
    
    NSString *URL;
}

@property (nonatomic, retain) NSString *ImageResource;
@property (nonatomic, retain) NSString *CallNumber;
@property (nonatomic, retain) NSString *Email_To;
@property (nonatomic, retain) NSString *Email_CC;
@property (nonatomic, retain) NSString *Email_BCC;
@property (nonatomic, retain) NSString *Email_Subject;
@property (nonatomic, retain) NSString *Email_Text;
@property (nonatomic, retain) NSString *SMSNumber;
@property (nonatomic, retain) NSString *SMSText;
@property (nonatomic, retain) NSString *URL;

@property (nonatomic) BOOL Click2Call;
@property (nonatomic) BOOL Click2Email;
@property (nonatomic) BOOL Click2SMS;
@property (nonatomic) BOOL Click2Video;

@end







