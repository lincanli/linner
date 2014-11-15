//
//  LINSocialPageTableViewController+DataModel.h
//  Linner
//
//  Created by Lincan Li on 11/14/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSocialPageTableViewController.h"

@interface LINSocialPageTableViewController (DataModel)

- (LINUserObject *) returnSelf;
- (NSMutableArray *) getInitData;
- (NSMutableArray *) getDataFromRemote;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
