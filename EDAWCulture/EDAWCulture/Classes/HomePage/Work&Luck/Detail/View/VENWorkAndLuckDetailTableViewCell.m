//
//  VENWorkAndLuckDetailTableViewCell.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/6.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENWorkAndLuckDetailTableViewCell.h"

@interface VENWorkAndLuckDetailTableViewCell ()
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImage *tempImage;

@end

@implementation VENWorkAndLuckDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *contentImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:contentImageView];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"介介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍";
        contentLabel.textColor = UIColorFromRGB(0x333333);
        contentLabel.font = [UIFont systemFontOfSize:13.0f];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        
        self.contentImageView = contentImageView;
        self.contentLabel = contentLabel;
    }
    
    return self;
}

//- (void)setModel:(VENFeedbackDetailModel *)model {
//    _model = model;
//
//
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    
    // 图片
    NSString *photoURL = @"http://t2.hddhhn.com/uploads/tu/201610/198/scx30045vxd.jpg";
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager diskImageExistsForURL:[NSURL URLWithString:photoURL] completion:^(BOOL isInCache) {
        
        if (isInCache) {
            weakSelf.tempImage = [[manager imageCache] imageFromDiskCacheForKey:[NSURL URLWithString:photoURL].absoluteString];
        } else {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
            weakSelf.tempImage = [UIImage imageWithData:data];
            [[SDWebImageManager sharedManager]saveImageToCache:weakSelf.tempImage forURL:[NSURL URLWithString:photoURL]];
        }
    }];
    
    
    
    CGFloat imgWidth = 0.f;
    CGFloat imgHeight = 0.f;
    
    imgWidth = _tempImage ? weakSelf.tempImage.size.width : 400;
    imgHeight = _tempImage ? weakSelf.tempImage.size.height : 300;

    self.contentImageView.frame = CGRectMake(15, 20, kMainScreenWidth - 30, imgHeight / imgWidth * (kMainScreenWidth - 30));
    self.contentImageView.image = self.tempImage;
    
    CGFloat height = [self label:self.contentLabel setHeightToWidth:kMainScreenWidth - 30];
    self.contentLabel.frame = CGRectMake(15, imgHeight / imgWidth * (kMainScreenWidth - 30) + 20 + 20, kMainScreenWidth - 30, height);
    
    
    self.maxHeight = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 20;
}

- (CGFloat)label:(UILabel *)label setHeightToWidth:(CGFloat)width {
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

@end
