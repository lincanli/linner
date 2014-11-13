//
//  LINNewSocialViewController.m
//  Linner
//
//  Created by Lincan Li on 11/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#include <tgmath.h>
#import "LINNewSocialViewController.h"

@interface LINNewSocialViewController ()

@end

@implementation LINNewSocialViewController
static CGFloat viewWith;
static CGFloat viewHeight;
static CGFloat textViewWidthInset;
static CGFloat halfLineHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布一句话";
    
    [self initialDataSetUp];
    [self textViewSetUp];
    
    self.socialTextView.text = @"Lorem Ipsum is simply dummy text";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPicture:)];
    
    UILongPressGestureRecognizer* pressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPressed:)];
    pressGesture.minimumPressDuration = 1.0;
    [self.navigationItem.rightBarButtonItem.customView addGestureRecognizer:pressGesture];
    
}

- (void)initialDataSetUp
{
    viewWith = self.view.frame.size.width;
    viewHeight = 200;
    textViewWidthInset = 20;
    halfLineHeight = self.socialTextView.font.lineHeight / 2;
}

- (void)textViewSetUp
{
    self.socialTextView.delegate = self;
    self.socialTextView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.socialTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.socialTextView.layer.shadowOpacity = 1.0f;
    self.socialTextView.layer.shadowRadius = 1.0f;
    self.socialTextView.textContainerInset = UIEdgeInsetsMake(viewHeight / 2 - halfLineHeight,
                                                              textViewWidthInset, viewHeight / 2 - halfLineHeight, textViewWidthInset);
}

- (void)addPicture: (id) sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self showDetailViewController:picker sender:nil];
}

- (void)didLongPressed: (id) sender
{
    NSLog(@"long pressed");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* rawImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(rawImage==nil)
        rawImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(rawImage==nil)
        rawImage = [info objectForKey:UIImagePickerControllerCropRect];
    
//    UIImageWriteToSavedPhotosAlbum(rawImage, nil, nil, nil);
    
    self.baseImageView.image = rawImage;
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    CGFloat insetHeight = ((viewHeight / 2) - textView.textContainerInset.top) * 2;
    NSLog(@"====");

    NSLog(@"insetInfo: top: %f, bottom: %f, height: %f ", textView.textContainerInset.top, textView.textContainerInset.bottom, insetHeight);
    
    return [self doesFit:textView string:text range:range height:insetHeight];
}


- (float)doesFit:(UITextView*)textView string:(NSString *)myString range:(NSRange) range height: (CGFloat) height
{
    NSMutableAttributedString *stringTmp = [[NSMutableAttributedString alloc] initWithAttributedString: textView.textStorage];
    [stringTmp appendAttributedString: [[NSAttributedString alloc]initWithString: myString]];
    [stringTmp appendAttributedString: [[NSAttributedString alloc]initWithString: @"   ."]];

    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:stringTmp];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: CGSizeMake(viewWith - 2 * textViewWidthInset, FLT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    CGFloat textHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;
    
    if (textHeight < 80 || myString.length == 0) {
        NSLog(@"info: textHeight : %f, height : %f, length: %lu", textHeight, height, (unsigned long)myString.length);
        
        if (floor(textHeight) > floor(height)) {
            NSLog(@"1");
            textView.textContainerInset = UIEdgeInsetsMake(textView.textContainerInset.top - halfLineHeight,
                                                           textViewWidthInset,
                                                           textView.textContainerInset.bottom - halfLineHeight,
                                                           textViewWidthInset);
        }else if(floor(textHeight) < floor(height)){
            NSLog(@"2");
            textView.textContainerInset = UIEdgeInsetsMake(textView.textContainerInset.top + halfLineHeight,
                                                           textViewWidthInset,
                                                           textView.textContainerInset.bottom + halfLineHeight,
                                                           textViewWidthInset);
        }else{
            NSLog(@"3");
        }
        
        
        return YES;
        
    } else {
        //
        
        NSLog(@"1info: textHeight : %f, height : %f, length: %lu", textHeight, height, (unsigned long)myString.length);
        
        self.errorMessageTextLable.hidden = NO;
        self.errorMessageTextLable.text = @"超过最大输入量";
        
        return NO;
        
    }
}



@end
