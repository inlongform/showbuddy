//
//  ArtistInfoView.h
//  Show Buddy
//
//  Created by robbie w on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtistDetailData;

@interface ArtistInfoView : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style artistData:(ArtistDetailData *)data;

@end
