//
//  LINProfileSettingDataHelper.h
//  Linner
//
//  Created by Lincan Li on 10/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINSettingDataHelper : NSObject

- (void) saveForCurrentUser: (id)object forKey: (NSString *) key;
- (void) saveForUserInfo: (id)object forKey: (NSString *) key;
- (void) saveForUserSetting: (id)object forKey: (NSString *) key;

@end
