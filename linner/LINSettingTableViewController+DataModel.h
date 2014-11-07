//
//  LINSettingTableViewController+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingTableViewController.h"

@interface LINSettingTableViewController (DataModel)

- (id) getInitData: (NSString *) entity;
- (LINUserObject *) getUserInfoFromRemote;

- (LINUserSetting *) getUserSettingFromRemote;


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (void) saveImage: (UIImage*)Image toUserObject: (LINUserObject *) userObject;

@end
