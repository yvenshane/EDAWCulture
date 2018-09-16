//
//  VENHomePageViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/8/31.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageViewController.h"
#import "VENHomePageHeaderViewScrollView.h"
#import "VENHomePageHeaderViewButton.h"
#import "VENHomePageTableViewCell.h"
#import "VENWorkAndLuckViewController.h"

@interface VENHomePageViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, VENHomePageHeaderViewScrollViewDelegate>
@property (nonatomic, strong) VENHomePageHeaderViewScrollView *scrollView;
@property (nonatomic, strong) VENHomePageHeaderViewScrollView *scrollView2;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTabbleView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kMainScreenWidth, kMainScreenHeight + 20) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    // 整个 HeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth,  375 / 2 + 98 / 2 + 10 + 210.5f + 10 + 98 / 2 + 284 + 10 + 98 / 2)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    // 广告
    NSArray *imagesURLStrings = @[@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 375 / 2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = COLOR_THEME;
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    [headerView addSubview:cycleScrollView];
    
    // 公告
    UIView *proclamationView = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2, kMainScreenWidth, 98 / 2)];
    proclamationView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:proclamationView];
    
    UIImageView *proclamationImageView = [[UIImageView alloc] init];
    proclamationImageView.image = [UIImage imageNamed:@"notice"];
    [headerView addSubview:proclamationImageView];
    
    [proclamationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(proclamationView.mas_centerY);
        make.width.mas_equalTo(70 / 2);
        make.height.mas_equalTo(34 / 2);
    }];
    
    UILabel *proclamationLabel = [[UILabel alloc] init];
    proclamationLabel.text = @"平台版本升级，敬请期待…";
    proclamationLabel.textColor = UIColorFromRGB(0x333);
    proclamationLabel.font = [UIFont systemFontOfSize:15.0f];
    [headerView addSubview:proclamationLabel];
    
    [proclamationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(proclamationImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(proclamationView.mas_centerY);
    }];
    
    // 分割线
    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2, kMainScreenWidth, 10)];
    splitLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView];
    
    // 图文
    NSMutableArray *views = [NSMutableArray array];
    NSArray *titles = @[@"婚恋感情", @"事业财运", @"八字合婚", @"命运详批", @"塔罗占星", @"流年运势", @"宝宝起名", @"公司起名", @"婚恋感情", @"事业财运", @"八字合婚", @"命运详批", @"塔罗占星", @"流年运势", @"宝宝起名", @"公司起名"];
    
    for (int i = 0; i < 16; i++) {
        VENHomePageHeaderViewButton *btn = [[VENHomePageHeaderViewButton alloc] initWithFrame:CGRectZero setTitle:titles[i] setImageName:[@"class_0" stringByAppendingString:[NSString stringWithFormat:@"%d", i + 1]] setButtonImageWidth:40.0f setImageTitleSpace:13.0f setButtonTitleLabelFontSize:13.0f];
        [views addObject:btn];
    }
    
    self.scrollView = [[VENHomePageHeaderViewScrollView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10, kMainScreenWidth, 210.5f) viewsArray:views maxCount:8 lineMaxCount:4 pageControlIsShow:YES];
    self.scrollView.delegate = self;
    [headerView addSubview:self.scrollView];
    
    // 分割线
    UIView *splitLineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10 + 210.5f, kMainScreenWidth, 10)];
    splitLineView2.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView2];
    
    // 推荐大师
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10 + 210.5f + 10, kMainScreenWidth, 98 / 2)];
    titleView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleView];
    
    UIImageView *titleViewImageView = [[UIImageView alloc] init];
    titleViewImageView.backgroundColor = COLOR_THEME;
    [headerView addSubview:titleViewImageView];
    
    [titleViewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.width.mas_equalTo(5 / 2);
        make.height.mas_equalTo(35 / 2);
    }];
    
    UILabel *titleViewLabel = [[UILabel alloc] init];
    titleViewLabel.text = @"推荐大师";
    titleViewLabel.textColor = UIColorFromRGB(0x333);
    titleViewLabel.font = [UIFont systemFontOfSize:17.0f];
    [headerView addSubview:titleViewLabel];
    
    [titleViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleViewImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    
    // 线
    UIView *splitLineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10 + 210.5f +  + 10 + 98 / 2 - 1, kMainScreenWidth, 1)];
    splitLineView3.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView3];
    
    // 图文
    NSMutableArray *views2 = [NSMutableArray array];
    NSArray *titles2 = @[@"大师1", @"大师2", @"大师3", @"大师4", @"大师5", @"大师6"];
    
    for (int i = 0; i < 6; i++) {
        VENHomePageHeaderViewButton *btn = [[VENHomePageHeaderViewButton alloc] initWithFrame:CGRectZero setTitle:titles2[i] setImageName:[@"class_0" stringByAppendingString:[NSString stringWithFormat:@"%d", i + 1]] setButtonImageWidth:80.0f setImageTitleSpace:15.0f setButtonTitleLabelFontSize:15.0f];
        [views2 addObject:btn];
    }
    
    self.scrollView2 = [[VENHomePageHeaderViewScrollView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10 + 210.5f + 10 + 98 / 2, kMainScreenWidth, 266) viewsArray:views2 maxCount:6 lineMaxCount:3 pageControlIsShow:NO];
    self.scrollView2.delegate = self;
    [headerView addSubview:self.scrollView2];
    
    // 分割线
    UIView *splitLineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10 + 210.5f + 10 + 98 / 2 + 284, kMainScreenWidth, 10)];
    splitLineView4.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView4];
    
    // 平台资讯
    UIView *titleView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10 + 210.5f + 10 + 98 / 2 + 284 + 10, kMainScreenWidth, 98 / 2)];
    titleView2.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleView2];
    
    UIImageView *titleViewImageView2 = [[UIImageView alloc] init];
    titleViewImageView2.backgroundColor = COLOR_THEME;
    [headerView addSubview:titleViewImageView2];
    
    [titleViewImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(titleView2.mas_centerY);
        make.width.mas_equalTo(5 / 2);
        make.height.mas_equalTo(35 / 2);
    }];
    
    UILabel *titleViewLabel2 = [[UILabel alloc] init];
    titleViewLabel2.text = @"平台资讯";
    titleViewLabel2.textColor = UIColorFromRGB(0x333);
    titleViewLabel2.font = [UIFont systemFontOfSize:17.0f];
    [headerView addSubview:titleViewLabel2];
    
    [titleViewLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleViewImageView2.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(titleView2.mas_centerY);
    }];
    
    // 线
    UIView *splitLineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 375 / 2 + 98 / 2 + 10 + 210.5f + 10 + 98 / 2 + 284 + 10 + 98 / 2 - 1, kMainScreenWidth, 1)];
    splitLineView5.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView5];
    
    // FooterView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = footerView;
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, kMainScreenWidth - 30, 44)];
    [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    moreButton.layer.cornerRadius = 4;
    moreButton.layer.masksToBounds = YES;
    moreButton.layer.borderWidth = 1;
    moreButton.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
    
    [footerView addSubview:moreButton];
}

#pragma DTHomeScrollViewDelegate
- (void)buttonUpInsideWithView:(UIButton *)btn withIndex:(NSInteger)index withView:(VENHomePageHeaderViewScrollView *)view{
    
    if (index == 1) {
        VENWorkAndLuckViewController *vc = [[VENWorkAndLuckViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
