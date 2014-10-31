//
//  LINPhoneNumberSelectTableViewController.h
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LINPhoneNumberSelectTableViewControllerDelegate <NSObject>

- (void) didSelectedCountry: (id) sender;

@end


@interface LINPhoneNumberSelectTableViewController : UIViewController <UITableViewDelegate>

@property (weak, nonatomic) id<LINPhoneNumberSelectTableViewControllerDelegate> delegate;

@end
