//
//  GenrePicker.h
//  Show Buddy
//
//  Created by robbie on 2/19/13.
//
//

#import <UIKit/UIKit.h>

@interface GenrePicker : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *pickerData;

@end
