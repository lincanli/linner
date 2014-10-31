//
//  LINSettingTableViewController.m
//  linner
//
//  Created by Lincan Li on 7/27/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingTableViewController.h"
#import "LINSettingTableViewController+DataModel.h"
#import "LINUserObject.h"
#import "LINUserSetting.h"

#import "LINFinanceControlTableViewController.h"


#import "Reachability.h"

@interface LINSettingTableViewController ()
@property (strong, nonatomic) NSArray* settingArray;
@property (strong, nonatomic) LINUserObject* userObject;
@property (strong, nonatomic) LINUserSetting* userSetting;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) AVUser* currentUser;

@end

@implementation LINSettingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.settingArray = [NSArray arrayWithObjects:@"个人资料", @"隐私", @"通用", @"财务", @"登出", nil];
    self.imagePickerController = [[UIImagePickerController alloc]init];
    
    self.currentUser = [AVUser currentUser];
    self.userObject = [self getInitData:@"UserObject"];
    self.userSetting = [self getInitData:@"UserSetting"];
    NSLog(@"finished loading local data");
    
}

- (void)getRemoteData
{
    NSLog(@"getting data");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.userObject = [self getUserInfoFromRemote];
        self.userSetting = [self getUserSettingFromRemote];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus != NotReachable)
        [self getRemoteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 4;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProfileCellIdentifier = @"SettingTableViewProfileCellIdentifier";
    static NSString *NormalCellIdentifier = @"ExploretTableViewCellIdentifier";
    static NSString *LogoutCellIdentifier = @"LogoutCellIdentifier";
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (indexPath.section == 0) {
        LINSettingTableViewUserProfileCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingUserProfileCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImage* userProfilePhoto = [[UIImage alloc]initWithData:self.userObject.userProfilePhoto];
        
        if (userProfilePhoto != nil) {
            cell.SettingTableViewCellThumbnailImage.image =  [self imageWithImage:userProfilePhoto scaledToSize:CGSizeMake(90, 90)];
        }else{
            FAKIonIcons *aIcon = [FAKIonIcons personStalkerIconWithSize:90];
            [aIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
            cell.SettingTableViewCellThumbnailImage.image = [aIcon imageWithSize:CGSizeMake(80, 80)];
        }
        
        cell.SettingTableViewCellThumbnailImage.layer.cornerRadius = cell.SettingTableViewCellThumbnailImage.frame.size.width/2;
        cell.SettingTableViewCellThumbnailImage.layer.masksToBounds = YES;
        
        cell.SettingTableViewCellNameLable.text = self.userObject.userRealName;
        cell.SettingTableViewCellDescriptionLable.text = self.userObject.userDescription;
        cell.SettingTableViewCellDescriptionLable.lineBreakMode = NSLineBreakByWordWrapping;
        cell.SettingTableViewCellDescriptionLable.numberOfLines = 0;
        [cell.SettingTableViewCellDescriptionLable sizeToFit];
        
        cell.balanceLable.text = @"余额：{$1000000000.00}";
        
        NSLog(@"description : %@ ", self.userObject.description);
        
        return cell;
        
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
        FAKIonIcons *cellIcon;
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cellIcon = [FAKIonIcons ios7PersonIconWithSize:30];
        }else if (indexPath.row == 1){
            cellIcon = [FAKIonIcons keyIconWithSize:30];
        }else if (indexPath.row == 2){
            cellIcon = [FAKIonIcons ios7CogIconWithSize:30];
        }else if (indexPath.row == 3){
            cellIcon = [FAKIonIcons cardIconWithSize:30];

        }
        
        [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
        
        cell.textLabel.text = [self.settingArray objectAtIndex:indexPath.row];
        cell.imageView.image = [cellIcon imageWithSize:CGSizeMake(30, 30)];
        
        return cell;
        
    }else{
        LINLogOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LogoutCellIdentifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LogoutTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.LogoutLable.text = @"登出";
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        //ProfileImage
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        actionSheet.delegate = self;
        [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            //Personal Profile
            
            LINPersonalProfileTableViewController* ProfileView = [LINPersonalProfileTableViewController alloc];
            ProfileView.hidesBottomBarWhenPushed = YES;
            ProfileView.userObject = self.userObject;
            [self.navigationController pushViewController:ProfileView animated:YES];
            
        }else if (indexPath.row == 1){
            //Privacy LINSettingPrivacyControl
            
            LINSettingPrivacyControl* PrivacyView = [LINSettingPrivacyControl alloc];
            PrivacyView.hidesBottomBarWhenPushed = YES;
            PrivacyView.userSetting = self.userSetting;
            [self.navigationController pushViewController:PrivacyView animated:YES];

        }else if (indexPath.row == 2){
            //Gernal Setting
            
            LINSettingGeneralControl* GeneralView = [LINSettingGeneralControl alloc];
            GeneralView.hidesBottomBarWhenPushed = YES;
            GeneralView.userSetting = self.userSetting;
            [self.navigationController pushViewController:GeneralView animated:YES];
        }else{
            
            LINFinanceControlTableViewController* financeControlVC = [LINFinanceControlTableViewController alloc];
            [self showViewController:financeControlVC sender:nil];
        
        }
    }else{
        //Logout
        
        [self deleteAllObjects:@"UserSetting"];
        [self deleteAllObjects:@"UserObject"];
        [self deleteAllObjects:@"UserRelation"];
        [self deleteAllObjects:@"MessageList"];
        [self deleteAllObjects:@"MessageRecord"];
        
        
        
        [AVUser logOut];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndLogout" bundle:[NSBundle mainBundle]];
        self.view.window.rootViewController = [storyboard instantiateInitialViewController];
        
    }
    
    
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:dataModel];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [dataModel executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [dataModel deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![dataModel save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.imagePickerController.delegate = self;

    if (buttonIndex == 0) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.allowsEditing = YES;
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];

    }else if(buttonIndex == 1){
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.allowsEditing = YES;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];

    }
    
    //NSLog(@"You have pressed the %@ button", [actionSheet buttonTitleAtIndex:buttonIndex]);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        topLineView.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7" alpha:1];
        [cell.contentView addSubview:topLineView];
    }
    
    if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, self.view.bounds.size.width, 1)];
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7" alpha:1];
        [cell.contentView addSubview:bottomLineView];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* originalImage = nil;
    
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(originalImage==nil)
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(originalImage==nil)
        originalImage = [info objectForKey:UIImagePickerControllerCropRect];
    
    [self saveImage:originalImage];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.0;
    }else{
        return 44.0;
    }
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 34.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}


@end
