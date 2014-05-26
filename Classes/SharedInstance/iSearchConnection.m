//
//  iSearchConnection.m
//  iSearch
//
//  Created by Karim Abdul on 5/25/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "iSearchConnection.h"

static iSearchConnection *_sharedInstance = nil;

@implementation iSearchConnection

+ (iSearchConnection *)sharedInstance {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        _sharedInstance = [[iSearchConnection alloc] init];
    });
    
    return _sharedInstance;
}

- (void)connectionRequest:(NSURL*)url
                         Completed:(void (^)(NSURLResponse *op, NSData *resp, NSError *error))connectionResponse
{
    
    NSURLRequest *ruquestURL = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:ruquestURL queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"JSON: %@", response);
        
        if (response != nil)
            connectionResponse(response,data,connectionError);

    }];

}

@end
