//
//  LINBirthdayEditView.m
//  linner
//
//  Created by Lincan Li on 9/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINBirthdayEditView.h"
#import "LINSettingDataHelper.h"

@interface LINBirthdayEditView ()
@property (strong, nonatomic) UIScrollView* baseScrollView;
@property (strong, nonatomic) UIView* baseEditorView;
@property (strong, nonatomic) UITextField* birhtdayEditor;
@property (strong, nonatomic) NSDate* pickerDate;
@end

@implementation LINBirthdayEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"生日";
    
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    self.baseScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.baseEditorView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 44)];
    self.baseEditorView.backgroundColor = [UIColor whiteColor];
    self.birhtdayEditor = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, self.baseEditorView.frame.size.width-20, self.baseEditorView.frame.size.height)];
    self.birhtdayEditor.placeholder = @"Birthday";
    [self.baseEditorView addSubview:self.birhtdayEditor];
    
    [self.baseScrollView addSubview:self.baseEditorView];
    
    [self.view addSubview:self.baseScrollView];
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButton:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.birhtdayEditor.inputView = datePicker;
    [self.birhtdayEditor becomeFirstResponder];
    
}

-(void) confirmButton: (UIBarButtonItem *)sender
{
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* error = nil;
    
    self.userObject.userBirthday = self.pickerDate;
    [dataModel save:&error];
    
    LINSettingDataHelper* helper = [LINSettingDataHelper alloc];
    [helper saveForUserInfo:self.userObject.userBirthday forKey:@"userBirthday"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)datePickerDateChanged: (UIDatePicker *) picker
{
    self.pickerDate = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MMM-dd"];
    
    self.birhtdayEditor.text=[dateFormat stringFromDate:self.pickerDate];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
