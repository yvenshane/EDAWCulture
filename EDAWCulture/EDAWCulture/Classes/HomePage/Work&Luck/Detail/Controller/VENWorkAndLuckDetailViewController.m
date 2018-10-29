//
//  VENWorkAndLuckDetailViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/6.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENWorkAndLuckDetailViewController.h"
#import "VENWorkAndLuckDetailPopupView.h"
#import "VENCheckoutSuccessViewController.h"
#import "VENHomePageModel.h"
#import "VENConfirmationOfOrderViewController.h"

@interface VENWorkAndLuckDetailViewController () <UITableViewDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) VENWorkAndLuckDetailPopupView *popupView;
@property (nonatomic, copy) NSDictionary *dataSourceDict;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) VENHomePageModel *choiceModel;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *imageURL;

@end

@implementation VENWorkAndLuckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueTheOrder) name:@"CONTINUE_THE_ORDER" object:nil];
}

- (void)continueTheOrder {
    [self purchaseButtonClick]; // 购买服务
}

- (void)loadData {
    
    NSDictionary *parameters = @{@"id": self.masterId};
    
    [[VENNetworkTool sharedManager] GET:@"index/master" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            NSDictionary *dataSourceDict = responseObject[@"data"];
            self.dataSourceDict = dataSourceDict;
            
            [self setupTableView];
            [self setupBottomToolBar];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kMainScreenWidth, kMainScreenHeight - 24) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
//    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    // 整个 HeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80 + 73 + 23 + 22 + 32 + 8 + 18 + 10 + 14 + 28 + 10 + 50)];
    headerView.backgroundColor = UIColorFromRGB(0x5b25e6);
    tableView.tableHeaderView = headerView;
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
//    navView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:navView];
    
    // 返回按钮
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"top_back02"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(navView.mas_centerY);
        make.width.height.mas_equalTo(24);
    }];
    
    // title
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = self.navTitle;
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.font = [UIFont systemFontOfSize:17.0f];
    [navView addSubview:navTitleLabel];
    
    [navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navView.mas_centerY);
        make.centerX.mas_equalTo(navView.mas_centerX);
    }];
    
    // model
    VENHomePageModel *model = [VENHomePageModel yy_modelWithJSON:self.dataSourceDict];
    
    // 头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:nil];
    self.imageURL = model.avatarUrl;
    iconImageView.layer.cornerRadius = 146 / 4;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImageView.layer.borderWidth = 1.5;
    [headerView addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.width.height.mas_equalTo(146 / 2);
    }];
    
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = model.nickname;
    self.name = model.nickname;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:18.0f];
    [headerView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80 + 73 + 23);
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.height.mas_equalTo(22);
    }];
    
    // bottomView
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 + 73 + 23 + 22 + 32, kMainScreenWidth, 8 + 18 + 10 + 14 + 28)];
    [headerView addSubview:bottomView];
    
    // bottomLeftView
    UIView *bottomLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 2, 8 + 18 + 10 + 14 + 28)];
    [bottomView addSubview:bottomLeftView];
    
    // 线
    UIView *splitLineView2 = [[UIView alloc] init];
    splitLineView2.backgroundColor = UIColorFromRGB(0x7036ff);
    [bottomView addSubview:splitLineView2];
    
    [splitLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
    }];
    
    VENHomePageModel *model2 = [VENHomePageModel yy_modelWithJSON:self.dataSourceDict[@"levelInfo"]];
    
    // bottomRightView
    UIView *bottomRightView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 0, kMainScreenWidth / 2, 8 + 18 + 10 + 14 + 28)];
    [bottomView addSubview:bottomRightView];
    
    // level
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.text = model2.name;
    self.level = model2.name;
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.font = [UIFont systemFontOfSize:15.0f];
    [bottomLeftView addSubview:levelLabel];
    
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(bottomLeftView.mas_centerX);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *levelLabel2 = [[UILabel alloc] init];
    levelLabel2.text = @"等级";
    levelLabel2.textColor = UIColorFromRGB(0xcbb7ff);
    levelLabel2.font = [UIFont systemFontOfSize:11.0f];
    [bottomLeftView addSubview:levelLabel2];
    
    [levelLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(levelLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(bottomLeftView.mas_centerX);
        make.height.mas_equalTo(14);
    }];
    
    // factions
    UILabel *factionsLabel = [[UILabel alloc] init];
    factionsLabel.text = model.study;
    self.school = model.study;
    factionsLabel.textColor = [UIColor whiteColor];
    factionsLabel.font = [UIFont systemFontOfSize:15.0f];
    [bottomRightView addSubview:factionsLabel];
    
    [factionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(bottomRightView.mas_centerX);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *factionsLabel2 = [[UILabel alloc] init];
    factionsLabel2.text = @"学派";
    factionsLabel2.textColor = UIColorFromRGB(0xcbb7ff);
    factionsLabel2.font = [UIFont systemFontOfSize:11.0f];
    [bottomLeftView addSubview:factionsLabel2];
    
    [factionsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(factionsLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(bottomRightView.mas_centerX);
        make.height.mas_equalTo(14);
    }];
    
    // 分割线
    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 + 73 + 23 + 22 + 32 + 8 + 18 + 10 + 14 + 28, kMainScreenWidth, 10)];
    splitLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 + 73 + 23 + 22 + 32 + 8 + 18 + 10 + 14 + 28 + 10, kMainScreenWidth, 98 / 2)];
    titleView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleView];
    
    // 个人简介
    UIImageView *titleViewImageView = [[UIImageView alloc] init];
    titleViewImageView.backgroundColor = COLOR_THEME;
    [titleView addSubview:titleViewImageView];

    [titleViewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.width.mas_equalTo(5 / 2);
        make.height.mas_equalTo(35 / 2);
    }];

    UILabel *titleViewLabel = [[UILabel alloc] init];
    titleViewLabel.text = @"个人简介";
    titleViewLabel.textColor = UIColorFromRGB(0x333);
    titleViewLabel.font = [UIFont systemFontOfSize:17.0f];
    [titleView addSubview:titleViewLabel];

    [titleViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleViewImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    
    // 线
    UIView *splitLineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 80 + 73 + 23 + 22 + 32 + 8 + 18 + 10 + 14 + 28 + 10 + 49, kMainScreenWidth, 1)];
    splitLineView3.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView3];
    
    // webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80 + 73 + 23 + 22 + 32 + 8 + 18 + 10 + 14 + 28 + 10 + 49 + 1, kMainScreenWidth, kMainScreenHeight - 45 - (80 + 73 + 23 + 22 + 32 + 8 + 18 + 10 + 14 + 28 + 10 + 49 + 1))];
    webView.delegate = self;
    webView.scrollView.scrollEnabled = NO;
    [webView loadHTMLString:model.content baseURL:nil];
    [headerView addSubview:webView];

    self.tableView = tableView;
    self.iconImageView = iconImageView;
    self.tableHeaderView = headerView;
    self.webView = webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [webView.scrollView contentSize].height;

    NSLog(@"%f", webViewHeight);

    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;

    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kMainScreenWidth, 80 + 73 + 23 + 22 + 32 + 8 + 18 + 10 + 14 + 28 + 10 + 49 + 1 + webViewHeight);
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)setupBottomToolBar {
    UIView *bottomToolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 45, kMainScreenWidth, 45)];
    [self.view addSubview:bottomToolBarView];
    
    // 线
    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    splitLineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [bottomToolBarView addSubview:splitLineView];
    
    // model
    VENHomePageModel *model = [VENHomePageModel yy_modelWithJSON:self.dataSourceDict];
    
    // 关注
    UIButton *fucosButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, kMainScreenWidth / 3, 44)];
    
    if ([model.isSubscribe integerValue] == 1) {
        fucosButton.selected = YES;
    } else if ([model.isSubscribe integerValue] == 2) {
        fucosButton.selected = NO;
    }
    
    [fucosButton addTarget:self action:@selector(fucosButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBarView addSubview:fucosButton];
    
//    isSubscribe
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:fucosButton.selected == YES ? @"detail_focus_on1" : @"detail_focus_nor"];
    [fucosButton addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5 / 3);
        make.centerX.mas_equalTo(fucosButton.mas_centerX);
        make.width.height.mas_equalTo(24);
    }];
    
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.text = @"关注";
    iconLabel.font = [UIFont systemFontOfSize:12.0f];
    iconLabel.textColor = UIColorFromRGB(0x999999);
    [fucosButton addSubview:iconLabel];
    
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5 / 3 + 24 + 5 / 3);
        make.centerX.mas_equalTo(fucosButton.mas_centerX);
    }];

    UIButton *purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, 1, kMainScreenWidth - kMainScreenWidth / 3, 44)];
    [purchaseButton setTitle:@"购买服务" forState:UIControlStateNormal];
    purchaseButton.backgroundColor = COLOR_THEME;
    [purchaseButton addTarget:self action:@selector(purchaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBarView addSubview:purchaseButton];
    
    self.iconImageView = iconImageView;
}

