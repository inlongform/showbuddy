//
//  ButtonUtil.m
//  directory
//
//  Created by robbie on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonUtil.h"


@implementation ButtonUtil


+(UIButton *)buttonWithProps:(int)xPos yPos:(int)yp width:(int)wid displayText:(NSString *)text{
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
	button.frame = CGRectMake(xPos, yp, wid, 35);
	[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[button setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0.0, 0.0)];
	

	[button setTitle:text forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:12];


	 return button;
}

@end
