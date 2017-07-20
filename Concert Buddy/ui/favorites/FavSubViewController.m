//
//  FavSubViewController.m
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavSubViewController.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "ArtistDetailView.h"
#import "CoreDataController.h"
#import "CustomCell.h"
#import "AppDelegate.h"

@interface FavSubViewController()

//@property (strong, nonatomic) UIView *no_favs_view;


- (void)updateData;


@end




@implementation FavSubViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Favorites";
        
        
        
        
        [AppDelegate trackDataWithEvent:@"open_favorites" actions:@"view_favorites" andLbl:@"view_favorites"];

        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self updateData];
    
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
    
    [super viewWillAppear:animated];
}

-(void)updateData{
    self.saved_data = [self.core_data_controller getArtistList];
    
    if([self.saved_data count] > 0){
        
//        NSLog(@"self.saved_data: %@", self.saved_data);
        [self prepareArtists:self.saved_data];
    } else {
        self.masterArtistArray = nil;
        self.keys = nil;
    }
    
    if([self.saved_data count] == 0){
        self.navigationItem.rightBarButtonItem = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_FAV_NO_CONTENT_VIEW object:nil]; 
    }else{
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_FAV_NO_CONTENT_VIEW object:nil]; 
    }

    


}



//added alphabetical search


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([self.keys count] > 0) ? [self.keys count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.saved_data count] > 0){
        NSArray *currentSection = [self.masterArtistArray objectAtIndex:section];
        return [currentSection count];
    }else{
        return  0;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	
//
//    return [keys objectAtIndex:section];
//}

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
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier isGrouped:NO];
    }
    
    if([self.saved_data count] > 0){
        NSUInteger section = [indexPath section];
    
    
        NSArray *sectionArray = [self.masterArtistArray objectAtIndex:section];
        NSString *artistName = [sectionArray objectAtIndex:indexPath.row];
    
    
        cell.textLabel.text = artistName;
    }

    
    return cell;
}





// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSUInteger section = [indexPath section];
        NSMutableArray *sectionArray = [self.masterArtistArray objectAtIndex:section];
                
        NSLog(@"delete artist: %@", [sectionArray objectAtIndex:indexPath.row]);
        

        [self.core_data_controller removeFavorite:[sectionArray objectAtIndex:indexPath.row]];
        
        
        
        [self updateData];
        
        NSLog(@"master array %@ ", self.masterArtistArray);
        NSLog(@"section %d", section);
        NSLog(@"section array %@", sectionArray);
        
        
         if([sectionArray count] == 1){
            
             [tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
         } else {
             [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         }




    }   

}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(artistDataLoaded:) name:ARTIST_DATA_LOADED object:nil];
    
    NSUInteger section = [indexPath section];
    
    
    NSArray *sectionArray = [self.masterArtistArray objectAtIndex:section];
    NSString *artistName = [sectionArray objectAtIndex:indexPath.row];
    
    [self.data_controller loadArtistDataWithName:artistName];
//    NSLog(@"%@", [saved_artists objectAtIndex:indexPath.row]);
}

- (void)artistDataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTIST_DATA_LOADED object:nil];
    
    
    ArtistDetailView *new_artist_details = [[ArtistDetailView alloc] initWithStyle:UITableViewStyleGrouped artistData:self.data_controller.artist_details];
    
    [self.navigationController pushViewController:new_artist_details animated:YES];
    
    NSLog(@"Artist Data loaded");
}

@end
