//
//  MailController.m
//  mAds
//
//  Created by Loc VK on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MailController.h"

@implementation MailController
@synthesize rootController;

@synthesize emailTo;
@synthesize emailCC;
@synthesize emailBCC;
@synthesize emailBody;
@synthesize emailSubject;

- (void)showPickerComposeMail:(NSString*)EmailTo EmailCC:(NSString *)EmailCC EmailBCC:(NSString *)EmailBCC EmailBody:(NSString *)EmailBody EmailSubject:(NSString *)EmailSubject{
    
	emailTo = EmailTo;
    emailCC = EmailCC;
    emailBCC = EmailBCC;
    emailBody = EmailBody;
    emailSubject = EmailSubject;
    
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil){
		if ([mailClass canSendMail]) {
			[self displayComposerSheet];
		}
		else {
			[self sendMail];
		}
	}
	else {
		[self sendMail];
	}
}

#pragma mark -
#pragma mark Compose Mail

-(void)displayComposerSheet {
    
	MFMailComposeViewController *__pickerMail = [[MFMailComposeViewController alloc] init];
    
	__pickerMail.mailComposeDelegate = self;
	
    
	[__pickerMail setSubject:self.emailSubject];
	
	NSArray *__toRecipients = [NSArray arrayWithObject:self.emailTo];
	[__pickerMail setToRecipients:__toRecipients];	
    
	NSArray *__ccRecipients = [NSArray arrayWithObject:self.emailCC];
	[__pickerMail setCcRecipients:__ccRecipients];	
    
    NSArray *__bccRecipients = [NSArray arrayWithObject:self.emailBCC];
	[__pickerMail setCcRecipients:__bccRecipients];	
    
	[__pickerMail setMessageBody:self.emailBody isHTML:NO];	
    
	[self.rootController presentModalViewController:__pickerMail animated:YES];
    
    [__pickerMail release];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
	[self.rootController dismissModalViewControllerAnimated:YES];
}
-(void)sendMail
{
	NSString *emailIDString = [NSString stringWithFormat:@"mailto:%@",self.emailTo];
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailIDString]])
	{
		
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
@end
