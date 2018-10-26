//
//  VENConfirmationOfOrderViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/10/25.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENConfirmationOfOrderViewController.h"
#import "VENConfirmationOfOrderTableViewCell.h"
#import "VENHomePageModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"

@interface VENConfirmationOfOrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) BOOL payType;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENConfirmationOfOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"确认订单";
    
    [self setupTableView];
    [self setupBottomBar];
    [self setupLeftBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENConfirmationOfOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentLabel.hidden = indexPath.row == 2 ? YES : NO;
    cell.leftButton.hidden = indexPath.row == 2 ? NO : YES;
    cell.rightButton.hidden = indexPath.row == 2 ? NO : YES;
    
    cell.titleLabel.text = @[@"服务", @"价格", @"支付方式"][indexPath.row];
    
    if (indexPath.row == 0) {
        cell.contentLabel.text = self.model.name;
    } else if (indexPath.row == 1) {
        cell.contentLabel.text = self.model.price;
    }
    
    [cell.leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton = cell.leftButton;
    self.rightButton = cell.rightButton;
    
    return cell;
}

- (void)buttonClick:(UIButton *)button {
    
    self.rightButton.layer.borderWidth = button == self.leftButton ? 1.0f : 0;
    self.rightButton.backgroundColor = button == self.leftButton ? [UIColor whiteColor] : COLOR_THEME;
    [self.rightButton setTitleColor:button == self.leftButton ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    
    self.leftButton.layer.borderWidth = button == self.rightButton ? 1.0f : 0;
    self.leftButton.backgroundColor = button == self.rightButton ? [UIColor whiteColor] : COLOR_THEME;
    [self.leftButton setTitleColor:button == self.rightButton ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    
    self.payType = !self.payType;
    
    NSLog(@"%d", self.payType);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 44 - statusNavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorMake(245, 248, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENConfirmationOfOrderTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10 + 16 + 60 + 16 + 10)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    lineView.backgroundColor = UIColorMake(247, 245, 248);
    [headerView addSubview:lineView];
    
    // 头像
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 26, 60, 60)];
    iconImageView.layer.cornerRadius = 30.0f;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:nil];
    [headerView addSubview:iconImageView];
    
    // 名称
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + 60 + 16, 26, kMainScreenWidth - 16 - 60 - 16 - 16, 20)];
    titleLabel.text = self.name;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [headerView addSubview:titleLabel];
    
    // 等级
    UILabel *leverLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + 60 + 16, 26 + 29, kMainScreenWidth - 16 - 60 - 16 - 16, 15)];
    leverLabel.text = [NSString stringWithFormat:@"等级：%@", self.level];
    leverLabel.textColor = UIColorFromRGB(0x666666);
    leverLabel.font = [UIFont systemFontOfSize:12.0f];
    [headerView addSubview:leverLabel];
    
    // 学派
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + 60 + 16, 26 + 29 + 15 + 3, kMainScreenWidth - 16 - 60 - 16 - 16, 15)];
    schoolLabel.text = [NSString stringWithFormat:@"学派：%@", self.school];
    schoolLabel.textColor = UIColorFromRGB(0x666666);
    schoolLabel.font = [UIFont systemFontOfSize:12.0f];
    [headerView addSubview:schoolLabel];
    
    // 分割线2
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + 16 + 60 + 16, kMainScreenWidth, 10)];
    lineView2.backgroundColor = UIColorMake(247, 245, 248);
    [headerView addSubview:lineView2];
}

- (void)setupBottomBar {
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - statusNavHeight - 44, kMainScreenWidth, 44)];
    bottomBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBar];
    
    // 应付金额
    UILabel *leverLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 44 / 2 - 18 / 2, 80, 18)];
    leverLabel.text = @"应付金额：";
    leverLabel.font = [UIFont systemFontOfSize:15.0f];
    [bottomBar addSubview:leverLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 44 / 2 - 18 / 2, kMainScreenWidth - kMainScreenWidth / 3 - 80 - 16 - 8, 18)];
    priceLabel.text = self.model.price;
    priceLabel.textColor = UIColorFromRGB(0xff9f28);
    priceLabel.font = [UIFont systemFontOfSize:15.0f];
    [bottomBar addSubview:priceLabel];
    
    // 立即购买
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2, 0, kMainScreenWidth / 3, 44)];
    [payButton setTitle:@"立即购买" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    payButton.backgroundColor = COLOR_THEME;
    [payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:payButton];
}

- (void)payButtonClick {
    
    NSDictionary *parameters = @{@"serviceId": self.model.bannersID,
                                 @"pay_channel": self.payType ? @"alipay_app" : @"wxpay_app"};
    
    [[VENNetworkTool sharedManager] POST:@"index/serviceOrder" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            if (self.payType) {
                [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"orderString"] fromScheme:@"alipay" callback:^(NSDictionary *resultDic) {
                    
                    NSLog(@"reslut = %@",resultDic);
                    
                    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) { // 支付成功
                        
                    }
                }];
            } else {
                PayReq *req = [[PayReq alloc] init];
                req.partnerId = [responseObject[@"data"][@"orderString"] objectForKey:@"partnerid"];
                req.prepayId = [responseObject[@"data"][@"orderString"] objectForKey:@"prepayid"];
                req.nonceStr = [responseObject[@"data"][@"orderString"] objectForKey:@"noncestr"];
                req.timeStamp = [[responseObject[@"data"][@"orderString"] objectForKey:@"timeStamp"] intValue];
                req.package = [responseObject[@"data"][@"orderString"] objectForKey:@"package"];
                req.sign = [responseObject[@"data"][@"orderString"] objectForKey:@"sign"];
                [WXApi sendReq:req];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)setupLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupLeftBtn {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"top_back01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setupLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
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
