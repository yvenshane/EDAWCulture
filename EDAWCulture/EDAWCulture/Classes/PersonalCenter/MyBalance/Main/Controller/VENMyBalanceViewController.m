//
//  VENMyBalanceViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/9.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyBalanceViewController.h"
#import "VENMyBalanceTableViewCell.h"
#import "VENMyBalanceWithdrawPageViewController.h"

@interface VENMyBalanceViewController () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMyBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTabbleView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMyBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 73;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kMainScreenWidth, kMainScreenHeight + statusNavHeight - 44) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENMyBalanceTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    // 整个 HeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 306)];
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
    
    // 金额
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, kMainScreenWidth, 43)];
    priceLabel.text = @"9999.00";
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont systemFontOfSize:36.0f];
    [headerView addSubview:priceLabel];
    
    UILabel *myPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 82 + 43 + 17, kMainScreenWidth, 18)];
    myPriceLabel.text = @"我的余额(元)";
    myPriceLabel.textAlignment = NSTextAlignmentCenter;
    myPriceLabel.textColor = [UIColor whiteColor];
    myPriceLabel.font = [UIFont systemFontOfSize:15.0f];
    [headerView addSubview:myPriceLabel];
    
    // 申请提现
    UIButton *withdrawButton = [[UIButton alloc] init];
    withdrawButton.backgroundColor = UIColorFromRGB(0xffb136);
    [withdrawButton setTitle:@"申请提现" forState:UIControlStateNormal];
    withdrawButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    withdrawButton.layer.cornerRadius = 4.0f;
    withdrawButton.layer.masksToBounds = YES;
    [withdrawButton addTarget:self action:@selector(withdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:withdrawButton];
    
    [withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myPriceLabel.mas_bottom).offset(22.5f);
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(44);
    }];
    
    // 提现记录
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview: backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(withdrawButton.mas_bottom).offset(50);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"提现记录";
    label.textColor = UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:13.0f];
    [backgroundView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(backgroundView.mas_centerY);
    }];
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)withdrawButtonClick {
    VENMyBalanceWithdrawPageViewController *vc = [[VENMyBalanceWithdrawPageViewController alloc] init];
    [self.navigationController setNavigationBarHidden:NO animated:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [super viewWillDisappear:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillAppear:animated];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [super viewWillDisappear:animated];
//}

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
