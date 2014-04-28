//
//  ViewController.h
//  testApp
//
//  Created by Aaron Burke on 8/19/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *blueBg;
@property (strong, nonatomic) IBOutlet UIButton *photoBtn;
@property (strong, nonatomic) IBOutlet UIButton *albumBtn;
@property (strong, nonatomic) IBOutlet UIButton *videoBtn;
@property (strong, nonatomic) IBOutlet UIView *btnView;
@property (strong, nonatomic) IBOutlet UIImageView *instructions;
@property (strong, nonatomic) IBOutlet UIView *instrView;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *origImg;
@property (strong, nonatomic) IBOutlet UIImageView *editImg;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIImageView *videoImg;

// Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHolderVSBottomSuper;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blueBGVSBottomSuper;

-(IBAction)onClick:(UIButton*)button;

@end
