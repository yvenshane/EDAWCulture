//
//  VENUserTypeManager.h
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VENUserTypeManager : NSObject
+ (instancetype)sharedManager;
- (BOOL)isMaster;
- (BOOL)isLogin;

@end
