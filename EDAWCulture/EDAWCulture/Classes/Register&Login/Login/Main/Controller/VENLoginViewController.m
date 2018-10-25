//
//  VENLoginViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLoginViewController.h"
#import "VENRegisterViewController.h"
#import "VENFindPasswordViewController.h"
#import "VENTabBarController.h"

@interface VENLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closePageButton;
@property (weak, nonatomic) IBOutlet UIButton *userLoginButton;
@property (weak, nonatomic) IBOutlet UIImageView *userLoginImageView;
@property (weak, nonatomic) IBOutlet UIButton *masterLoginButton;
@property (weak, nonatomic) IBOutlet UIImageView *masterLoginImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordButton;

@end

@implementation VENLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.closePageButton addTarget:self action:@selector(closePageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.userLoginButton addTarget:self action:@selector(userLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.masterLoginButton addTarget:self action:@selector(masterLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.findPasswordButton addTarget:self action:@selector(findPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumberTextField.layer.cornerRadius = 4.0f;
    self.phoneNumberTextField.layer.masksToBounds = YES;
    
    self.passwordTextField.layer.cornerRadius = 4.0f;
    self.passwordTextField.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius = 4.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 49)];
    self.phoneNumberTextField.leftView = leftView;
    self.phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 49)];
    self.passwordTextField.leftView = leftView2;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.secureTextEntry = YES;
    

    
    NSLog(@"USER_TYPE - %d", [[VENUserTypeManager sharedManager] isMaster]);
    
    // Test
    [self test];
}

- (void)closePageButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userLoginButtonClick {
    [self.userLoginButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
    [self.masterLoginButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    self.userLoginImageView.backgroundColor = COLOR_THEME;
    self.userLoginImageView.hidden = NO;
    self.masterLoginImageView.hidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"USER_TYPE"];
    
    NSLog(@"USER_TYPE - %d", [[VENUserTypeManager sharedManager] isMaster]);
    // Test
    [self test];
}

- (void)masterLoginButtonClick {
    [self.userLoginButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.masterLoginButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
    self.masterLoginImageView.backgroundColor = COLOR_THEME;
    self.userLoginImageView.hidden = YES;
    self.masterLoginImageView.hidden = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"2" forKey:@"USER_TYPE"];
    
    NSLog(@"USER_TYPE - %d", [[VENUserTypeManager sharedManager] isMaster]);
    // Test
    [self test];
}

- (void)loginButtonClick {
    
    NSLog(@"USER_TYPE - %d", [[VENUserTypeManager sharedManager] isMaster]);
    
    NSString *urlStr = [[VENUserTypeManager sharedManager] isMaster] ? @"index/masterLogin" : @"index/userLogin";
    NSDictionary *parameters = @{@"phone": self.phoneNumberTextField.text,
                                 @"password": self.passwordTextField.text};
    
    [[VENNetworkTool sharedManager] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
            [defaults1 setObject:[[VENUserTypeManager sharedManager] isMaster] ? @"2" : @"1" forKey:@"USER_TYPE"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject[@"data"] forKey:@"Login"];
            
            NSLog(@"Login - %d", [[VENUserTypeManager sharedManager] isLogin]);
            
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:NO completion:nil];
            VENTabBarController *vc = [[VENTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)registerButtonClick {
    VENRegisterViewController *vc = [[VENRegisterViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)findPasswordButtonClick {
    VENFindPasswordViewController *vc = [[VENFindPasswordViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
    self.phoneNumberTextField.text = [[VENUserTypeManager sharedManager] isMaster] ? @"15215600000" : @"15305532355";
    self.passwordTextField.text = [[VENUserTypeManager sharedManager] isMaster] ? @"111111" : @"123456";
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
