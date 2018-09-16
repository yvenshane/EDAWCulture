//
//  VENMyBalanceWithdrawPageViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/9.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyBalanceWithdrawPageViewController.h"
#import "VENMyBalanceWithdrawSuccessPageViewController.h"

@interface VENMyBalanceWithdrawPageViewController ()

@end

@implementation VENMyBalanceWithdrawPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    self.navigationItem.title = @"申请提现";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupLeftBtn];
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, kMainScreenHeight - statusNavHeight - 10) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
//    [tableView registerNib:[UINib nibWithNibName:@"VENMyBalanceTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth,  46 + 18 + 20 + 43 + 31)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kMainScreenWidth - 30, 18)];
    titleLabel.text = @"输入申请提现金额";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [headerView addSubview:titleLabel];
    
    UILabel *tokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 46 + 18 + 20, 30, 43)];
    tokenLabel.text = @"¥";
    tokenLabel.textColor = UIColorFromRGB(0x333333);
    tokenLabel.font = [UIFont systemFontOfSize:36.0f];
    [headerView addSubview:tokenLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + 20 + 30, 46 + 18 + 20, kMainScreenWidth - 15 - 20 - 30 - 15, 43)];
    textField.placeholder = @"0.00";
    textField.font = [UIFont systemFontOfSize:36.0f];
    textField.textColor = UIColorFromRGB(0x333333);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [headerView addSubview:textField];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 59)];
//    footerView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = footerView;
    
    // 申请提现
    UIButton *withdrawButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth - 30, 49)];
    withdrawButton.backgroundColor = COLOR_THEME;
    [withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
    withdrawButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    withdrawButton.layer.cornerRadius = 4.0f;
    withdrawButton.layer.masksToBounds = YES;
    [withdrawButton addTarget:self action:@selector(withdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:withdrawButton];
}

- (void)withdrawButtonClick {
    VENMyBalanceWithdrawSuccessPageViewController *vc = [[VENMyBalanceWithdrawSuccessPageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupLeftBtn {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"top_back01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setupLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)setupLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
