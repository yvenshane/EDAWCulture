//
//  VENHomePageHeaderViewScrollView.h
//  EDAWCulture
//
//  Created by YVEN on 2018/9/4.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class VENHomePageHeaderViewScrollView;
@protocol VENHomePageHeaderViewScrollViewDelegate <NSObject>

- (void)buttonUpInsideWithView:(UIButton *)btn withIndex:(NSInteger)index withView:(VENHomePageHeaderViewScrollView *)view;

@end;

@interface VENHomePageHeaderViewScrollView : UIView
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger lineMaxCount;
@property (nonatomic, assign) BOOL pageControlIsShow;

@property (nonatomic, weak) id<VENHomePageHeaderViewScrollViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewsArray:(NSArray *)views maxCount:(NSInteger)count lineMaxCount:(NSInteger)lineCount pageControlIsShow:(BOOL)show;

@end
NS_ASSUME_NONNULL_END
