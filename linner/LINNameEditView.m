//
//  LINNameEditView.m
//  linner
//
//  Created by Lincan Li on 9/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINNameEditView.h"
#import "LINSettingDataHelper.h"

@interface LINNameEditView ()
@property (strong, nonatomic) UIScrollView* baseScrollView;
@property (strong, nonatomic) UIView* baseEditorView;
@property (strong, nonatomic) UITextField* nameEditor;
@property (strong, nonatomic) UIButton* confirmButton;

@end

@implementation LINNameEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"姓名";
    
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    self.baseScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.baseEditorView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 44)];
    self.baseEditorView.backgroundColor = [UIColor whiteColor];
    self.nameEditor = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, self.baseEditorView.frame.size.width-20, self.baseEditorView.frame.size.height)];
    self.nameEditor.placeholder = @"Name";
    [self.baseEditorView addSubview:self.nameEditor];
    [self.baseScrollView addSubview:self.baseEditorView];
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButton:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
    [self.baseScrollView addSubview:self.confirmButton];
    [self.view addSubview:self.baseScrollView];

}

-(void) confirmButton: (UIBarButtonItem *)sender
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* error = nil;
    
    self.userObject.userRealName = self.nameEditor.text;
    [dataModel save:&error];
    
    LINSettingDataHelper* helper = [LINSettingDataHelper alloc];
    [helper saveForCurrentUser:self.userObject.userRealName forKey:@"name"];
    [helper saveForUserInfo:self.userObject.userRealName forKey:@"userRealName"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
