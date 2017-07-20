//
//  AbstractTableViewCell.m
//  lasyFmCoreData
//
//  Created by robbie w on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isGrouped:(Boolean)grouped{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.textLabel.highlightedTextColor = [UIColor blackColor];
        
        
        

        if(grouped){
            self.contentView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
        }else{
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
            self.backgroundView = backView;
            
        }
         
        

    }
    return self;

}






@end
