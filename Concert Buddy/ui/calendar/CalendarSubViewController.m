//
//  CalendarSubViewController.m
//  last_fm
//
//  Created by robbie w on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarSubViewController.h"
#import "DataController.h"
#import "CoreDataController.h"
#import "Calendar.h"
#import "EventDetailsView.h"
#import "CustomCell.h"
#import "DateUtil.h"
#import "AppDelegate.h"



@interface CalendarSubViewController()

@property (strong, nonatomic)NSString *selected_artist;



@end

@implementation CalendarSubViewController



@synthesize  selected_artist;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Calendar";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCells:) name:REFRESH_CALENDAR object:nil];
        
              
        [AppDelegate trackDataWithEvent:@"open_calendar" actions:@"view_calendar" andLbl:@"view_calendar"];
        

    }
    return self;
}





- (void)viewWillAppear:(BOOL)animated
{
    
    [self refreshCalendar];
    
    [super viewWillAppear:animated];
}

- (void)refreshCalendar{

    NSLog(@"refresh Calendar");
    self.saved_data = [self.core_data_controller getCalendarEventList];
    
    if([self.saved_data count] == 0){
        self.navigationItem.rightBarButtonItem = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_CAL_NO_CONTENT_VIEW object:nil]; 
    }else{
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_CAL_NO_CONTENT_VIEW object:nil]; 
    }
    
    
//    self.row_count = [self.saved_data count];
    [self.tableView reloadData];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:footerView];
}

- (void)refreshCells:(NSNotification *)notification{
    [self refreshCalendar];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier isGrouped:NO];
    }
    
    EKEvent *event = [self.saved_data objectAtIndex:indexPath.row];
    
    
    NSMutableString *cellText = [NSMutableString stringWithString:event.title];
    [cellText appendString:@" - "];
    [cellText appendString:[DateUtil numberFormattedDate:event.startDate]];
    
    cell.textLabel.text = cellText;
    


    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.saved_data count];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EKEvent *event = [self.saved_data objectAtIndex:indexPath.row];
        
        [self.core_data_controller removeEventFromCalendar:event];
        [self.saved_data removeObject:[self.saved_data objectAtIndex:indexPath.row]];


        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        if([self.saved_data count] == 0){
            self.navigationItem.rightBarButtonItem = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_CAL_NO_CONTENT_VIEW object:nil]; 
        }else{
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_CAL_NO_CONTENT_VIEW object:nil]; 
        }
    }   
   
}

    
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    EKEvent *event = [self.saved_data objectAtIndex:indexPath.row];

    selected_artist = event.title;

    NSLog(@"selected event: %@ %@", selected_artist, event);
    
    NSString *selectedId = [self.core_data_controller getSelectedEventId:event];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDataLoaded:) name:EVENT_DATA_LOADED object:nil];
    [self.data_controller loadEventDetailDataWidthId:selectedId];

}



- (void)eventDataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DATA_LOADED object:nil];
    
//    NSLog(@"data_controller.event_details_data: %@", self.data_controller.event_details_data);
    
    EventDetailsView *event_detail = [[EventDetailsView alloc] initWithStyle:UITableViewStyleGrouped artistData:self.data_controller.event_details_data title:selected_artist];
    
    [self.navigationController pushViewController:event_detail animated:YES];
}

@end
