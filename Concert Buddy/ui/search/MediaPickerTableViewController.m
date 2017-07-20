//
//  MediaPickerTableViewController.m
//  lasyFmCoreData
//
//  Created by robbie w on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaPickerTableViewController.h"
#import "CustomAccessoryCell.h"
#import "CoreDataController.h"
#import "LocalMusicLibrary.h"
#import "AppDelegate.h"



@interface MediaPickerTableViewController()


@property (strong, nonatomic) NSMutableArray *picker_artists;
@property (strong, nonatomic) NSMutableArray *final_artists;
@property (strong, nonatomic) LocalMusicLibrary *local_music_library;



@end

@implementation MediaPickerTableViewController

@synthesize picker_artists, final_artists, local_music_library;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        self.title = @"Select Artists";
        
        
        [AppDelegate trackDataWithEvent:@"open_media_picker" actions:@"media_picker" andLbl:@"view_media_picker"];
        
        local_music_library = [AppDelegate getLocalMusicLibrary];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            picker_artists = [local_music_library getLocalMusicLibrary];
            
            [self prepareArtists:picker_artists];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{

                self.saved_data = [self.core_data_controller getArtistList];
                
                
                
                [self updateView];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_LIBRARY_INDICATOR object:nil]; 
                
                    
               
               
                
                

            });
        });

        

        

    }
    return self;
}



-(void)updateView{
    
    [self.tableView reloadData];
    

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:footerView];
    
    
    
    for(UIView *view in [self.tableView subviews])
    {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
        {
            [view performSelector:@selector(setIndexColor:) withObject:[UIColor whiteColor]];
        }
    }
    
    
    
    

}



- (void)viewWillAppear:(BOOL)animated
{
   
//    NSLog(@"show media picker view");
//    [self updateView];
    
    

    
    [super viewWillAppear:animated];
}



-(void)addEditButton{
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closePress)];
    self.navigationItem.rightBarButtonItem = closeBtn;
}

-(void)closePress{
    

    [[NSNotificationCenter defaultCenter] postNotificationName:REMOVE_MEDIA_PICKER object:nil];
}


//added alphabetical search


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([self.keys count] > 0) ? [self.keys count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    NSArray *currentSection = [self.masterArtistArray objectAtIndex:section];
    return [currentSection count];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keys;	
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    headerView.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:49.0f/255.0f alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 30, 15)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    
    label.text = [self.keys objectAtIndex:section];
    
    [headerView addSubview:label];
    
    
    return headerView;
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    CustomAccessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomAccessoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
        

    }
    
    NSUInteger section = [indexPath section];

    
    NSArray *sectionArray = [self.masterArtistArray objectAtIndex:section];
    NSString *artistName = [sectionArray objectAtIndex:indexPath.row];
    
   
    
    
    NSInteger matched = [self.saved_data indexOfObject:artistName];
    

    
    
    

    
    if(matched <= [self.saved_data count] && [self.saved_data count] > 0) {
        [cell showCheckMark];

    } else {
        [cell hideCheckMark];
    }


    cell.textLabel.text = artistName;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomAccessoryCell *cell = (CustomAccessoryCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSUInteger section = [indexPath section];
    
    
    NSArray *sectionArray = [self.masterArtistArray objectAtIndex:section];
    NSString *artistName = [sectionArray objectAtIndex:indexPath.row];
    
    if(cell.is_selected){
//        [fav_artists removeObject:artistName];
        [self.core_data_controller removeFavorite:artistName];
        [cell hideCheckMark];
    }else{
//        [fav_artists addObject:artistName];
        [cell showCheckMark];
        [self.core_data_controller addFavorite:artistName];
    }
    

     
    

    
}


@end
