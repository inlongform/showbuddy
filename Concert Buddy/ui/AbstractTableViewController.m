//
//  AbstractSavedTableViewController.m
//  lasyFmCoreData
//
//  Created by robbie w on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractTableViewController.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "CoreDataController.h"



@implementation AbstractTableViewController

@synthesize data_controller, core_data_controller, saved_data, keys, masterArtistArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        data_controller = [AppDelegate getDataController];
        core_data_controller = [AppDelegate getCoreDataController];
        
        UIView* bview = [[UIView alloc] init];
        bview.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
        [self.tableView setBackgroundView:bview];

         
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor blackColor];
        
        [self addEditButton];
        
    }
    return self;
}

-(void)addEditButton{
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.editButtonItem.target = self;
}

-(void)prepareArtists:(NSArray *)artistList{
    NSArray *artists = artistList;
    
    // add this later for alphabetizing
    
    NSString *currLetter;
    
    NSString *myRegex = @"[A-Z0-9a-z_]*"; 
    NSPredicate *testPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex]; 
    
//    NSLog(@"prepareArtists");
    
    
    masterArtistArray = [[NSMutableArray alloc] init];
    keys = [[NSMutableArray alloc] initWithArray:nil];
    
    NSMutableArray *subArray;
    
    
    
    for(int i = 0; i < [artists count]; i++){
        NSString *artistStr = [[NSString alloc] initWithString:[artists objectAtIndex:i]];

            currLetter = [[artistStr substringToIndex:1] uppercaseString];
        

            //check to see if it is non alphanumeric chars
            BOOL isValid = [testPred evaluateWithObject:currLetter];
        
            if(!isValid){
                currLetter = @"*";
            }

            
            //check to see if it starts with a number- 7 seconds, 10,000 maniacs
            NSNumberFormatter * numFormat = [[NSNumberFormatter alloc] init];
            NSNumber * n = [numFormat numberFromString:currLetter]; 
            
            if(n != nil){
                
                currLetter = @"#";
            }
        
           
            if([keys containsObject:currLetter] == NO){
                [keys addObject:currLetter];
                subArray = [[NSMutableArray alloc] init];
                [masterArtistArray addObject:subArray];
                [subArray addObject:artistStr];
                
            }else{
                [subArray addObject:artistStr];
            }
        
        }
    
    
//    NSLog(@"keys: %@", keys);
    


}










@end
