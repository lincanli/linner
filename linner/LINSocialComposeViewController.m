//
//  LINSocialComposeViewController.m
//  Linner
//
//  Created by Lincan Li on 10/20/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSocialComposeViewController.h"

@interface LINSocialComposeViewController ()

@end

@implementation LINSocialComposeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.errorLabel.hidden = YES;
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraAction:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    self.editorTextView.textContainerInset = UIEdgeInsetsMake(3, 8, 15, 3);
    self.editorTextView.delegate = self;
    self.editorTextView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.editorTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.editorTextView.layer.shadowOpacity = 1.5f;
    self.editorTextView.layer.shadowRadius = 1.0f;
    
    [self.editorTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cameraAction: (UIBarButtonItem *) sender
{

}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    return [self doesFit:textView string:text range:range height:newSize.height];
}


- (float)doesFit:(UITextView*)textView string:(NSString *)myString range:(NSRange) range height: (CGFloat) height
{
    float width = textView.textContainer.size.width;
    
    NSMutableAttributedString *atrs = [[NSMutableAttributedString alloc] initWithAttributedString: textView.textStorage];
    [atrs appendAttributedString: [[NSAttributedString alloc]initWithString: myString]];
    
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:atrs];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: CGSizeMake(width, FLT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    float textHeight = [layoutManager
                        usedRectForTextContainer:textContainer].size.height;
    
    if (textHeight < 90 || myString.length == 0) {
        if (height > 33)
            [UIView animateWithDuration:0.5 animations:^{
                [self.editorHeightConstraint setConstant:textHeight + 18];
            }];
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}



@end