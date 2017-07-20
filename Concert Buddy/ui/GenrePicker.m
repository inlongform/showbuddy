//
//  GenrePicker.m
//  Show Buddy
//
//  Created by robbie on 2/19/13.
//
//

#import "GenrePicker.h"

@interface GenrePicker ()



@end

@implementation GenrePicker

@synthesize pickerView, pickerData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Calculate the screen's width.
            

    }
    return self;
}

- (void)viewDidLoad
{
//    UIView *backgroundTest = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height)];
//    backgroundTest.backgroundColor = [UIColor blueColor];
//    
//    [self.view addSubview:backgroundTest];
    
    pickerData = [Constants getGenresList];

    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].applicationFrame.size.height - 216 ,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height)];
    pickerView.backgroundColor = [UIColor clearColor];

    

    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    
    pickerView.showsSelectionIndicator = YES;
    
    
    
    [self.view addSubview: pickerView];
	// Do any additional setup after loading the view.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_GENRE_PICKER object:nil];
}



// delegates//////////////////

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerData count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
    [Constants setGenre:[pickerData objectAtIndex: row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_GENRE_PICKER object:nil];
}




@end
