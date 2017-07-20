//
//  ArtistWebView.m
//  last_fm
//
//  Created by robbie w on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TicketsWebView.h"

@interface TicketsWebView()


@property (nonatomic) Boolean home_page_loaded;




@end

@implementation TicketsWebView

@synthesize home_page_loaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url title:(NSString *)artist_title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = artist_title;
        
        home_page_loaded = NO;
        
        UIWebView *web_view = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 80)];
        NSURL *artistURL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:artistURL];
        [web_view loadRequest:request];
        
        web_view.delegate = self;
        
        [self.view addSubview:web_view];
        web_view.scalesPageToFit = YES;
        NSLog(@"url: %@", artistURL);

    }
    return self;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    if(!home_page_loaded){
        home_page_loaded = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
    }
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Error" message:@"Please Try Again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}



@end
