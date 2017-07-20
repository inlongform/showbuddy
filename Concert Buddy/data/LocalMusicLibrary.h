//
//  MusicLibrary.h
//  last_fm
//
//  Created by robbie w on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LocalMusicLibrary : NSObject

@property (strong, nonatomic) NSMutableArray *sortedArtistList;

-(NSMutableArray *) getLocalMusicLibrary;


@end

