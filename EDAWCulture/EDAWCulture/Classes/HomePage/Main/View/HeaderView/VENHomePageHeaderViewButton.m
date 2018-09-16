//
//  VENHomePageHeaderViewButton.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/4.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageHeaderViewButton.h"

@implementation VENHomePageHeaderViewButton

- (instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *)title setImageName:(NSString *)imageName setButtonImageWidth:(CGFloat)buttonImageWidth setImageTitleSpace:(CGFloat)imageTitleSpace setButtonTitleLabelFontSize:(CGFloat)buttonTitleLabelFontSize {
    
    if (self = [super initWithFrame:frame]) {
        self.titleString = title;
        self.imageName = imageName;
//        self.imageURLString = imageURLString;
        self.buttonImageWidth = buttonImageWidth;
        self.imageTitleSpace = imageTitleSpace;
        self.buttonTitleLabelFontSize = buttonTitleLabelFontSize;
        
        if (self.buttonTitleLabelFontSize == 13.0f) {
            self.buttonTitleLabelHeight = 16.0f;
        } else if (self.buttonTitleLabelFontSize == 15.0f) {
            self.buttonTitleLabelHeight = 18.0f;
        }
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    self.buttonTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.buttonTitleLabel.textColor = UIColorFromRGB(0x333);
    self.buttonTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.buttonTitleLabel.text = self.titleString;
    [self addSubview:self.buttonTitleLabel];
    
    self.buttonImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.buttonImage.image = [UIImage imageNamed:self.imageName];
    
    //[self.btnImage sd_setImageWithURL:[NSURL URLWithString:self.imageURLString] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    [self addSubview:self.buttonImage];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.buttonImage.frame = CGRectMake((self.frame.size.width - self.buttonImageWidth) / 2, 20, self.buttonImageWidth, self.buttonImageWidth);
    self.buttonTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.buttonImage.frame) + self.imageTitleSpace, self.frame.size.width, self.buttonTitleLabelHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
