//
//  VENConfirmationOfOrderViewController.h
//  EDAWCulture
//
//  Created by YVEN on 2018/10/25.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENConfirmationOfOrderViewController : UIViewController
@property (nonatomic, strong) VENHomePageModel *model;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *imageURL;

@property (nonatomic, assign) BOOL isContinuePayment; // 继续支付

@end

NS_ASSUME_NONNULL_END
