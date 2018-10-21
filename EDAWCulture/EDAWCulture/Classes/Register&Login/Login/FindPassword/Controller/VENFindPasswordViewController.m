//
//  VENFindPasswordViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENFindPasswordViewController.h"
#import "VENRegisterTableViewCell.h"
#import "VENSettingPasswordViewController.h"

@interface VENFindPasswordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) NSTimer *countDownTimer;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENFindPasswordViewController

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
    
    if (indexPath.row == 0) {
        cell.leftTextField.placeholder = @"手机号码";
        cell.leftTextField.userInteractionEnabled = YES;
        cell.leftTextField.keyboardType = UIKeyboardTypePhonePad;
        cell.leftTextField.secureTextEntry = NO;
        cell.rightButton.hidden = YES;
        cell.rightLabel.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.leftTextFieldLayoutConstraint.constant = 15.0f;
    } else {
        cell.leftTextField.placeholder = @"验证码";
        cell.leftTextField.userInteractionEnabled = YES;
        cell.leftTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.leftTextField.secureTextEntry = NO;
        cell.rightButton.hidden = NO;
        cell.rightLabel.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.leftTextFieldLayoutConstraint.constant = 135.0f;
        
        [cell.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)rightButtonClick { // 获取验证码
    VENRegisterTableViewCell *cell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSDictionary *parameters = @{@"phone": cell.leftTextField.text,
                                 @"from": @"forgot"};
    
    [[VENNetworkTool sharedManager] GET:@"index/smsCode" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.seconds = 60;
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)timeFireMethod {
    _seconds--;
    
    VENRegisterTableViewCell *cell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    cell.rightButton.userInteractionEnabled = NO;
    
    // titleLabel.text 解决频繁刷新 Button 闪烁的问题
    cell.rightButton.titleLabel.text = [NSString stringWithFormat:@"%ld秒后重新获取", (long)_seconds];
    [cell.rightButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取", (long)_seconds] forState:UIControlStateNormal];
    
    if(_seconds == 0) {
        [_countDownTimer invalidate];
        [cell.rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        cell.rightButton.userInteractionEnabled = YES;
    }
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
    
    // 下一步
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth - 30, 49)];
    nextButton.backgroundColor = COLOR_THEME;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    nextButton.layer.cornerRadius = 4.0f;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
    
    self.tableView = tableView;
}

- (void)nextButtonClick {
    
    VENRegisterTableViewCell *phoneCell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    VENRegisterTableViewCell *smsCodeCell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:phoneCell.leftTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入手机号码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:smsCodeCell.leftTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入验证码"];
        return;
    }
    
    VENSettingPasswordViewController *vc = [[VENSettingPasswordViewController alloc] init];
    vc.phone = phoneCell.leftTextField.text;
    vc.smsCode = smsCodeCell.leftTextField.text;
    [self presentViewController:vc animated:YES completion:nil];
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
