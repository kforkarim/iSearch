//
//  Photo.m
//  iSearch
//
//  Created by Karim Abdul on 5/22/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize url;
@synthesize rawImage;
@synthesize height;
@synthesize width;

- (id)initWithDictionary:(id)photo
{
    self = [super init];
    
    if (self) {
        
        // Sets url,height and width from the JSON object
        [self setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photo[@"link"]]]];
        [self setHeight:(NSInteger)[[photo valueForKey:@"items"] valueForKey:@"height"]];
        [self setWidth:(NSInteger)[[photo valueForKey:@"items"] valueForKey:@"width"]];
    }
    
    return self;
    
}

@end
