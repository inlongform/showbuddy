//
//  ArtistDetailData.m
//  last_fm
//
//  Created by robbie w on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtistDetailData.h"

@interface ArtistDetailData()

- (NSString *) stripTags:(NSString *)str;
- (NSString *)stringByDecodingXMLEntities:(NSString *)str;

@end

@implementation ArtistDetailData

@synthesize artist_name, artist_img_URL, similar_artists, bio, artist_url;

-(id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        
//        NSLog(@"dict: %@", dict);
        
        similar_artists = [[NSMutableArray alloc] init];
        
        NSDictionary *artist_data = dict;
        NSDictionary *artist = [artist_data objectForKey:@"artist"];
        NSDictionary *bioDict = [artist objectForKey:@"bio"];
        
        
        
        NSArray *images = [artist objectForKey:@"image"];
        NSDictionary *imgDict = [images objectAtIndex:3];
        
        //see if it is a dictionary because lastfm json kind of sucks
        
        if(![[artist objectForKey:@"similar"] isKindOfClass:[NSString class]]){
            NSDictionary *similarDict = [artist objectForKey:@"similar"];
            
            if([[similarDict objectForKey:@"artist"] isKindOfClass:[NSDictionary class]]){
                
                NSDictionary *singleArtist = [similarDict objectForKey:@"artist"];
                [similar_artists addObject:[singleArtist objectForKey:@"name"]];
                
                
            }else{
                
                NSArray *multipleArtist = [similarDict objectForKey:@"artist"];
                
                for(int i = 0; i < [multipleArtist count]; i++){
                    NSDictionary *simArtist = [multipleArtist objectAtIndex:i];
                    [similar_artists addObject:[simArtist objectForKey:@"name"]];
                }
                
            }

        }
        
        
        
        NSString *rawBio = [[NSString alloc] initWithString:[bioDict objectForKey:@"summary"]];

        
        //strip out all the html tags from the bio,  this will replace the last fm artist webview
        bio = [self stripTags:rawBio];
        bio = [self stringByDecodingXMLEntities:bio];
        


        artist_name = [artist objectForKey:@"name"];
        artist_img_URL = [imgDict objectForKey:@"#text"];
        artist_url = [artist objectForKey:@"url"];
        
        
    }
    
    return self;
}

//strip html tags
- (NSString *) stripTags:(NSString *)str
{
    
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil){
            [html appendString:tempText];
        }
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd]){
            [scanner setScanLocation:[scanner scanLocation] + 1];
        }
        
        tempText = nil;
    }
    
    return html;
}

//strip html tags
- (NSString *)stringByDecodingXMLEntities:(NSString *)str {
    NSUInteger myLength = [str length];
    NSUInteger ampIndex = [str rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return str;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:str];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%u", charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];      //an isolated & symbol
            [result appendString:amp];
            
            /*
             NSString *unknownEntity = @"";
             [scanner scanUpToString:@";" intoString:&unknownEntity];
             NSString *semicolon = @"";
             [scanner scanString:@";" intoString:&semicolon];
             [result appendFormat:@"%@%@", unknownEntity, semicolon];
             NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }
        
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}


@end
