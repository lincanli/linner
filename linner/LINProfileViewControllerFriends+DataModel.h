//
//  LINProfileViewControllerFriends+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/23/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileViewControllerFriends.h"
#import "LINMessageList.h"
#import "LINUserRelation.h"

@interface LINProfileViewControllerFriends (DataModel)

-(LINMessageList *) messageListInit: (LINUserRelation *) targetUserRelation;

@end
