//
//  AllArtistEventsView.m
//  lasyFmCoreData
//
//  Created by robbie w on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllArtistEventsView.h"
#import "AllArtistEventsData.h"
#import "EventDetailsView.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "CustomCell.h"


@interface AllArtistEventsView()

@property (strong, nonatomic) NSArray *allEvents;
@property (strong, nonatomic) DataController *data_controller;
@property (strong, nonatomic) NSString *artist_name;

@end


@implementation AllArtistEventsView

@synthesize allEvents, data_controller, artist_name;

- (id)initWithStyle:(UITableViewStyle)style eventsData:(NSArray *)events title:(NSString *)artistTitle
{
    self = [super initWithStyle:style];
    if (self) {
        data_controller = [AppDelegate getDataController];
        allEvents = events;
        artist_name = artistTitle;
        self.title = artist_name;
//        self.row_count = [allEvents count];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        footerView.backgroundColor = [UIColor clearColor];
        
        [self.tableView setTableFooterView:footerView];
        
        NSString *trackerLbl = [[NSString alloc] initWithFormat:@"allEvents: %@", artist_name];
        [AppDelegate trackDataWithEvent:@"all_artist_events" actions:@"artist" andLbl:trackerLbl];
        
        
    }
    return self;
}

-(void)addEditButton{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [allEvents count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier isGrouped:NO];
    }
    
    AllArtistEventsData *event_cell = [allEvents objectAtIndex:indexPath.row];
    cell.textLabel.text = event_cell.eventInfo;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDataLoaded:) name:EVENT_DATA_LOADED object:nil];
    AllArtistEventsData *event_cell = [allEvents objectAtIndex:indexPath.row];
    
    [data_controller loadEventDetailDataWidthId:event_cell.eventId];

}

- (void)eventDataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DATA_LOADED object:nil];
    
    EventDetailsView *event_detail = [[EventDetailsView alloc] initWithStyle:UITableViewStyleGrouped artistData:data_controller.event_details_data title:artist_name];
    
    [self.navigationController pushViewController:event_detail animated:YES];
}

@end
