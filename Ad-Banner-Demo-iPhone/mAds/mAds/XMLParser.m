//
//  XMLParser.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "XMLParser.h"
#import "mAds.h"

@implementation XMLParser

- (XMLParser *)initXMLParserWithObject:(mAds *)mAds{
    
	self = [super init];
    
    if (self) {
        _mAds = mAds;
        _mAds.Click2Call = NO;
        _mAds.Click2Email = NO;
        _mAds.Click2SMS = NO;
        _mAds.Click2Video = NO;
    }
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if (!_currentElementValue) { 
		_currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
	else {
		[_currentElementValue appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"iad"]) {
		return;
    }
    else if ([elementName isEqualToString:@"img"]) {
        if (_currentElementValue != nil) {
            [_mAds setImageResource:_currentElementValue];
        }
    }
    else if ([elementName isEqualToString:@"callnumber"]){
        if (_currentElementValue != nil) {
            [_mAds setCallNumber:_currentElementValue];
            [_mAds setClick2Call:YES];
        }
    }
    else if ([elementName isEqualToString:@"email_to"]){
        if (_currentElementValue != nil) {
            [_mAds setEmail_To:_currentElementValue];
            [_mAds setClick2Email:YES];
        }
    }
    else if ([elementName isEqualToString:@"email_cc"]){
        if (_currentElementValue != nil) {
            [_mAds setEmail_CC:_currentElementValue];
        }
    }
    else if ([elementName isEqualToString:@"email_bcc"]){
        if (_currentElementValue != nil) {
            [_mAds setEmail_BCC:_currentElementValue];
        }
    }
    else if ([elementName isEqualToString:@"email_subject"]){
        if (_currentElementValue != nil) {
            [_mAds setEmail_Subject:_currentElementValue];
        }
    }
    else if ([elementName isEqualToString:@"email_text"]){
        if (_currentElementValue != nil) {
            [_mAds setEmail_Text:_currentElementValue];
        }
    }
    else if ([elementName isEqualToString:@"smsnumber"]){
        if (_currentElementValue != nil) {
            [_mAds setSMSNumber:_currentElementValue];
            [_mAds setClick2SMS:YES];
        }
    }
    else if ([elementName isEqualToString:@"smstext"]){
        if (_currentElementValue != nil) {
            [_mAds setSMSText:_currentElementValue];
        }
    }
    else if ([elementName isEqualToString:@"url"]){
        if (_currentElementValue != nil) {
            [_mAds setURL:_currentElementValue];
            [_mAds setClick2Video:YES];
        }
    }
    
    
    [_currentElementValue release];
	_currentElementValue = nil;
}

- (void) dealloc {
	
	[_mAds release];
	[_currentElementValue release];
	[super dealloc];
}

@end
