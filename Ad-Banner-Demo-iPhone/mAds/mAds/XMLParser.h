//
//  XMLParser.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
#import "mAds.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>{

	NSMutableString *_currentElementValue;
    mAds *_mAds;
}

- (XMLParser *)initXMLParserWithObject:(mAds *)mAds;

@end
