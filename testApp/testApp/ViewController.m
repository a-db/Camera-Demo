//
//  ViewController.m
//  testApp
//
//  Created by Aaron Burke on 8/19/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

// Array to hold main menu button pointers
@property(nonatomic,strong) NSMutableArray *btnArray;
// Property to keep up with menu view animation
@property(nonatomic,assign) BOOL hasAnimated;
// Property to hold the video path for saving a video
@property(nonatomic,strong) NSString *videoPath;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.btnArray = [[NSMutableArray alloc] initWithObjects:self.photoBtn,self.videoBtn,self.albumBtn, nil];
    
    // Setup tap recognizer on instructions to dismiss
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.instructions addGestureRecognizer:recognizer];
    self.instructions.userInteractionEnabled =  YES;
    
    // Set subviews to hidden for photo and video mode
    self.photoView.hidden = YES;
    self.videoView.hidden = YES;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleTap:(UITapGestureRecognizer *)recognize
{
    // Hide instructions
    self.instrView.hidden = YES;

}

-(IBAction)onClick:(UIButton*)button
{
    
    // Control button highlight state
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        for (UIButton *btn in self.btnArray) {
            if (button == btn) {
                btn.highlighted = YES;
            } else {
                btn.highlighted = NO;
            }
        }
    }];
    
    // Animate the view
    if (self.hasAnimated == NO && button.tag != 3) {
        [self animateDown];
    }
    
    // Controls for all buttons
    if (button.tag == 0) { // Photo Button
        NSLog(@"Button 0");
        [self performSelector:@selector(photoBtnAction) withObject:nil afterDelay:0.0f];
        self.photoView.alpha = 0;
        self.photoView.hidden = NO;
        
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseIn
                         animations:^
         {
             self.photoView.alpha = 1.0;
             
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed Animation");
         }];

    } else if (button.tag == 1) { // Video Button
        
        NSLog(@"Button 1");
        self.photoView.hidden = YES;
        self.videoView.alpha = 0;
        self.videoView.hidden = NO;
        
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseIn
                         animations:^
         {
             self.videoView.alpha = 1.0;
             
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed Animation");
         }];
        
        [self performSelector:@selector(videoBtnAction) withObject:nil afterDelay:0.0f];
        
    } else if (button.tag == 2) { // Album Button
        
        NSLog(@"Button 2");
        self.photoView.hidden = YES;
        [self performSelector:@selector(albumBtnAction) withObject:nil afterDelay:0.0f];
        
    } else if (button.tag == 3) { // Info/Instructions Button
        
        self.instrView.alpha = 0.0;
        self.instrView.hidden = NO;
        self.photoView.hidden = YES;
        self.videoView.hidden = YES;
        
        self.videoImg.image = nil;
        self.videoPath = nil;
        self.origImg.image = nil;
        self.editImg.image = nil;
        
        if (self.hasAnimated == YES) {
            
            [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn
                             animations:^
             {
                 // Autolayout animating constraints
                 self.buttonHolderVSBottomSuper.constant = 325;
                 self.blueBGVSBottomSuper.constant = 371;
                 [self.view layoutIfNeeded];
                 self.instrView.alpha = 1.0;
                 
                 // Code below was for not using Autolayout
//                 // Blue background view
//                 CGRect frame = self.blueBg.frame;
//                 frame.origin.y = -250;
//                 frame.origin.x = 0;
//                 self.blueBg.frame = frame;
//                 
//                 // View that holds the buttons
//                 CGRect frame2 = self.btnView.frame;
//                 frame2.origin.y = 131;
//                 frame2.origin.x = 20;
//                 self.btnView.frame = frame2;
             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed Animation");
                 self.hasAnimated = NO;
                 
             }];
            
        } else {
            
            [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn
                             animations:^
             {
                 self.instrView.alpha = 1.0;
                 
             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed Animation");
                 
             }];

        }
    } else if (button.tag == 4) { // Save Button 
        // Save Original Image
        if (self.origImg.image) {
            UIImageWriteToSavedPhotosAlbum(self.origImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        // Save Edited Image
        if (self.editImg.image) {
            UIImageWriteToSavedPhotosAlbum(self.editImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        if (self.videoPath) {
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        if (self.photoView.hidden == NO) {
            self.photoView.hidden = YES;
        } else if (self.videoView.hidden == NO) {
            self.videoView.hidden = YES;
        }
        
        [self animateUp];
        
    } else if (button.tag == 5) { // Cancel Button
        // Delete Original Image
        if (self.origImg.image) {
            self.origImg.image = nil;
        }
        // Delete Edited Image
        if (self.editImg.image) {
            self.editImg.image = nil;
        }
        if (self.photoView.hidden == NO) {
            self.photoView.hidden = YES;
        } else if (self.videoView.hidden == NO) {
            self.videoView.hidden = YES;
        }
        [self animateUp];
    }

}

// Method for photo button action
- (void)photoBtnAction
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if (pickerController) {
        if (pickerController.sourceType) {
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.delegate = self;
            pickerController.allowsEditing = TRUE;
            [self presentViewController:pickerController animated:TRUE completion:nil];
        }
    
    }
}
// Method for album button action
- (void)albumBtnAction
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if (pickerController) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.delegate = self;
        pickerController.allowsEditing = TRUE;
        [self presentViewController:pickerController animated:TRUE completion:nil];
    }
}
// Method for video button action
- (void)videoBtnAction
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if (pickerController) {
        if (pickerController.sourceType) {
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.delegate = self;
            pickerController.allowsEditing = FALSE;
            pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
            pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString*) kUTTypeMovie, nil];
            [self presentViewController:pickerController animated:TRUE completion:nil];
        }

    }
}

