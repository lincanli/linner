//
//  LINEmailEditingView.m
//  linner
//
//  Created by Lincan Li on 9/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINEmailEditingView.h"
#import "LINSettingDataHelper.h"

@interface LINEmailEditingView ()
@property (strong, nonatomic) UIScrollView* baseScrollView;
@property (strong, nonatomic) UIView* baseEditorView;
@property (strong, nonatomic) UITextField* emailEditor;
@end

@implementation LINEmailEditingView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"Email";
    
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    self.baseScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.baseEditorView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 44)];
    self.baseEditorView.backgroundColor = [UIColor whiteColor];
    self.emailEditor = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, self.baseEditorView.frame.size.width-20, self.baseEditorView.frame.size.height)];
    self.emailEditor.placeholder = @"Email";
    [self.baseEditorView addSubview:self.emailEditor];
    [self.baseScrollView addSubview:self.baseEditorView];
    [self.view addSubview:self.baseScrollView];

    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButton:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
}

-(void) confirmButton: (UIBarButtonItem *)sender
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* error = nil;
    
    self.userObject.userEmail = self.emailEditor.text;
    [dataModel save:&error];
    
    LINSettingDataHelper* helper = [LINSettingDataHelper alloc];
    [helper saveForCurrentUser:self.userObject.userEmail forKey:@"email"];
    [helper saveForUserInfo:self.userObject.userEmail forKey:@"userEmail"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
