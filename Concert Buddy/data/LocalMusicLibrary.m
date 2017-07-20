//
//  MusicLibrary.m
//  last_fm
//
//  Created by robbie w on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.   
//

#import "LocalMusicLibrary.h"

@interface LocalMusicLibrary()

@property (strong, nonatomic) NSDate *mod_date;



-(Boolean)hasUpdated;


@end



@implementation LocalMusicLibrary

@synthesize sortedArtistList, mod_date;

-(id)init{
    if (self = [super init]) {

        sortedArtistList = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}



-(Boolean)hasUpdated{
    NSDate *modDate = [[MPMediaLibrary defaultMediaLibrary] lastModifiedDate];
    NSDate *prevModDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"modDate"];
    
    Boolean has_updated; 
    
    if([modDate isEqualToDate: prevModDate] ){
        has_updated = NO;
        NSLog(@"has not been updated");
    }else{
        has_updated = YES;
        [[NSUserDefaults standardUserDefaults] setObject:modDate forKey:@"modDate"];
        
        NSLog(@"has been updated");
    }
    
    
    
    
//    NSLog(@"modDate %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"modDate"]);
    
    return has_updated;

}

-(NSMutableArray *) getLocalMusicLibrary{
    

    

    if([self hasUpdated] || ([sortedArtistList count] == 0)){
        NSTimeInterval start  = [[NSDate date] timeIntervalSince1970];
        
        MPMediaQuery *myQuery = [[MPMediaQuery alloc] init];
        [myQuery setGroupingType:MPMediaGroupingArtist];
    //    NSArray *myCollections = [[NSMutableArray alloc] initWithArray:[myQuery collections]];

        
        NSMutableArray *artists = [[NSMutableArray alloc] init];
        

        
        for( MPMediaItemCollection *c in [myQuery collections] ) {
            MPMediaItem *albumItem = [c representativeItem];
            NSString *artist = [albumItem valueForProperty:MPMediaItemPropertyArtist];
            if(![[artist substringToIndex:1] isEqualToString:@"/"]){

                [artists addObject:[artist capitalizedString]];
            }

        }
        sortedArtistList = (NSMutableArray *)[artists sortedArrayUsingSelector:@selector(compare:)];
        
        NSTimeInterval finish = [[NSDate date] timeIntervalSince1970];
        
    //    NSLog(@"artists %@", artists);
        
        NSLog(@"Execution took %f seconds.", finish - start);
    }

    

    return sortedArtistList;
    

}








@end
