//
//  LINLocationEditView.m
//  linner
//
//  Created by Lincan Li on 9/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINLocationEditView.h"
#import "LINSettingDataHelper.h"

@interface LINLocationEditView ()
@property (strong, nonatomic) UIScrollView* baseScrollView;
@property (strong, nonatomic) UIView* baseEditorView;
@property (strong, nonatomic) UITextField* locationEditor;
@end

@implementation LINLocationEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"位置";
    
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    self.baseScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.baseEditorView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 44)];
    self.baseEditorView.backgroundColor = [UIColor whiteColor];
    self.locationEditor = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, self.baseEditorView.frame.size.width-20, self.baseEditorView.frame.size.height)];
    self.locationEditor.placeholder = @"Location";
    [self.baseEditorView addSubview:self.locationEditor];
    
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
    
    self.userObject.userLocation = self.locationEditor.text;
    [dataModel save:&error];
    
    LINSettingDataHelper* helper = [LINSettingDataHelper alloc];
    [helper saveForUserInfo:self.userObject.userLocation forKey:@"userLocation"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
