//
//  CustomAccessoryCell.m
//  lasyFmCoreData
//
//  Created by robbie w on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomAccessoryCell.h"



@implementation CustomAccessoryCell

@synthesize is_selected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.textLabel.highlightedTextColor = [UIColor blackColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
        self.backgroundView = backView;
        

        UIImage *img = [UIImage imageNamed:@"checkmark.png"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        
        self.accessoryView = imgView;
        
        [self hideCheckMark];
        
        [self.accessoryView setHidden:YES];

        

    }
    return self;
}



-(void)hideCheckMark{
    is_selected = NO;
    [self.accessoryView setHidden:YES];
}

-(void)showCheckMark{
    is_selected = YES;
    [self.accessoryView setHidden:NO];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    NSLog(@"selected");
//    
//
//}

@end
