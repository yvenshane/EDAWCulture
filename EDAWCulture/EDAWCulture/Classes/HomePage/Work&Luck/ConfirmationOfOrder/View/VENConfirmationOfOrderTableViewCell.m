//
//  VENConfirmationOfOrderTableViewCell.m
//  EDAWCulture
//
//  Created by YVEN on 2018/10/25.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENConfirmationOfOrderTableViewCell.h"

@implementation VENConfirmationOfOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftButton.layer.cornerRadius = 4.0f;
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.borderWidth = 0.0f;
    self.leftButton.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    
    self.rightButton.layer.cornerRadius = 4.0f;
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.borderWidth = 1.0f;
    self.rightButton.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
