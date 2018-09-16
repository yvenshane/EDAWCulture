//
//  VENCulturalCircleApprenticeTableViewCell.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/8.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCulturalCircleApprenticeTableViewCell.h"

@interface VENCulturalCircleApprenticeTableViewCell ()
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImage *tempImage;

@end

@implementation VENCulturalCircleApprenticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍";
        contentLabel.textColor = UIColorFromRGB(0x333333);
        contentLabel.font = [UIFont systemFontOfSize:15.0f];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        
        UIImageView *contentImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:contentImageView];
        
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
    
    // 文字
    CGFloat height = [self label:self.contentLabel setHeightToWidth:kMainScreenWidth - 30];
    self.contentLabel.frame = CGRectMake(15, 20, kMainScreenWidth - 30, height);
    
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
    
    self.contentImageView.frame = CGRectMake(30, 20 + height + 20, kMainScreenWidth - 60, imgHeight / imgWidth * (kMainScreenWidth - 30));
    self.contentImageView.image = weakSelf.tempImage;
    
    self.maxHeight =  20 + height + 20 + imgHeight / imgWidth * (kMainScreenWidth - 30) + 25;
}

- (CGFloat)label:(UILabel *)label setHeightToWidth:(CGFloat)width {
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

@end
