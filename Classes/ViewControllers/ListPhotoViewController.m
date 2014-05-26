//
//  ListPhotoViewController.m
//  iSearch
//
//  Created by Karim Abdul on 5/24/14.
//  Copyright (c) 2014 Karim Abdul. All rights reserved.
//

#import "ListPhotoViewController.h"
#import "PhotoCollectionViewCell.h"
#import "iSearchConnection.h"
#import "Constant.h"
#import "GooglePhotoApiCredential.h"
#import "Photo.h"
#import <objc/runtime.h>

@interface ListPhotoViewController ()

// photoList in which the photo object will get collected
@property (nonatomic, strong) NSArray *photoList;

@end

@implementation ListPhotoViewController

@synthesize queryString;
@synthesize photoList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Custom initialization
        self.photoList = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    // Set Credential for Google Api as view Appera's and make a network call.
    GooglePhotoApiCredential *credential = [[GooglePhotoApiCredential alloc] init];
    [credential setServerUrl:[NSString stringWithFormat:@"%@",kServerURL]];
    [credential setServerKey:[NSString stringWithFormat:@"%@",kServerKey]];
    [credential setServerCX:[NSString stringWithFormat:@"%@",kServerCX]];
    [credential setImageType:@"photo"];
    [credential setSearchType:@"image"];
    [credential setQuery:queryString];
    [credential setStartIndex:[NSNumber numberWithInt:10]];

    // Establish a network connection to download the JSON from Google API
    [self searchForPhotos:credential];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Register Custom Nib (In out case PhotoCollectionViewCell, which have ImageView property embed)
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CellIdentifier"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Return the count of the photo's array
    return [self.photoList count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Assign PhotoCollectionViewCell when the cell view's are being loaded
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([self.photoList count] > 0) {
        
        // Cast Photo object from the array
        Photo *photo = (Photo*)[self.photoList objectAtIndex:indexPath.row];
        
        if (!photo.rawImage) {
            
            //Set the Image Place Holder
            UIImage *image = [UIImage imageNamed:@"test.png"];
            cell.imageView.image = image;
            
            // download the image asynchronously
            [self downloadImageWithURL:photo.url completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    //Set the raw Image to the cell image
                    photo.rawImage = image;
                    cell.imageView.image = photo.rawImage;
                    [cell.imageView setNeedsDisplay];
                }
            }];
            
        }

    }
    
    // Set the background color of the cell "White"
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    // Instance of the actual Image View
    UIImageView *iv = cell.imageView;
    
    // Expanded version of the Image View that will animate
    UIImageView* ivExpand = [[UIImageView alloc] initWithImage:iv.image];
    ivExpand.contentMode = iv.contentMode;
    ivExpand.frame = [self.view convertRect:iv.frame fromView:iv.superview];
    ivExpand.userInteractionEnabled = YES;
    ivExpand.clipsToBounds = YES;
    
    
    // This allows to save the original frame size
    objc_setAssociatedObject(ivExpand,"original_frame",[NSValue valueWithCGRect: ivExpand.frame],OBJC_ASSOCIATION_RETAIN);
    
    [UIView transitionWithView: self.view
                      duration: 1.0
                       options: UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        
                        // Animate to full screen
                        [self.view addSubview: ivExpand];
                        ivExpand.frame = self.view.bounds;
                        
                    } completion:^(BOOL finished) {
                        
                        // Add custom gesture to animate back to original case
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
                        [ivExpand addGestureRecognizer:singleTap];
                    }];;
}

- (void)onTap:(UITapGestureRecognizer*)singleTap
{
    [UIView animateWithDuration: 1.0
                     animations:^{
                         
                         //Set the original frame size while animating
                         singleTap.view.frame = [objc_getAssociatedObject(singleTap.view,"original_frame")CGRectValue];
                     }
     
                     completion:^(BOOL finished) {
                         
                         // Remove the Expanded version of the view from superview
                         [singleTap.view removeFromSuperview];
                     }];
}

- (void)searchForPhotos:(GooglePhotoApiCredential*)credential
{
    //Create the instance of the Connection Object (In our case we have set SharedInstance)
    iSearchConnection *connection = [iSearchConnection sharedInstance];
    
    // Request URL initialized.
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?key=%@&cx=%@&imageType=photo&q=%@&searchType=%@&start=%i",credential.serverUrl,credential.serverKey,credential.serverCX,credential.query, credential.searchType,[credential.startIndex intValue]]];
    
    // Connection request made
    [connection connectionRequest:requestURL Completed:^(NSURLResponse *op, NSData *resp, NSError *error) {
        
        if (!error) {
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)op;
            int responseStatusCode = [httpResponse statusCode];
            
            // Check if status code is 200 (Succeeded)
            if (responseStatusCode == 200) {
                
                // Use Dispatch Async behavior to serialize objects and load the content into an array (This avoids the bloackage of Main Thread)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSError *error;
                    
                    // Serialize JSON Object into Dictionary
                    NSDictionary *serializeData = [NSJSONSerialization JSONObjectWithData:resp options:NSJSONReadingAllowFragments error:&error];
                    
                    // Extract Items Object from Dictionary
                    NSArray *imageObject = [serializeData valueForKey:@"items"];
                    
                    // Set a mutable array object to add Photo's object into this array
                    __block NSMutableArray *mutablePhotoList = [[NSMutableArray alloc] initWithCapacity:imageObject.count];

                    // The setting of the array allows to add any older Objects of Photo's into the mutable array (This can be used for lazy loading more images into the array after cell reaches index 10, download more images and show the user. For time constraint I haven't used this option)
                    [mutablePhotoList setArray:self.photoList];
                    
                    // Loop through imageObject to initialzie Photo objects with correct properties and add to the mutable array
                    for (id obj in imageObject) {
                        Photo *photo = [[Photo alloc] initWithDictionary:obj];
                        [mutablePhotoList addObject:photo];
                    }
                    
                    // If serialization didn't had any error in parsing then update the main thread
                    if (!error) {

                        dispatch_sync(dispatch_get_main_queue(), ^{
                            // always update UI on main thread
                            self.photoList = mutablePhotoList;
                            [self.collectionView reloadData];
                        });
                    }
                });
            }
        }
    }];

}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    // This block allows once we have the content of the Image URL, to actually download the raw Image and display it.
    iSearchConnection *connection = [iSearchConnection sharedInstance];
    [connection connectionRequest:url Completed:^(NSURLResponse *op, NSData *resp, NSError *error) {
        if (!error) {
            UIImage *image = [[UIImage alloc] initWithData:resp];
            completionBlock(YES,image);
        }
        else {
            completionBlock(NO,nil);
        }
    }];
    
}

@end
