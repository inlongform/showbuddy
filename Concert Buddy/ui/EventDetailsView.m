//
//  EventArtistsTableView.m
//  last_fm
//
//  Created by robbie w on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDetailsView.h"
#import "EventDetailsData.h"
#import "AddressAnnotation.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "ArtistDetailView.h"
#import "ButtonUtil.h"
#import "CoreDataController.h"
#import "CustomCell.h"
#import "TicketsWebView.h"



@interface EventDetailsView()

@property (strong, nonatomic) EventDetailsData *event_details;
@property(strong, nonatomic)MKMapView *map_view;
@property (strong, nonatomic) DataController *data_controller;
@property (strong, nonatomic) CoreDataController *core_data_controller;
@property (nonatomic) Boolean event_saved;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) UIButton *ticketBtn;



@property (strong, nonatomic) NSString *selected_artist;

-(NSString *)formatPhoneNumber:(NSString *)str;
-(void)getTickets;

@end


@implementation EventDetailsView

@synthesize event_details, map_view, data_controller, event_saved, core_data_controller, saveBtn, ticketBtn, selected_artist;

- (id)initWithStyle:(UITableViewStyle)style artistData:(EventDetailsData *)eventData title:(NSString *)selected
{


    self = [super initWithStyle:style];
    if (self) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor blackColor];
//        self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
        
        UIView* bview = [[UIView alloc] init];
        bview.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
        [self.tableView setBackgroundView:bview];
        
        
        
        event_details = eventData;
        selected_artist = selected;
        self.title = selected_artist;
        
        NSString *trackerLbl = [[NSString alloc] initWithFormat:@"event details: %@", selected_artist];
        [AppDelegate trackDataWithEvent:@"event_details" actions:@"artist" andLbl:trackerLbl];
        
        data_controller = [AppDelegate getDataController];
        core_data_controller = [AppDelegate getCoreDataController];
        
        
        
        event_saved = [core_data_controller searchCalendarEvents:event_details.eventId];
        
        NSLog(@"%d", event_saved);
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        headerView.backgroundColor = [UIColor clearColor];
        
        
        UILabel *showDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        showDate.text = event_details.titleDate;
        showDate.textColor = [UIColor whiteColor];
        showDate.backgroundColor = [UIColor clearColor];
        showDate.font = [UIFont boldSystemFontOfSize:15];
        

        
        [headerView addSubview:showDate];
        
        
        
        map_view = [[MKMapView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width / 2) - 150, CGRectGetMaxY(showDate.frame) + 10, 300, 150)];
        map_view.mapType = MKMapTypeStandard;
        map_view.showsUserLocation = YES;
        map_view.delegate = self;
        
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        
        CLLocationCoordinate2D location;
        
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        
        location.latitude = [event_details.latitude doubleValue];
        location.longitude = [event_details.longitude doubleValue];
        
        region.center = location;
        region.span = span;
        
        
        [map_view setRegion:region animated:NO];
        
        [headerView addSubview:map_view];
        
        
        
        AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithEventData:event_details];
        [map_view addAnnotation:addAnnotation];
        

        NSMutableString *address = [[NSMutableString alloc] initWithString:event_details.display_info];   

        CGSize addySize = [address sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 300) lineBreakMode:UILineBreakModeWordWrap];
        
        
        UITextView *info = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(map_view.frame) + 10, 300, addySize.height + 10)];            
        info.text = address;
        info.font = [UIFont systemFontOfSize:15];
        info.textColor = [UIColor whiteColor];
        info.editable = NO;
        info.backgroundColor = [UIColor clearColor];
        info.scrollEnabled = NO;

        
        
        
        [headerView addSubview:info];
        
        int saveBtnY;
        
        if(![event_details.phoneNumber isEqualToString:@""]){
            UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(info.frame), 300, 20)];
            phoneBtn.backgroundColor = [UIColor clearColor];            

            [phoneBtn setTitle:event_details.phoneNumber forState:UIControlStateNormal];
            [phoneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            phoneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            phoneBtn.titleLabel.textColor = [UIColor orangeColor];
            [phoneBtn addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
            
            
            [headerView addSubview:phoneBtn];
       
            saveBtnY = CGRectGetMaxY(phoneBtn.frame) + 10;	

        }else{
            saveBtnY = CGRectGetMaxY(info.frame) + 10;
        }
        
               
        int frameSize = self.view.frame.size.width / 2;
        
        saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
        
        if(event_saved){
            
            [saveBtn setBackgroundImage:[UIImage imageNamed:@"removeCalendar.png"] forState:UIControlStateNormal];
            
        }else{
            
            [saveBtn setBackgroundImage:[UIImage imageNamed:@"saveCalendar.png"] forState:UIControlStateNormal];
            
        }
        
        saveBtn.frame = CGRectMake(frameSize - saveBtn.frame.size.width / 2, saveBtnY, saveBtn.frame.size.width, saveBtn.frame.size.height);
        [saveBtn addTarget:self action:@selector(saveToCalendar) forControlEvents:UIControlEventTouchUpInside];
        
        
        [headerView addSubview:saveBtn];
        
        ticketBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
        [ticketBtn setBackgroundImage:[UIImage imageNamed:@"tickets.png"] forState:UIControlStateNormal];
        [ticketBtn addTarget:self action:@selector(getTickets) forControlEvents:UIControlEventTouchUpInside];
        
        if(![event_details.ticketURL isEqualToString:@""]){
            ticketBtn.enabled = YES;
            
        }else{
            ticketBtn.enabled = NO;
        }
        
        [headerView addSubview:ticketBtn];
        ticketBtn.frame = CGRectMake(frameSize - ticketBtn.frame.size.width / 2, CGRectGetMaxY(saveBtn.frame) + 10, ticketBtn.frame.size.width, ticketBtn.frame.size.height);
        
        headerView.frame = CGRectMake(0, CGRectGetMinY(headerView.frame), CGRectGetWidth(headerView.frame), CGRectGetMaxY(ticketBtn.frame) + 10);
        
        self.tableView.tableHeaderView = headerView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCalendar:) name:REFRESH_CALENDAR object:nil];
        
    }
    return self;
}

