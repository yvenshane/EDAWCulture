//
//  VENNetworkTool.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/16.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNetworkTool.h"

@implementation VENNetworkTool

static VENNetworkTool *instance;
static dispatch_once_t onceToken;

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:@"http://yidao.ahaiba.com.cn/api/index.php/"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 15;
        instance = [[self alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];

        [instance.requestSerializer setValue:[[VENUserTypeManager sharedManager] isLogin] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"apiKey"] : @"user_ios_lower_key" forHTTPHeaderField:@"X-API-KEY"];
        
        NSString *tempStr = @"";
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"] isEqualToString:@"2"]) {
            tempStr = @"2";
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"] isEqualToString:@"1"]) {
            tempStr = @"1";
        } else {
            tempStr = @"0";
        }
        
        [instance.requestSerializer setValue:tempStr forHTTPHeaderField:@"userType"];

        NSLog(@"X-API-KEY - %@", [[VENUserTypeManager sharedManager] isLogin] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"apiKey"] : @"user_ios_lower_key");
        NSLog(@"userType - %@", tempStr);
        
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    });
    return instance;
}

+ (void)resetInstance {
    instance = nil;
    onceToken = 0l;
}

@end
