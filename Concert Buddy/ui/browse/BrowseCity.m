//
//  BrowseCity.m
//  last_fm
//
//  Created by robbie w on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrowseCity.h"
#import "ArtistEventData.h"
#import "EventDetailsView.h"
#import "ButtonUtil.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "CustomCell.h"


@interface BrowseCity()
@property (strong, nonatomic) NSMutableArray *allEventsArray;
@property (strong, nonatomic) DataController *data_controller;
@property (strong, nonatomic) NSString *selected_artist;
@property (strong, nonatomic) UIActivityIndicatorView *activity_indicator;
@property (strong, nonatomic) EventDetailsView *event_detail;

@property (nonatomic) Boolean hasLoaded;
@property (nonatomic) Boolean currentLocation;




@end

@implementation BrowseCity

@synthesize allEventsArray, hasLoaded, data_controller, selected_artist, activity_indicator, currentLocation, event_detail;

- (id)initWithStyle:(UITableViewStyle)style andEvents:(NSMutableArray *)cityEvents isCurrentLocation:(Boolean)isCurrent
{
    allEventsArray = cityEvents;
    currentLocation = isCurrent;

    hasLoaded = NO;
    
    self = [super initWithStyle:style];
    
    if (self) {
        self.title = [Constants getCurrentCity];
        
        NSString *trackerLbl = [[NSString alloc] initWithFormat:@"location search: %@", [Constants getCurrentCity]];
        [AppDelegate trackDataWithEvent:@"location_search" actions:@"city" andLbl:trackerLbl];

        
        
        data_controller = [AppDelegate getDataController];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor blackColor];
        
        UIView* bview = [[UIView alloc] init];
        bview.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
        [self.tableView setBackgroundView:bview];

        
        UILabel *footerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
//        footerLbl.text = @"Pull down for more events";
//        footerLbl.textColor = [UIColor whiteColor];
//        footerLbl.textAlignment = UITextAlignmentCenter;
        footerLbl.backgroundColor = [UIColor clearColor];
        
        activity_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width / 2 - 15, 1, 35, 35)];
        activity_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
       
        [footerView addSubview:activity_indicator];
        [footerView addSubview:footerLbl];
        
        self.tableView.tableFooterView = footerView;


    }
    return self;
}



//check to see if the user has scrolled to the bottom
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = self.tableView.contentOffset;   
    
    [self.tableView layoutIfNeeded];
    //content height - frame height - top and bottom buttons + bottom lbl height 
    int viewHeight = (self.tableView.contentSize.height + 20) - [UIScreen mainScreen].applicationFrame.size.height;
    
    if(offset.y >= viewHeight){

        if(hasLoaded == NO){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextGroupLoaded:) name:BROWSE_DATA_LOADED object:nil];
            data_controller.currentPage++;
            [data_controller loadDataWithLocation:[Constants getCurrentCity] andPage:data_controller.currentPage isCurrentLocation:currentLocation];
            [activity_indicator startAnimating];
            hasLoaded = YES;
        }
    }
    
    
}

- (void)nextGroupLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BROWSE_DATA_LOADED object:nil];
    
    allEventsArray = data_controller.masterArtistArray;
    [activity_indicator stopAnimating];
    
    [[self tableView] reloadData];
    
    hasLoaded = NO;
    


//    NSLog(@"next group loaded");
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    


    return [allEventsArray count];
}



-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	

	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];

	headerLabel.font = [UIFont boldSystemFontOfSize:17];
	headerLabel.frame = CGRectMake(20.0, 0.0, 300.0, 44.0);
    
    ArtistEventData *firstEvent = [[allEventsArray objectAtIndex:section] objectAtIndex:0];
    NSString *sectionDate = [[NSString alloc] initWithFormat:@"%@", firstEvent.shortDate];;
    
	headerLabel.text = sectionDate;
	[customView addSubview:headerLabel];
    
	return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *date_array = [allEventsArray objectAtIndex:section];

    
    return [date_array count];
    
    // Return the number of rows in the section.

}

//add lbls to row cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier isGrouped:YES];
    }
    

    
    NSArray *date_array = [allEventsArray objectAtIndex:indexPath.section];
   
    ArtistEventData *artist_event = [date_array objectAtIndex:indexPath.row];
    cell.textLabel.text = artist_event.headLiner;

    
    return cell;
}




#pragma mark - Table view delegate

//row has been selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDataLoaded:) name:EVENT_DATA_LOADED object:nil];
    
    NSArray *date_array = [allEventsArray objectAtIndex:indexPath.section];
    ArtistEventData *artist_event = [date_array objectAtIndex:indexPath.row];
    
    selected_artist = artist_event.headLiner;
    
    
//    NSLog(@"event id: %@", artist_event.eventId);
    
    [data_controller loadEventDetailDataWidthId:artist_event.eventId];


     
}

- (void)eventDataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DATA_LOADED object:nil];
    
    event_detail = [[EventDetailsView alloc] initWithStyle:UITableViewStyleGrouped artistData:data_controller.event_details_data title:selected_artist];

    [self.navigationController pushViewController:event_detail animated:YES];
}


@end
