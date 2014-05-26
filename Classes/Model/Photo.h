//
//  Photo.h
//  iSearch
//
//  Created by Karim Abdul on 5/22/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

// URL property for the Image
@property (nonatomic, strong) NSURL *url;

// Raw Image Property that holds the Image
@property (nonatomic, strong) UIImage *rawImage;

// Actual Height of the image
@property (nonatomic) NSInteger height;

// Actual Width of the image
@property (nonatomic) NSInteger width;

// Custom Init to load the properties from photo Array (Used Dependency Injection Pattern)
- (id)initWithDictionary:(id)photo;

@end
