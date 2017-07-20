//
//  ArtistInfoView.m
//  Show Buddy
//
//  Created by robbie w on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtistInfoView.h"
#import "AppDelegate.h"
#import "ArtistDetailData.h"
#import "DataController.h"
#import "CustomCell.h"


@interface ArtistInfoView ()

@property (strong, nonatomic) ArtistDetailData *artist_details;
@property (strong, nonatomic) DataController *data_controller;


@end

@implementation ArtistInfoView

@synthesize artist_details, data_controller;

- (id)initWithStyle:(UITableViewStyle)style artistData:(ArtistDetailData *)data
{
    self = [super initWithStyle:style];
    if (self) {
        artist_details = data;
        self.title = artist_details.artist_name;
        data_controller = [AppDelegate getDataController];
        
        NSString *trackerLbl = [[NSString alloc] initWithFormat:@"artist info: %@", artist_details.artist_name];
        [AppDelegate trackDataWithEvent:@"artist_info" actions:@"artist" andLbl:trackerLbl];
       
        UIView* bview = [[UIView alloc] init];
        bview.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1];
        [self.tableView setBackgroundView:bview];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor blackColor];
//        self.tableView.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1];
    }
    return self;
}

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
    
    UIView *bioHead = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imgHolder.frame) + 15, 85, 17)];
    
    bioHead.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bioHead.png"]];
    
    [headerView addSubview:bioHead];
    
     NSMutableString *bioStr = [[NSMutableString alloc] initWithString:artist_details.bio];  
    
    CGSize bioSize = [bioStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 800) lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *bioView = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(bioHead.frame) + 10, 280, bioSize.height + 15)];  
    
    bioView.text = bioStr;
    bioView.font = [UIFont systemFontOfSize:15];
    bioView.textColor = [UIColor whiteColor];
    bioView.lineBreakMode = UILineBreakModeWordWrap;
    bioView.textAlignment = UITextAlignmentLeft;
    bioView.numberOfLines = 0;
    bioView.backgroundColor = [UIColor clearColor];
    
    
    
    [headerView addSubview:bioView];
    
    
    headerView.frame = CGRectMake(0, CGRectGetMinY(headerView.frame), CGRectGetWidth(headerView.frame), CGRectGetMaxY(bioView.frame) + 15);
    
    self.tableView.tableHeaderView = headerView;
    
    
    
    [super viewDidLoad];


}



-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, 320.0, 44.0)];
    
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 4)];
    seperator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seperator.png"]];
    
    
    [customView addSubview:seperator];
    
    
    
    
    UILabel *similar = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 20)];
    similar.text = @"TOP TRACKS";
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
    
    if([data_controller.tracksArray count] > 0){
        return [data_controller.tracksArray count];
    }else{
        return 0;
    }
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier isGrouped:YES];
    }
    
    NSDictionary *tackDict = [data_controller.tracksArray objectAtIndex:indexPath.row];
    

    
    cell.textLabel.text = [tackDict objectForKey:@"trackName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tackDict = [data_controller.tracksArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_AUDIO_PLAYER object:nil userInfo:tackDict];
    

    
}

@end
