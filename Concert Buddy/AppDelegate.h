//
//  AppDelegate.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@class RootViewController, DataController, Reachability, CoreDataController, LocalMusicLibrary;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) DataController *data_Controller;
@property (strong, nonatomic) CoreDataController *core_data_controller;
@property (strong, nonatomic) LocalMusicLibrary *local_music_library;
@property(nonatomic, retain) id<GAITracker> tracker;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(DataController *) getDataController;
+(CoreDataController *) getCoreDataController;
+(LocalMusicLibrary *) getLocalMusicLibrary;
+(void)trackDataWithEvent:(NSString *)evt actions:(NSString *)action andLbl:(NSString *)lbl;


@end