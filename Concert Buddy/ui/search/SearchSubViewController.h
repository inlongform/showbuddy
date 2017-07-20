//
//  SearchSubViewController.h
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SearchSubViewController : UIViewController <UITextFieldDelegate, MPMediaPickerControllerDelegate>



-(void)searchPress;

@end