- (void)fucosButtonClick:(UIButton *)button { // 关注
    
    button.selected = !button.selected;
    
    NSDictionary *parameters = @{@"masterId": self.masterId};
    
    [[VENNetworkTool sharedManager] POST:button.selected == NO ? @"index/userUnsubscribe" : @"index/userSubscribe" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            self.iconImageView.image = [UIImage imageNamed:button.selected == YES ? @"detail_focus_on1" : @"detail_focus_nor"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)purchaseButtonClick { // 购买服务
    [self backgroundView];
    [self popupView];
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        [self.view addSubview:_backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(tapClick)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (VENWorkAndLuckDetailPopupView *)popupView {
    if (_popupView == nil) {
        _popupView = [[VENWorkAndLuckDetailPopupView alloc] init];
        _popupView.dataSourceArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:self.dataSourceDict[@"services"]];
        
        __weak typeof(self) weakSelf = self;
        _popupView.block = ^(VENHomePageModel *model) {
            weakSelf.choiceModel = model;
        };

        _popupView.transform = CGAffineTransformMakeTranslation(0.01, kMainScreenHeight);
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.popupView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
            weakSelf.popupView.backgroundColor = [UIColor whiteColor];
            weakSelf.popupView.frame = CGRectMake(0, kMainScreenHeight - 294, kMainScreenWidth, 294);
        }];

        _popupView.backgroundColor = [UIColor whiteColor];
        
        [_popupView.purchaseButton addTarget:self action:@selector(popupViewPurchaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_popupView];
    }
    return _popupView;
}

- (void)popupViewPurchaseButtonClick {
    
    if (self.choiceModel) {
        VENConfirmationOfOrderViewController *vc = [[VENConfirmationOfOrderViewController alloc] init];
        vc.model = self.choiceModel;
        vc.name = self.name;
        vc.imageURL = self.imageURL;
        vc.level = self.level;
        vc.school = self.school;
        [self.navigationController pushViewController:vc animated:YES];
        
        [self tapClick];
    }
}

- (void)tapClick {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.popupView.transform = CGAffineTransformMakeTranslation(0.01, kMainScreenHeight);
        [self.popupView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        weakSelf.backgroundView = nil;
        weakSelf.popupView = nil;
        weakSelf.choiceModel = nil;
    }];
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
