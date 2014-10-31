//
//  LINPaymentViewController.m
//  Linner
//
//  Created by Lincan Li on 10/30/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINPaymentViewController.h"
#import "PTKView.h"

@interface LINPaymentViewController ()<PTKViewDelegate>
@property(weak, nonatomic) PTKView *paymentView;

@end

@implementation LINPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;

    
    PTKView *view = [[PTKView alloc] initWithFrame:CGRectMake(15,20,290,55)];
    self.paymentView = view;
    self.paymentView.delegate = self;
    [self.view addSubview:self.paymentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