// Animates main menu up
- (void)animateUp
{
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         // Autolayout animating constraints
         self.buttonHolderVSBottomSuper.constant = 325;
         self.blueBGVSBottomSuper.constant = 371;
         [self.view layoutIfNeeded];
       
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed Animation");
         self.hasAnimated = NO;
         
     }];
}

// Animates main menu down
- (void)animateDown
{
    
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionTransitionNone
                     animations:^
     {
         self.buttonHolderVSBottomSuper.constant = 20;
         self.blueBGVSBottomSuper.constant = 66;
         [self.view layoutIfNeeded];
      
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed Animation");
         self.hasAnimated = YES;
         
     }];
}

// Image selected
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    
    if ([info objectForKey:@"UIImagePickerControllerOriginalImage"]) { // Instance for photos
        UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if (selectedImage) {
            self.origImg.image = selectedImage;
        }
        if (picker.allowsEditing == TRUE) {
            UIImage *scaledImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            if (scaledImage) {
                self.editImg.image = scaledImage;
            }
        }
    } else if ([info valueForKey:@"UIImagePickerControllerMediaURL"]) { // Instance for videos
        NSURL *urlStr = [info valueForKey:@"UIImagePickerControllerMediaURL"];
        if (urlStr) {
            self.videoPath = [urlStr path];
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:urlStr];
            UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            self.videoImg.image = thumbnail;
        }
    }
    
}

// Selection Canceled
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.photoView.hidden = YES;
    self.videoView.hidden = YES;
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    [self animateUp];
    
    // Deselect the highlighted button 
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        for (UIButton *btn in self.btnArray) {
            if (btn.highlighted) {
                btn.highlighted = NO;
            }
        }
    }];
}

// Finish Saving Images
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    if (error) {
        NSLog(@"%@", [error description]);
    } else {
        if (image == self.origImg.image) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Original Photo Saved to Album." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            self.origImg.image = nil;
        } else if (image == self.editImg.image) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Edited Photo Saved to Album." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
             self.editImg.image = nil;
        }
    }
}

// Finish Saving Images
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    if (error) {
        NSLog(@"%@", [error description]);
    } else {
        self.videoImg.image = nil;
        self.videoPath = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Video Saved to Album." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
