//
//  VENRegisterTableViewCell.h
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENRegisterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTextFieldLayoutConstraint;
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end
