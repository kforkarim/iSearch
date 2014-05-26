//
//  ViewController.m
//  iSearch
//
//  Created by Karim Abdul on 5/22/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "ViewController.h"
#import "ListPhotoViewController.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL keyboardIsShown;

@end

@implementation ViewController

@synthesize keyboardIsShown;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Register For Notification when keyboard apprears to scrollView up or down.
    [self registerForKeyboardNotifications];
    
    // Set Default Title
    self.title = @"iSearch";
    
    // Enable Done Keyboard
    [self.queryTextField setReturnKeyType:UIReturnKeyDone];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check to see if being Pushed for ListPhoto
    if ([[segue identifier] isEqualToString:@"ListPhoto"])
    {
        // If Yes then set the query text field's text to query text NSString property
        ListPhotoViewController *listPhotoVC = [segue destinationViewController];
        [listPhotoVC setQueryString:self.queryTextField.text];
    }
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    self.scrollView.contentSize = scrollContentSize;
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = self.queryTextField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [self.queryTextField.superview setFrame:bkgndRect];
    [self.scrollView setContentOffset:CGPointMake(0.0, self.queryTextField.frame.origin.y-kbSize.height) animated:YES];}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

// Dismiss the Keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
