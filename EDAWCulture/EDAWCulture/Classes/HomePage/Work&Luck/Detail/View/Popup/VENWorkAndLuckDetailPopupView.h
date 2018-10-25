//
//  VENWorkAndLuckDetailPopupView.h
//  EDAWCulture
//
//  Created by YVEN on 2018/9/7.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageModel;

typedef void (^choiceModelBlock)(VENHomePageModel *);

@interface VENWorkAndLuckDetailPopupView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *purchaseButton;
@property (nonatomic, assign) NSInteger indexPath;

@property (nonatomic, copy) NSArray *dataSourceArr;
@property (nonatomic, copy) choiceModelBlock block;

@end
