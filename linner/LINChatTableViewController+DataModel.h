//
//  LINChatTableViewController+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINChatTableViewController.h"
#import "LINMessageList.h"

@interface LINChatTableViewController (DataModel)

-(NSMutableArray *) getInitData;
-(NSMutableArray *) getDataFromRemote;
-(void)deleteCorrespondingMessgageRecord: (LINMessageList *) messageList;

@end
