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
#import "VENHomePageModel.h"
#import "VENWorkAndLuckDetailViewController.h"
#import "VENWebViewController.h"
#import "VENCulturalCircleDetailViewController.h"

@interface VENHomePageViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, VENHomePageHeaderViewScrollViewDelegate>
@property (nonatomic, strong) VENHomePageHeaderViewScrollView *scrollView;
@property (nonatomic, strong) VENHomePageHeaderViewScrollView *scrollView2;

@property (nonatomic, copy) NSArray *bannersArr;
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSArray *infosArr;
@property (nonatomic, copy) NSArray *recMastersArr;
@property (nonatomic, copy) NSArray *serviceIconsArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadHomePageData];
}

- (void)loadHomePageData {
    
    [[VENNetworkTool sharedManager] GET:@"index/homePage" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
//        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            NSArray *bannersArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"data"][@"header"][@"banners"]];
            
            NSString *notice = responseObject[@"data"][@"header"][@"notice"];
            
            NSArray *infosArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"data"][@"infos"]];
            
            NSArray *recMastersArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"data"][@"recMasters"]];
            
            NSArray *serviceIconsArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"data"][@"serviceIcons"]];
            
            self.bannersArr = bannersArr;
            self.notice = notice;
            self.infosArr = infosArr;
            self.recMastersArr = recMastersArr;
            self.serviceIconsArr = serviceIconsArr;
            
            [self setupTabbleView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infosArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENHomePageModel *model = self.infosArr[indexPath.row];
    
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.summary;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.dateLabel.text = model.created_time;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageModel *model = self.infosArr[indexPath.row];
    
    VENCulturalCircleDetailViewController *vc = [[VENCulturalCircleDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.infoID = model.bannersID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 49) style:UITableViewStylePlain];
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
    NSMutableArray *bannersMuArr = [NSMutableArray array];
    for (VENHomePageModel *model in self.bannersArr) {
        [bannersMuArr addObject:model.picture];
    }
    
    NSLog(@"bannersArr - %@", bannersMuArr);
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 375 / 2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = COLOR_THEME;
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    cycleScrollView.imageURLStringsGroup = bannersMuArr;
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
    proclamationLabel.text = self.notice;
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
    
    NSMutableArray *buttonsTitleMuArr = [NSMutableArray array];
    NSMutableArray *buttonsImageMuArr = [NSMutableArray array];
    for (VENHomePageModel *model in self.serviceIconsArr) {
        [buttonsTitleMuArr addObject:model.name];
        [buttonsImageMuArr addObject:model.picture];
    }
    
    for (int i = 0; i < buttonsTitleMuArr.count; i++) {
        VENHomePageHeaderViewButton *btn = [[VENHomePageHeaderViewButton alloc] initWithFrame:CGRectZero setTitle:buttonsTitleMuArr[i] setImageName:buttonsImageMuArr[i] setButtonImageWidth:40.0f setImageTitleSpace:13.0f setButtonTitleLabelFontSize:13.0f];
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
    
    NSMutableArray *buttonsTitleMuArr2 = [NSMutableArray array];
    NSMutableArray *buttonsImageMuArr2 = [NSMutableArray array];
    for (VENHomePageModel *model in self.recMastersArr) {
        [buttonsTitleMuArr2 addObject:model.nickname];
        [buttonsImageMuArr2 addObject:model.avatarUrl];
    }
    
    for (int i = 0; i < buttonsTitleMuArr2.count; i++) {
        VENHomePageHeaderViewButton *btn = [[VENHomePageHeaderViewButton alloc] initWithFrame:CGRectZero setTitle:buttonsTitleMuArr2[i] setImageName:buttonsImageMuArr2[i] setButtonImageWidth:80.0f setImageTitleSpace:15.0f setButtonTitleLabelFontSize:15.0f];
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
    [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    moreButton.layer.cornerRadius = 4;
    moreButton.layer.masksToBounds = YES;
    moreButton.layer.borderWidth = 1;
    moreButton.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
    
    [footerView addSubview:moreButton];
}

- (void)moreButtonClick {
    self.tabBarController.selectedIndex = 2;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    VENHomePageModel *model = self.bannersArr[index];
    
    
    VENWebViewController *vc = [[VENWebViewController alloc] init];
    vc.navTitle = model.title;
    vc.urlStr = model.url;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma DTHomeScrollViewDelegate
- (void)buttonUpInsideWithView:(UIButton *)btn withIndex:(NSInteger)index withView:(VENHomePageHeaderViewScrollView *)view {
    
    if (view == self.scrollView) {
        
        VENHomePageModel *model = self.serviceIconsArr[index];
        
        VENWorkAndLuckViewController *vc = [[VENWorkAndLuckViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.pageID = model.bannersID;
        vc.navigationItem.title = model.name;
        [self.navigationController pushViewController:vc animated:YES];
        
        NSLog(@"%@", model);
        NSLog(@"%@", model.bannersID);
        
    } else if (view == self.scrollView2) {
        
        VENHomePageModel *model = self.recMastersArr[index];
        
        VENWorkAndLuckDetailViewController *vc = [[VENWorkAndLuckDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.masterId = model.bannersID;
        vc.navTitle = @"推荐大师";
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
