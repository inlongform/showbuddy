//
//  Data_Controller.h
//  last_fm
//
//  Created by robbie w on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "ConnectionController.h"


@class ArtistEventData, EventDetailsData, ArtistDetailData, AllArtistEventsData;

@interface DataController : NSObject <ConnectionDelegate, NSURLConnectionDelegate>


@property (strong, nonatomic) EventDetailsData *event_details_data;
@property (strong, nonatomic) ArtistEventData *artist_event;
@property (strong, nonatomic) ArtistDetailData *artist_details;
@property (strong, nonatomic) NSMutableArray *masterArtistArray;
@property (strong, nonatomic) NSMutableArray *allEventsArray;
@property (strong, nonatomic) NSMutableArray *tracksArray;







@property (nonatomic) int currentPage;
@property (nonatomic) int loopCount;
@property (nonatomic) Boolean hasConnection;
@property (nonatomic) Boolean hasTracks;
@property (nonatomic) int totalEvents;


-(void)loadDataWithLocation:(NSString *)location andPage:(int)pageNum isCurrentLocation:(Boolean)isCurrent;
-(void)updateMasterList:(NSMutableArray *)events;
-(void)loadEventDetailDataWidthId:(NSString *)eventId;
-(void)loadArtistDataWithName:(NSString *)artistName;
-(void)resetMasterArray;
-(void)loadAllArtistEventsWithName:(NSString *)artistName isPage:(Boolean)page;
-(void)loadSongSampleData:(NSString *)artistName;
-(void)showConnectionAlert;




@end
