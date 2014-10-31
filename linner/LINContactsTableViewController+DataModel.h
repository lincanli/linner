//
//  LINContactsTableCellTableViewCell+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/19/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINContactsTableViewController.h"

@interface LINContactsTableViewController (DataModel)
-(NSMutableArray *) getInitData;
-(NSMutableArray *) getDataFromRemote;

@end
