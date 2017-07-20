//
//  AbstractTableViewCell.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isGrouped:(Boolean)grouped;


@end
