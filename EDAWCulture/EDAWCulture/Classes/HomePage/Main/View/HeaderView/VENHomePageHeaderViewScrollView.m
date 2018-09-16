//
//  VENHomePageHeaderViewScrollView.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/4.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageHeaderViewScrollView.h"
#import "VENHomePageHeaderViewPageControl.h"

@interface VENHomePageHeaderViewScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) VENHomePageHeaderViewPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *upScrollView;
@end

@implementation VENHomePageHeaderViewScrollView

- (instancetype)initWithFrame:(CGRect)frame viewsArray:(NSArray *)views maxCount:(NSInteger)count lineMaxCount:(NSInteger)lineCount pageControlIsShow:(BOOL)show {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.views = views;
        self.maxCount = count;
        self.lineMaxCount = lineCount;
        self.pageControlIsShow = show;
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews{
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    
    if (self.pageControlIsShow) {
        _pageControl = [[VENHomePageHeaderViewPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 21.5, self.frame.size.width, 21.5)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = (self.views.count - 1) / self.maxCount + 1;
        _pageControl.currentPageIndicatorTintColor = COLOR_THEME;
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(0xe7e7e7);
        [self addSubview:_pageControl];
    }
    
    _upScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - _pageControl.frame.size.height)];
    _upScrollView.delegate = self;
    _upScrollView.pagingEnabled = YES;
    _upScrollView.showsVerticalScrollIndicator = NO;
    _upScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_upScrollView];
    
    for (int i = 0; i < (self.views.count - 1) / self.maxCount + 1; i++) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, _upScrollView.frame.size.height)];
        NSInteger index = self.maxCount;
        if ((self.views.count - i*8) <self.maxCount) {
            index = (self.views.count - i*self.maxCount);
        }
        for (int j = 0; j <index; j++) {
            int row = j/ self.lineMaxCount;
            int col = j % self.lineMaxCount;
            
//            NSLog(@"row = %d",row);
//            NSLog(@"col = %d",col);
//            NSLog(@"btnHieght = %f",(bgView.frame.size.height / 2));
            
            UIButton *btn = self.views[i*self.maxCount+j];
            btn.frame = CGRectMake(col * (self.frame.size.width / self.lineMaxCount), row * (bgView.frame.size.height / 2), (self.frame.size.width / self.lineMaxCount), (bgView.frame.size.height / 2));
            btn.tag = 100000 + i * self.maxCount + j;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
        }
        [_upScrollView addSubview:bgView];
        
    }
    _upScrollView.contentSize = CGSizeMake(self.frame.size.width * ((self.views.count - 1) / self.maxCount + 1), _upScrollView.frame.size.height);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;  //计算这是第几页
    self.pageControl.currentPage = index;
    
}

- (void)btnAction:(UIButton *)btn {
    NSInteger index = btn.tag - 100000;
    if ([self.delegate respondsToSelector:@selector(buttonUpInsideWithView:withIndex:withView:)]) {
        [self.delegate buttonUpInsideWithView:btn withIndex:index withView:self];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
