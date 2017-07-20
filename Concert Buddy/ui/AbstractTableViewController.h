//
//  AbstractSavedTableViewController.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController, CoreDataController;

@interface AbstractTableViewController : UITableViewController

@property (strong, nonatomic) DataController *data_controller;
@property (strong, nonatomic) CoreDataController *core_data_controller;
@property (strong, nonatomic)NSMutableArray *saved_data;

@property (strong, nonatomic) NSMutableArray *keys;
@property (strong, nonatomic) NSMutableArray *masterArtistArray;

//@property (nonatomic)int row_count;

-(void)addEditButton;
-(void)prepareArtists:(NSArray *)artistList;


@end
