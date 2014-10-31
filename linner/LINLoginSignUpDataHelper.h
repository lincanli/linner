//
//  LINLoginSignUpDataHelper.h
//  Linner
//
//  Created by Lincan Li on 10/19/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINLoginSignUpDataHelper : NSObject
- (BOOL) saveForUserObject: (NSString *) currentUsername signUp: (BOOL) signUp;

@end
