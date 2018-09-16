//
//  VENUserTypeManager.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENUserTypeManager.h"

@implementation VENUserTypeManager

+ (instancetype)sharedUserTypeManager {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)isMaster {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"] isEqualToString:@"1"] ? YES : NO;
}

@end