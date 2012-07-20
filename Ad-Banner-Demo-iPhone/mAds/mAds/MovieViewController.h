//
//  MovieViewController.h
//  mAds
//
//  Created by Loc VK on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MovieViewController : UIViewController {
	MPMoviePlayerController *mp;
	NSURL *movieURL;
}

- (id)initWithPath:(NSString *)moviePath;
- (void)readyPlayer;

@end
