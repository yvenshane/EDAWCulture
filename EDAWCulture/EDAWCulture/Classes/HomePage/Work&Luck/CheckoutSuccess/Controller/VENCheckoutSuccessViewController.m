//
//  VENCheckoutSuccessViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/7.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCheckoutSuccessViewController.h"

@interface VENCheckoutSuccessViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENCheckoutSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"下单成功";
    
    [self setupTableView];
    [self setupBackButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.dataSourceMuArr[0][@"title"][indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    
    cell.detailTextLabel.textColor = UIColorFromRGB(0x333333);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.orderDict[@"service_name"];
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.orderDict[@"amount"]];
    } else {
        cell.detailTextLabel.text = self.orderDict[@"created_time"];
    }
    
    return cell;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 30;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    //    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 335)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"ic_pay_success"];
    [headerView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(255 / 2 - statusNavHeight);
        make.width.mas_equalTo(240 / 2);
        make.height.mas_equalTo(194 / 2);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"支付成功";
    label.textColor = UIColorFromRGB(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:21.0f];
    [headerView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(25);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(26);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"恭喜您，下单成功，\n请到会员中心>我的订单中去联系大师";
    [label2 setValue:@(20) forKey:@"lineSpacing"];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = UIColorFromRGB(0x333333);
    label2.font = [UIFont systemFontOfSize:15.0f];
    [headerView addSubview:label2];
    
    CGFloat height = [self label:label2 setHeightToWidth:kMainScreenWidth];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(28);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(height);
    }];
    
    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 255 / 2 - statusNavHeight + 194 / 2 + 25 + 26 + 28 + height + 35, kMainScreenWidth - 30, 1)];
    splitLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 150)];
    footerView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = footerView;
    
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.backgroundColor = COLOR_THEME;
    [leftButton setTitle:@"继续下单" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftButton.layer.cornerRadius = 4;
    leftButton.layer.masksToBounds = YES;
    
    [footerView addSubview:leftButton];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(72);
        make.centerX.mas_equalTo(headerView.mas_centerX).offset(80);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.backgroundColor = UIColorFromRGB(0xffb136);
    [rightButton setTitle:@"立即咨询" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightButton.layer.cornerRadius = 4;
    rightButton.layer.masksToBounds = YES;
    [footerView addSubview:rightButton];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(72);
        make.centerX.mas_equalTo(headerView.mas_centerX).offset(-80);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(44);
    }];
}

- (void)leftButtonClick:(id)sender { // 继续下单
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CONTINUE_THE_ORDER" object:nil];
}

- (void)rightButtonClick:(id)sender { // 立即咨询
    
}

- (void)setupBackButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"top_back01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)backButtonClick {
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
}

- (CGFloat)label:(UILabel *)label setHeightToWidth:(CGFloat)width {
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

- (NSMutableArray *)dataSourceMuArr {
    if (_dataSourceMuArr == nil) {
        _dataSourceMuArr = [[NSMutableArray alloc] initWithArray:@[@{@"title" : @[@"项目", @"金额", @"下单时间"]}]];
    }
    return _dataSourceMuArr;
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
