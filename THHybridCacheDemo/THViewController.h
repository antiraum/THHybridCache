//
//  THViewController.h
//  THHybridCacheDemo
//
//  Created by Thomas Heß on 5.10.12.
//  Copyright (c) 2012 Thomas Heß. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView* imgView1;
@property (nonatomic, weak) IBOutlet UIImageView* imgView2;
@property (nonatomic, weak) IBOutlet UIButton* btn1;
@property (nonatomic, weak) IBOutlet UIButton* btn2;

- (IBAction)loadImage:(id)sender;

@end
