//
//  ArtistDetailData.h
//  last_fm
//
//  Created by robbie w on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistDetailData : NSObject

@property (strong, nonatomic)NSString *artist_name;
@property (strong, nonatomic)NSString *artist_img_URL;
@property (strong, nonatomic)NSMutableArray *similar_artists;
@property (strong, nonatomic)NSString *bio;
@property (strong, nonatomic)NSString *artist_url;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
