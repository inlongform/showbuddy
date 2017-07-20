//
//  CustomAccessoryCell.h
//  lasyFmCoreData
//
//  Created by robbie w on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAccessoryCell : UITableViewCell

@property (nonatomic) Boolean is_selected;

-(void)hideCheckMark;
-(void)showCheckMark;

@end
