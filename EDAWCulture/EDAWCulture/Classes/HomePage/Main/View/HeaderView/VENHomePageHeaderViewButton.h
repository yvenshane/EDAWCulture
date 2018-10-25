//
//  VENHomePageHeaderViewButton.h
//  EDAWCulture
//
//  Created by YVEN on 2018/9/4.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENHomePageHeaderViewButton : UIButton
@property (nonatomic, strong) UILabel *buttonTitleLabel;
@property (nonatomic, assign) CGFloat buttonTitleLabelHeight;
@property (nonatomic, assign) CGFloat buttonTitleLabelFontSize;

@property (nonatomic, strong) UIImageView *buttonImage;
@property (nonatomic, assign) CGFloat buttonImageWidth;

@property (nonatomic, copy) NSString *imageName;
//@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, assign) CGFloat imageTitleSpace;

@property (nonatomic, copy) NSString *titleString;

- (instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *)title setImageName:(NSString *)imageName setButtonImageWidth:(CGFloat)buttonImageWidth setImageTitleSpace:(CGFloat)imageTitleSpace setButtonTitleLabelFontSize:(CGFloat)buttonTitleLabelFontSize;

@end
