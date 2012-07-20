//
//  MailController.h
//  mAds
//
//  Created by Loc VK on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MailController : UIViewController <MFMailComposeViewControllerDelegate>{
	UIViewController *rootController;
	NSString *emailTo;
    NSString *emailCC;
    NSString *emailBCC;
    NSString *emailBody;
    NSString *emailSubject;
}

@property (nonatomic, assign) UIViewController *rootController;
@property (nonatomic, assign) NSString *emailTo;
@property (nonatomic, assign) NSString *emailCC;
@property (nonatomic, assign) NSString *emailBCC;
@property (nonatomic, assign) NSString *emailBody;
@property (nonatomic, assign) NSString *emailSubject;

- (void)showPickerComposeMail:(NSString*)EmailTo EmailCC:(NSString *)EmailCC EmailBCC:(NSString *)EmailBCC EmailBody:(NSString *)EmailBody EmailSubject:(NSString *)EmailSubject;
- (void)sendMail;
- (void)displayComposerSheet;

@end

