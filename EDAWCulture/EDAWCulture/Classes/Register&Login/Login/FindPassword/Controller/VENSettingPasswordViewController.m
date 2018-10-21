//
//  VENSettingPasswordViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingPasswordViewController.h"
#import "VENRegisterTableViewCell.h"

@interface VENSettingPasswordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENSettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTabbleView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.leftTextField.placeholder = indexPath.row == 0 ? @"设置新密码" : @"确认新密码";
    cell.leftTextField.userInteractionEnabled = YES;
    cell.leftTextField.secureTextEntry = YES;
    cell.rightButton.hidden = YES;
    cell.rightLabel.hidden = YES;
    cell.rightImageView.hidden = YES;
    cell.leftTextFieldLayoutConstraint.constant = 15.0f;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, kMainScreenWidth, kMainScreenHeight - 74) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VENRegisterTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 59)];
    footerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.tableFooterView = footerView;
    
    // 提交
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth - 30, 49)];
    submitButton.backgroundColor = COLOR_THEME;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    submitButton.layer.cornerRadius = 4.0f;
    submitButton.layer.masksToBounds = YES;
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    
    self.tableView = tableView;
}

- (void)submitButtonClick {
    
    VENRegisterTableViewCell *passwordCell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    VENRegisterTableViewCell *password2Cell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:passwordCell.leftTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入新密码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:password2Cell.leftTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请确认新密码"];
        return;
    }
    
    NSDictionary *parameters = @{@"phone": self.phone,
                                 @"smsCode": self.smsCode,
                                 @"password": passwordCell.leftTextField.text,
                                 @"password2": password2Cell.leftTextField.text};
    
    [[VENNetworkTool sharedManager] POST:@"index/userForgot" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)leftBarButtonItemClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
