//
//  ConnectionController.h
//  FoursquareTest
//
//  Created by Xichuan Wang on 12/6/11.
//  Copyright (c) 2011 TENDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConnectionDelegate;

@interface ConnectionController : NSObject

@property (nonatomic, strong) id delegate;
- (void) checkConnection;
@end


@protocol ConnectionDelegate <NSObject>
-(void) connectedWithConnector: (ConnectionController*) controller withResponse: (BOOL) isConnected;
@end

