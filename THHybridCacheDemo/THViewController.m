//
//  THViewController.m
//  THHybridCacheDemo
//
//  Created by Thomas Heß on 5.10.12.
//  Copyright (c) 2012 Thomas Heß. All rights reserved.
//

#import "THViewController.h"
#import "THHybridCache.h"

@interface THViewController ()
{
    dispatch_queue_t _imageLoadingQueue;
}

@end

@implementation THViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[THHybridCache sharedCache] clearCache];
}

- (IBAction)loadImage:(id)sender
{
    UIImageView* imgView = (sender == self.btn1) ? self.imgView1 : self.imgView2;

    NSString* imgKey = @"name.thomashess.THHybridCacheDemo.THViewController.imageKey";
    
    UIImage* img = [[THHybridCache sharedCache] imageForKey:imgKey onlyFromMemory:NO];
    
    if (img)
    {
        imgView.image = img;
        return;
    }
    
    __block UIActivityIndicatorView* activityView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = imgView.bounds;
    [imgView addSubview:activityView];
    [activityView startAnimating];
    
    if (! _imageLoadingQueue)
        _imageLoadingQueue = dispatch_queue_create("name.thomashess.THHybridCacheDemo.THViewController.imageLoading", 0);

    dispatch_async(_imageLoadingQueue, ^{
        
        NSString* imgURL = @"http://www.public-domain-photos.com/free-stock-photos-3/flowers/red-tulips.jpg";
        NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage* img = [UIImage imageWithData:imgData];
            if (img)
            {
                imgView.image = img;
                [activityView removeFromSuperview];
                activityView = nil;
                [[THHybridCache sharedCache] cacheImage:img forKey:imgKey inMemory:YES onDisk:YES
                                        hasTransparency:NO];
                self.btn2.enabled = YES;
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to load image"
                                                                message:nil delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
