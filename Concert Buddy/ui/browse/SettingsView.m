    //
//  SettingsView.m
//  Show Buddy
//
//  Created by robbie on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsView.h"
#import "GenrePicker.h"

@interface SettingsView()

@property (strong, nonatomic) UILabel *radNumTxt;
@property (strong, nonatomic) UILabel *genreLbl;
@property (strong, nonatomic) GenrePicker *picker;




@end


@implementation SettingsView

@synthesize radNumTxt, genreLbl, picker, defaults;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settings_bck.png"]];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
//        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
      
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(60, 41, 205, 50)];
        [slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];

        slider.minimumTrackTintColor = [UIColor blackColor];
        

        
        if([defaults stringForKey:@"genre"] == nil){
           [defaults setObject:@"all" forKey:@"genre"];
           [defaults setFloat:.05 forKey:@"radius"];
            
        }
        
        [Constants setGenre:[defaults stringForKey:@"genre"]];
        [Constants setRadius:[defaults floatForKey:@"radius"] * 100];
            

        [slider setValue:[defaults floatForKey:@"radius"]];
        
        float rad = [defaults floatForKey:@"radius"] * 100;

        
        radNumTxt = [[UILabel alloc] initWithFrame:CGRectMake(269, 58, 25, 23)];
        radNumTxt.text = [[NSNumber numberWithInt:rad] stringValue];
        radNumTxt.textColor = [UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
        radNumTxt.backgroundColor = [UIColor clearColor]; 
        radNumTxt.font = [UIFont fontWithName:[Constants getHelv] size:14];
        [radNumTxt setTextAlignment:UITextAlignmentCenter];
        
        UIButton *genreBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, slider.frame.origin.y + slider.frame.size.height - 5, 209, 38)];
        [genreBtn setBackgroundImage:[UIImage imageNamed:@"genre_btn.png"] forState:UIControlStateNormal];
        [genreBtn addTarget:self action:@selector(genreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        genreLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, slider.frame.origin.y + slider.frame.size.height, 209, 38)];
        genreLbl.text = [[Constants getGenre] uppercaseString];
        genreLbl.textColor = [UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
        genreLbl.backgroundColor = [UIColor clearColor];
        genreLbl.font = [UIFont fontWithName:[Constants getHelv] size:14];
        [genreLbl setTextAlignment:UITextAlignmentCenter];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(genrePicked:) name:HIDE_GENRE_PICKER object:nil];

        
        
        

        [self addSubview: radNumTxt];
        [self addSubview: slider];
        [self addSubview: genreBtn];
        [self addSubview: genreLbl];
        




    }
    return self;
}



-(void)genrePicked:(NSNotification *)notification{
    
    
    NSLog(@"genre picked %@", [Constants getGenre]);
    [defaults setObject:[Constants getGenre] forKey:@"genre"];
    [defaults synchronize];
    genreLbl.text = [[Constants getGenre] uppercaseString];

}

-(void)genreBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_GENRE_PICKER object:nil];
}



-(void)sliderValueChangedAction:(id)sender {
	UISlider *slider = (UISlider *)sender;
	float progressAsInt = (float)(slider.value);
    int radiusAmt = progressAsInt * 100;
    
    
    [defaults setFloat:(float)(slider.value) forKey:@"radius"];
    [defaults synchronize];
     
    
    radNumTxt.text = [[NSNumber numberWithInt:radiusAmt] stringValue];

    [Constants setRadius:radiusAmt];
    


    
}

-(void)sliderFinishedDrag:(id)sender {
    UISlider *slider = (UISlider *)sender;

    NSLog(@"%f", slider.value);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
