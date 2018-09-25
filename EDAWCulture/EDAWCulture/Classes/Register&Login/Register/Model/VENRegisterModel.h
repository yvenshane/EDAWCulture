//
//  VENRegisterModel.h
//  EDAWCulture
//
//  Created by YVEN on 2018/9/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VENRegisterModel : NSObject
@property (nonatomic, copy) NSArray *provinces;
@property (nonatomic, assign) NSInteger *uniqueId;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, assign) NSInteger *province_id;

@end