-(void)phoneClick{
    
    NSString *phoneNumber = [self formatPhoneNumber:event_details.phoneNumber]; 

    NSURL *phoneURL = [[NSURL alloc] initWithString: phoneNumber];

    [[UIApplication sharedApplication] openURL: phoneURL];
    
    
}

-(NSString *)formatPhoneNumber:(NSString *)str{
    
    NSString *stripLeftP = [event_details.phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    NSString *stripRightP = [stripLeftP stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSString *stripDash = [stripRightP stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *stripDot = [stripDash stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *stripSpace = [stripDot stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *stripPlus = [stripSpace stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *finalPhone = [[NSString alloc] initWithFormat:@"tel:%@", stripPlus];
    
    return finalPhone;
}

-(void)viewWillAppear:(BOOL)animated{
    //toggle the save button when view appears
    [self autoCalendarRefresh];
   }

- (void)refreshCalendar:(NSNotification *)notification{
    [self autoCalendarRefresh];
}

-(void)autoCalendarRefresh {

    event_saved = [core_data_controller searchCalendarEvents:event_details.eventId];
    
    
    if(event_saved){
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"removeCalendar.png"] forState:UIControlStateNormal];
        
    }else{
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"saveCalendar.png"] forState:UIControlStateNormal];
        
    }

}



-(void)getTickets{
    
    NSString *trackerLbl = [[NSString alloc] initWithFormat:@"get tickets: %@", selected_artist];
    [AppDelegate trackDataWithEvent:@"get_tickets" actions:@"artist" andLbl:trackerLbl];

    
    TicketsWebView *ticketWebView = [[TicketsWebView alloc] initWithNibName:nil bundle:nil url:event_details.ticketURL title:selected_artist];
    
    [self.navigationController pushViewController:ticketWebView animated:YES];
    
//    NSLog(@"get tickets");
}



-(void) saveToCalendar{
    
    CoreDataController *core_data = [AppDelegate getCoreDataController];
    
    if(event_saved){
        event_saved = NO;
        
        NSString *saveTrackerLbl = [[NSString alloc] initWithFormat:@"save event: %@", event_details.headLiner];
        [AppDelegate trackDataWithEvent:@"add_event" actions:@"artist" andLbl:saveTrackerLbl];
       
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"saveCalendar.png"] forState:UIControlStateNormal];
        NSLog(@"remove from calendar");

        [core_data removeEventWithEventId:event_details.eventId];
        


        
    }else{
        event_saved = YES;
        
        NSString *removeTrackerLbl = [[NSString alloc] initWithFormat:@"remove event: %@", event_details.headLiner];
        [AppDelegate trackDataWithEvent:@"remove_event" actions:@"artist" andLbl:removeTrackerLbl];
               
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"removeCalendar.png"] forState:UIControlStateNormal];
        [core_data addEventToCalendar:event_details artist:selected_artist];
        
        NSLog(@"Save to calendar");
    }
    
    
    
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"nearby_pin"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"nearby_pin"];
    } else {
        pin.annotation = annotation;
    }
    
    pin.animatesDrop = YES;
    pin.canShowCallout = YES;
    
    
    // add detail disclosure
    UIButton *annotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.rightCalloutAccessoryView = annotationButton;
    
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    AddressAnnotation *annotation = ( AddressAnnotation *)view.annotation;
     
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@,%@",
                     mapView.userLocation.location.coordinate.latitude, mapView.userLocation.location.coordinate.longitude,
                     annotation.coodLat, annotation.coodLong];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return [event_details.allArtists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier isGrouped:YES];
    }
    
    
    cell.textLabel.text = [event_details.allArtists objectAtIndex:indexPath.row];

    
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(artistDataLoaded:) name:ARTIST_DATA_LOADED object:nil];
    [data_controller loadArtistDataWithName:[event_details.allArtists objectAtIndex:indexPath.row]];
    
}

- (void)artistDataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTIST_DATA_LOADED object:nil];
    
    NSLog(@"details %@", data_controller.artist_details);

    ArtistDetailView *artist_details = [[ArtistDetailView alloc] initWithStyle:UITableViewStyleGrouped artistData:data_controller.artist_details];

    [self.navigationController pushViewController:artist_details animated:YES];
    
//    NSLog(@"Artist Data loaded");
}

@end
