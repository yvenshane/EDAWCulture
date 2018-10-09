//
//  VENRegisterViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegisterViewController.h"
#import "VENRegisterTableViewCell.h"
#import "VENCityPickerView.h"

@interface VENRegisterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *leftTextFieldPlaceholderTextMuArr;

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, strong) VENCityPickerView *cityPickerView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTabbleView];
//    [self loadRegisterViewData];
}

- (void)loadRegisterViewData {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.leftTextField.placeholder = self.leftTextFieldPlaceholderTextMuArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1) {
        cell.leftTextField.userInteractionEnabled = YES;
        cell.leftTextField.keyboardType = UIKeyboardTypePhonePad;
        cell.leftTextField.secureTextEntry = NO;
        cell.rightButton.hidden = YES;
        cell.rightLabel.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.leftTextFieldLayoutConstraint.constant = 15.0f;
    } else if (indexPath.row == 2) {
        cell.leftTextField.userInteractionEnabled = YES;
        cell.leftTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.leftTextField.secureTextEntry = NO;
        cell.rightButton.hidden = NO;
        cell.rightLabel.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.leftTextFieldLayoutConstraint.constant = 110.0f;
        
        [cell.rightButton addTarget:self action:@selector(getVerificationCodeClick) forControlEvents:UIControlEventTouchUpInside];
    } else if (indexPath.row == 3) {
        cell.leftTextField.userInteractionEnabled = NO;
        cell.rightButton.hidden = YES;
        cell.rightLabel.hidden = NO;
        cell.rightImageView.hidden = NO;
    } else {
        cell.leftTextField.userInteractionEnabled = YES;
        cell.leftTextField.keyboardType = UIKeyboardTypeDefault;
        cell.leftTextField.secureTextEntry = indexPath.row == 0 ? NO : YES;
        cell.rightButton.hidden = YES;
        cell.rightLabel.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.leftTextFieldLayoutConstraint.constant = 15.0f;
    }
    
    return cell;
}

- (void)getVerificationCodeClick { // 获取验证码
    VENRegisterTableViewCell *cell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    [[VENNetworkTool sharedNetworkToolManager] GET:@"index/smsCode" parameters:@{@"phone": cell.leftTextField.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);

        [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.seconds = 60;
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) { // 所在地区
        
        NSMutableDictionary *tempMuDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

        // 请求省份数据
        [[VENNetworkTool sharedNetworkToolManager] GET:@"index/province" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [tempMuDict setObject:responseObject[@"data"][@"provinces"] forKey:@"provinces"];
            [parameters setObject:tempMuDict[@"provinces"][0][@"province_id"] forKey:@"provinceId"];

            // 请求城市数据
            [[VENNetworkTool sharedNetworkToolManager] GET:@"index/city" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [tempMuDict setObject:responseObject[@"data"][@"cities"] forKey:@"cities"];
                
                
                if (self.cityPickerView == nil) {
                    VENCityPickerView *cityPickerView = [[VENCityPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 300 + statusNavHeight, kMainScreenWidth, 300) forData:tempMuDict];
                    [self.view addSubview:cityPickerView];
                    self.cityPickerView = cityPickerView;
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (void)timeFireMethod {
    _seconds--;
    
    VENRegisterTableViewCell *cell = (VENRegisterTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
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
    
    // 注册
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth - 30, 49)];
    registerButton.backgroundColor = COLOR_THEME;
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    registerButton.layer.cornerRadius = 4.0f;
    registerButton.layer.masksToBounds = YES;
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:registerButton];
    
    _tableView = tableView;
}

- (void)registerButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)leftBarButtonItemClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray* )leftTextFieldPlaceholderTextMuArr {
    if (_leftTextFieldPlaceholderTextMuArr == nil) {
        _leftTextFieldPlaceholderTextMuArr = [NSMutableArray arrayWithArray:@[@"姓名", @"手机号码", @"验证码", @"所在地区", @"设置密码", @"确认密码"]];
    }
    return _leftTextFieldPlaceholderTextMuArr;
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
