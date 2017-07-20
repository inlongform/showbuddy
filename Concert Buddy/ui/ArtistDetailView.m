//
//  ArtistDetailView.m
//  last_fm
//
//  Created by robbie w on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtistDetailView.h"
#import "ArtistDetailData.h"
#import "ButtonUtil.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "AllArtistEventsView.h"
#import "CustomCell.h"
#import "CoreDataController.h"
#import "ArtistInfoView.h"
#import "Events.h"




@interface ArtistDetailView()

@property (strong, nonatomic) ArtistDetailData *artist_details;
@property (strong, nonatomic) DataController *data_controller;
@property (strong, nonatomic) CoreDataController *core_data_controller;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) UIButton *listenBtn;
@property (nonatomic) Boolean isSaved;



@end

@implementation ArtistDetailView

@synthesize artist_details, data_controller, core_data_controller, saveBtn, listenBtn, isSaved;

- (id)initWithStyle:(UITableViewStyle)style artistData:(ArtistDetailData *)data
{
    self = [super initWithStyle:style];
    if (self) {
        artist_details = data;
        self.title = artist_details.artist_name;
        data_controller = [AppDelegate getDataController];
        core_data_controller = [AppDelegate getCoreDataController];
        
        NSString *trackerLbl = [[NSString alloc] initWithFormat:@"artist details: %@", artist_details.artist_name];
        [AppDelegate trackDataWithEvent:@"artist_details" actions:@"artist" andLbl:trackerLbl];
        
        NSLog(@"Artist detail view");
        
        UIView* bview = [[UIView alloc] init];
        bview.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1];
        [self.tableView setBackgroundView:bview];
        
        isSaved = [core_data_controller searchFavorites:artist_details.artist_name];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor blackColor];
//        self.tableView.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1];
//        self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
        

        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songURLLoaded:) name:SONG_SAMPLE_LOADED object:nil];
    [data_controller loadSongSampleData:artist_details.artist_name];

}



- (void)songURLLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SONG_SAMPLE_LOADED object:nil];
    
    if(data_controller.hasTracks){
        listenBtn.enabled = YES;
        listenBtn.alpha = 1;
    }

}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
    
        
    NSLog(@"image url: %@", artist_details.artist_img_URL);
    
    UIView *imgHolder = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width / 2) - 125, 10, 250, 159)];
    
    if([artist_details.artist_img_URL isEqualToString:@""]){
        NSLog(@"there is no image");
        UIImageView *placeHolder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        placeHolder.contentMode = UIViewContentModeScaleAspectFit;
        placeHolder.frame = CGRectMake(0, 0, 250, 159);
        [imgHolder addSubview:placeHolder];
    }else{
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: artist_details.artist_img_URL]];
        UIImage *img = [UIImage imageWithData:imageData];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.frame = CGRectMake(0, 0, 250, 159);
        [imgHolder addSubview:imgView];
    }

    [headerView addSubview:imgHolder];
    
    
    int frameSize = self.view.frame.size.width / 2;
    
    UIButton *artistBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    [artistBtn setBackgroundImage:[UIImage imageNamed:@"artistPage.png"] forState:UIControlStateNormal];
    [artistBtn addTarget:self action:@selector(artistURLClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    if([artist_details.bio isEqualToString:@""]){
        artistBtn.enabled = NO;
        artistBtn.alpha = 0.7;
        
    }

    
    artistBtn.frame = CGRectMake(frameSize - artistBtn.frame.size.width / 2, CGRectGetMaxY(imgHolder.frame) + 10, artistBtn.frame.size.width, artistBtn.frame.size.height);
    
   [headerView addSubview:artistBtn];
    
    listenBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    [listenBtn setBackgroundImage:[UIImage imageNamed:@"listen.png"] forState:UIControlStateNormal];
    [listenBtn addTarget:self action:@selector(listenToArtist) forControlEvents:UIControlEventTouchUpInside];
    listenBtn.enabled = NO;
    listenBtn.alpha = 0.7;
    
    listenBtn.frame = CGRectMake(frameSize - listenBtn.frame.size.width / 2, CGRectGetMaxY(artistBtn.frame) + 5, listenBtn.frame.size.width, listenBtn.frame.size.height);
    
    [headerView addSubview:listenBtn];
    
    UIButton *allEventsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    if([data_controller.allEventsArray count] == 0){
        allEventsBtn.enabled = NO;
        [allEventsBtn setBackgroundImage:[UIImage imageNamed:@"allEvents.png"] forState:UIControlStateNormal];
    }else{
        allEventsBtn.enabled = YES;
        [allEventsBtn setBackgroundImage:[UIImage imageNamed:@"allEventsOnTour.png"] forState:UIControlStateNormal];
    }
    
    [allEventsBtn addTarget:self action:@selector(allArtistsEventsClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    allEventsBtn.frame = CGRectMake(frameSize - allEventsBtn.frame.size.width / 2, CGRectGetMaxY(listenBtn.frame) + 5, allEventsBtn.frame.size.width, allEventsBtn.frame.size.height);
     
    [headerView addSubview:allEventsBtn];
    
    
    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    
    if(isSaved){

        [saveBtn setBackgroundImage:[UIImage imageNamed:@"removeFavorites.png"] forState:UIControlStateNormal];
        
    }else{

        [saveBtn setBackgroundImage:[UIImage imageNamed:@"saveFavorites.png"] forState:UIControlStateNormal];

    }
    
    saveBtn.frame = CGRectMake(frameSize - saveBtn.frame.size.width / 2, CGRectGetMaxY(allEventsBtn.frame) + 5, saveBtn.frame.size.width, saveBtn.frame.size.height);
    [saveBtn addTarget:self action:@selector(saveToFavorites) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:saveBtn];

       
    headerView.frame = CGRectMake(0, CGRectGetMinY(headerView.frame), CGRectGetWidth(headerView.frame), CGRectGetMaxY(saveBtn.frame) + 15);
    
    self.tableView.tableHeaderView = headerView;
    
    [super viewDidLoad];


}

-(void) listenToArtist{



    NSDictionary *trackDict = [data_controller.tracksArray objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_AUDIO_PLAYER object:nil userInfo:trackDict];
    NSLog(@"listen to artist click");
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SONG_SAMPLE_LOADED object:nil];
}

-(void) saveToFavorites{
    
    if(isSaved){
        isSaved = NO;
        [core_data_controller removeFavorite:artist_details.artist_name];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"saveFavorites.png"] forState:UIControlStateNormal];
        
        NSString *addTrackerLbl = [[NSString alloc] initWithFormat:@"add favorite: %@", artist_details.artist_name];
        [AppDelegate trackDataWithEvent:@"add_favorite" actions:@"artist" andLbl:addTrackerLbl];
        
       
        
    }else{
         isSaved = YES;
        [core_data_controller addFavorite:artist_details.artist_name];
        
        NSString *removeTrackerLbl = [[NSString alloc] initWithFormat:@"remove favorite: %@", artist_details.artist_name];
        [AppDelegate trackDataWithEvent:@"remove_favorite" actions:@"artist" andLbl:removeTrackerLbl];

        [saveBtn setBackgroundImage:[UIImage imageNamed:@"removeFavorites.png"] forState:UIControlStateNormal];
    }


    
}

