//
//  LINPaymentViewController.m
//  Linner
//
//  Created by Lincan Li on 10/30/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINPaymentViewController.h"
#import "PTKView.h"
#import "Stripe.h"

@interface LINPaymentViewController ()<PTKViewDelegate>
@property(weak, nonatomic) PTKView *paymentView;

@end

@implementation LINPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    PTKView *view = [[PTKView alloc] initWithFrame:CGRectMake(15,20,290,55)];
    self.paymentView = view;
    self.paymentView.delegate = self;
    [self.view addSubview:self.paymentView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTouched:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveButtonTouched: (id) sender
{
    NSLog(@"save");
    
    STPCard *card = [[STPCard alloc] init];
    card.number = self.paymentView.card.number;
    card.expMonth = self.paymentView.card.expMonth;
    card.expYear = self.paymentView.card.expYear;
    card.cvc = self.paymentView.card.cvc;
    [Stripe createTokenWithCard:card completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSLog(@"errorWithCard : %@", error);
        } else {
            NSLog(@"tokenWithCard : %@", token);
        }
    }];
    
}

- (void)paymentView:(PTKView *)view withCard:(PTKCard *)card isValid:(BOOL)valid
{
    // Toggle navigation, for example
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

@end
