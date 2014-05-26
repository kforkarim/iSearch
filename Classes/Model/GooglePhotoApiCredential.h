//
//  GooglePhotoApiCredential.h
//  iSearch
//
//  Created by Karim Abdul on 5/25/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GooglePhotoApiCredential : NSObject

// Google Api Server URL Propery
@property (nonatomic, strong) NSString *serverUrl;

// Google Api Server Key Property
@property (nonatomic, strong) NSString *serverKey;

// Google Api Server CX Property
@property (nonatomic, strong) NSString *serverCX;

// query text Property
@property (nonatomic, strong) NSString *query;

// Sets Image Type (This can be different types as per the documentation: "Photo","Face",etc..)
@property (nonatomic, strong) NSString *imageType;

// Search Type (Can be image type, by default its not image type but list type)
@property (nonatomic, strong) NSString *searchType;

// Index to get the results for (set 10 for our example)
@property (nonatomic, strong) NSNumber *startIndex;

@end