-(void)allArtistsEventsClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allEventsDataLoaded:) name:ALL_EVENTS_LOADED object:nil];
    [data_controller loadAllArtistEventsWithName:artist_details.artist_name isPage:YES];
    


    NSLog(@"View all Artist Events");
}

- (void)allEventsDataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALL_EVENTS_LOADED object:nil];
    
    AllArtistEventsView *allEvents = [[AllArtistEventsView alloc] initWithStyle:UITableViewStylePlain eventsData:[data_controller allEventsArray] title:artist_details.artist_name];
    [self.navigationController pushViewController:allEvents animated:YES];
}

-(void)artistURLClick{
    

    ArtistInfoView *infoView = [[ArtistInfoView alloc] initWithStyle:UITableViewStyleGrouped artistData:artist_details];
    [self.navigationController pushViewController:infoView animated:YES];

}



#pragma mark - Table view data source



-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, 320.0, 44.0)];

    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 4)];
    seperator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seperator.png"]];
    
    
    [customView addSubview:seperator];
    
    
    
    UILabel *similar = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 20)];
    similar.text = @"SIMILAR ARTISTS";
    similar.textColor = [UIColor whiteColor];
    similar.backgroundColor = [UIColor clearColor];
    similar.font = [UIFont boldSystemFontOfSize:15];
    
    [customView addSubview:similar];
    
    customView.frame = CGRectMake(0, CGRectGetMinY(customView.frame), CGRectGetWidth(customView.frame), CGRectGetMaxY(similar.frame));
    
    return customView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    if([artist_details.similar_artists count] > 0){
        return [artist_details.similar_artists count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier isGrouped:YES];
    }
    
    cell.textLabel.text = [artist_details.similar_artists objectAtIndex:indexPath.row];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 40;
//}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(artistDataLoaded:) name:ARTIST_DATA_LOADED object:nil];
    [data_controller loadArtistDataWithName:[artist_details.similar_artists objectAtIndex:indexPath.row]];

}

- (void)artistDataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTIST_DATA_LOADED object:nil];
    
//    NSLog(@"details %@", data_controller.artist_details);
    
    ArtistDetailView *new_artist_details = [[ArtistDetailView alloc] initWithStyle:UITableViewStyleGrouped artistData:data_controller.artist_details];
    
    [self.navigationController pushViewController:new_artist_details animated:YES];
    

}

@end
