//
//  AbsractViewController.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbsractViewController : UIViewController

@property (strong, nonatomic) UINavigationController *nav_controller;
@property (strong, nonatomic) UIView *no_content_view;

-(void)createNavControllerWithViewController:(UIViewController *)controller;
-(void)addNoContentView;
-(void)showView:(NSNotification *)notification;
-(void)hideView:(NSNotification *)notification;

@end
