//
//  LINProfileTableViewControllerPointToPoint+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/30/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileTableViewControllerPointToPoint.h"
#import "LINUserRelation.h"

@interface LINProfileTableViewControllerPointToPoint (DataModel)

-(void) updateUserRelation: (LINUserRelation *) targetUserRelation withSettingName: (NSString *) settingName allowed:(BOOL) allowed;
-(void) updateMessageList: (LINMessageList *) messageList withSettingName: (NSString *) settingName allowed:(BOOL) allowed;
-(void) disableUser: (LINUserRelation *) targetUserRelation;

@end
