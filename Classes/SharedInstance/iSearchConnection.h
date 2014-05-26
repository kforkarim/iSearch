//
//  iSearchConnection.h
//  iSearch
//
//  Created by Karim Abdul on 5/25/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iSearchConnection : NSObject

/**
 Returns an instance to the shared singleton which governs access to the
 iSearch Service Calls.
 @returns The shared liken object
 */
+ (iSearchConnection *)sharedInstance;

// ConnectionRequest take the url and makes an ansyc network call and provides response, data, and error objects in block Completion.
- (void)connectionRequest:(NSURL*)url
                         Completed:(void (^)(NSURLResponse *op, NSData *resp, NSError *error))connectionResponse;

@end
