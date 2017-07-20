//
//  ArtistWebView.h
//  last_fm
//
//  Created by robbie w on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsWebView : UIViewController <UIWebViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url title:(NSString *)artist_title;

@end
