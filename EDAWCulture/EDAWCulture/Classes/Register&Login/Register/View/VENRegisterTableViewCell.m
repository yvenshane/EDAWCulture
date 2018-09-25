//
//  VENRegisterTableViewCell.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegisterTableViewCell.h"

@implementation VENRegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.leftTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.leftTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
