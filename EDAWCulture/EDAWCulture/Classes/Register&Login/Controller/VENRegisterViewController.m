//
//  VENRegisterViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegisterViewController.h"
#import "VENRegisterTableViewCell.h"

@interface VENRegisterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *leftTextFieldPlaceholderTextMuArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTabbleView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.leftTextField.placeholder = self.leftTextFieldPlaceholderTextMuArr[indexPath.row];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
