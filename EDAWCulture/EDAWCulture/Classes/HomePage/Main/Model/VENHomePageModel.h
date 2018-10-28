//
//  VENHomePageModel.h
//  EDAWCulture
//
//  Created by YVEN on 2018/10/21.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageModel : NSObject
@property (nonatomic, copy) NSString *bannersID; // @property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *created_time;

@property (nonatomic, copy) NSString *content;
//@property (nonatomic, copy) NSString *created_time;
//@property (nonatomic, copy) NSString *bannersID;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *thumbnail;
//@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *avatarUrl;
//@property (nonatomic, copy) NSString *bannersID;
@property (nonatomic, copy) NSString *nickname;

//@property (nonatomic, copy) NSString *created_time;
//@property (nonatomic, copy) NSString *bannersID;
@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *price_text;
@property (nonatomic, copy) NSArray *goodFields;

@property (nonatomic, copy) NSString *study;
@property (nonatomic, copy) NSString *isSubscribe;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *province_name;

@end

NS_ASSUME_NONNULL_END
