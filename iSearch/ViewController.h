//
//  ViewController.h
//  iSearch
//
//  Created by Karim Abdul on 5/22/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
@property (nonatomic, weak) IBOutlet UITextField *queryTextField;

@end
