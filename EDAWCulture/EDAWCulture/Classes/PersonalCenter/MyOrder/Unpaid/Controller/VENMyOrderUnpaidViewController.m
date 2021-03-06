//
//  VENMyOrderUnpaidViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOrderUnpaidViewController.h"
#import "VENMyOrderTableViewCell.h"
#import "VENHomePageModel.h"
#import "VENConfirmationOfOrderViewController.h"

@interface VENMyOrderUnpaidViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *resultArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMyOrderUnpaidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}

- (void)loadData {
    
    [[VENNetworkTool sharedManager] GET:@"index/getServiceOrders" parameters:@{@"status": @"-1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *resultArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"data"][@"result"]];
            self.resultArr = resultArr;
            
            [self setupTableView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageModel *model = self.resultArr[indexPath.row];
    
    VENMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.dateLabel.text = model.created_time;
    cell.productNameLabel.text = model.name;
    cell.priceLabel.text = model.price;

    if ([[VENUserTypeManager sharedManager] isMaster]) {
        cell.sendMessageButton.hidden = YES;
    } else {
        [cell.sendMessageButton setTitle:@"继续付款" forState:UIControlStateNormal];
        [cell.sendMessageButton addTarget:self action:@selector(continuePaymentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)continuePaymentClick:(id)sender { // 继续付款
    
    VENHomePageModel *model = self.resultArr[[self.tableView indexPathForCell:((VENMyOrderTableViewCell *)[[sender superview]superview])].row];
    
    VENConfirmationOfOrderViewController *vc = [[VENConfirmationOfOrderViewController alloc] init];
    vc.model = model;
    vc.name = model.master_nickname;
    vc.imageURL = model.master_avatar_url;
    vc.level = model.master_level_name;
    vc.school = model.master_study;
    vc.isContinuePayment = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 42 - statusNavHeight - 10) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VENMyOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    _tableView = tableView;
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

