//
//  LINMessageListModelData+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/22/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINMessageListModelData.h"

@interface LINMessageListModelData (DataModel)

- (NSMutableArray *) getInitData: (LINUserObject *) targetUser messageList: (LINMessageList *) messageList;

@end
