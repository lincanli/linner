//
//  LINPhoneViewController.m
//  linner
//
//  Created by Lincan Li on 8/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINPhoneViewController.h"
#import "LINCallingViewController.h"

@interface LINPhoneViewController ()
@property (nonatomic) CGFloat radiusFrame;
@end

@implementation LINPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.phoneTextField.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.navigationController.title = @"电话";
    [self.navigationItem setHidesBackButton:YES];
    
    FAKIonIcons *phoneIcon = [FAKIonIcons ios7TelephoneOutlineIconWithSize:30];
    super.tabBarItem.image = [phoneIcon imageWithSize:CGSizeMake(30, 30)];
    
    FAKIonIcons *chatIcon = [FAKIonIcons ios7ChatbubbleOutlineIconWithSize:25];
    UIBarButtonItem* backToChat = [[UIBarButtonItem alloc]initWithImage:[chatIcon imageWithSize:CGSizeMake(25, 25)] style:UIBarButtonItemStylePlain target:self action:@selector(backToChat:)];
    self.navigationItem.rightBarButtonItem = backToChat;

}

-(void)viewDidLayoutSubviews
{
    self.radiusFrame = self.oneButton.frame.size.width/2;
    
    self.oneButton.layer.cornerRadius = self.radiusFrame;
    self.oneButton.layer.masksToBounds = YES;
    
    self.twoButton.layer.cornerRadius = self.radiusFrame;
    self.twoButton.layer.masksToBounds = YES;
    
    self.threeButton.layer.cornerRadius = self.radiusFrame;
    self.threeButton.layer.masksToBounds = YES;
    
    self.fourButton.layer.cornerRadius = self.radiusFrame;
    self.fourButton.layer.masksToBounds = YES;
    
    self.fiveButton.layer.cornerRadius = self.radiusFrame;
    self.fiveButton.layer.masksToBounds = YES;
    
    self.sixButton.layer.cornerRadius = self.radiusFrame;
    self.sixButton.layer.masksToBounds = YES;
    
    self.sevenButton.layer.cornerRadius = self.radiusFrame;
    self.sevenButton.layer.masksToBounds = YES;
    
    self.eightButton.layer.cornerRadius = self.radiusFrame;
    self.eightButton.layer.masksToBounds = YES;
    
    self.nineButton.layer.cornerRadius = self.radiusFrame;
    self.nineButton.layer.masksToBounds = YES;
    
    self.starButton.layer.cornerRadius = self.radiusFrame;
    self.starButton.layer.masksToBounds = YES;
    
    self.zeroButton.layer.cornerRadius = self.radiusFrame;
    self.zeroButton.layer.masksToBounds = YES;
    
    self.harshButton.layer.cornerRadius = self.radiusFrame;
    self.harshButton.layer.masksToBounds = YES;
    
    self.plusButton.layer.cornerRadius = self.radiusFrame;
    self.plusButton.layer.masksToBounds = YES;
    
    self.callButton.layer.cornerRadius = self.radiusFrame;
    self.callButton.layer.masksToBounds = YES;
    
    self.minusButton.layer.cornerRadius = self.radiusFrame;
    self.minusButton.layer.masksToBounds = YES;
    self.minusButton.hidden = YES;
}

-(void)backToChat: (UIBarButtonItem *)sender
{
    self.navigationController.title = @"聊天";
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)oneButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"1"];
}

- (IBAction)twoButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"2"];
}

- (IBAction)threeButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"3"];
}

- (IBAction)fourButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"4"];
}

- (IBAction)fiveButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"5"];
}

- (IBAction)sixButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"6"];
}

- (IBAction)sevenButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"7"];
}

- (IBAction)eightButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"8"];
}

- (IBAction)nineButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"9"];
}

- (IBAction)starButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"*"];
}

- (IBAction)zeroButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"0"];
}

- (IBAction)hashButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"#"];
}

- (IBAction)plusButtonDidTouched:(id)sender {
    
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:@"+"];
}

- (IBAction)callButtonDidTouched:(id)sender {
    NSLog(@"push");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Calling" bundle:nil];
    LINCallingViewController *CallingViewController = [storyboard instantiateViewControllerWithIdentifier:@"LINCallingViewController"];
    
    if ([self.phoneTextField.text length] > 0 && [self.client isStarted]) {
        id<SINCall> call = [self.client.callClient callPhoneNumber:self.phoneTextField.text];
        NSLog(@"Begin modal");
        CallingViewController.call = call;
        [self presentViewController:CallingViewController animated:YES completion:nil];
    }
    
}

- (id<SINClient>)client {
    return [(LINAppDelegate *)[[UIApplication sharedApplication] delegate] client];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LINCallingViewController *callViewController = [segue destinationViewController];
    callViewController.call = sender;
    callViewController.call.delegate = callViewController;
}



@end
