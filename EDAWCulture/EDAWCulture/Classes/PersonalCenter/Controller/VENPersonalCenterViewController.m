//
//  VENPersonalCenterViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/8/31.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPersonalCenterViewController.h"
#import "VENPersonalCenterTableViewCell.h"
#import "VENMyOrderViewController.h"
#import "VENMyFocusingViewController.h"
#import "VENMyBalanceViewController.h"

@interface VENPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *titleLabelTextMuArr;
@property (nonatomic, strong) NSMutableArray *leftImageViewImageNameMuArr;
@property (nonatomic, assign) BOOL hiddenNav;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"USER_TYPE"];
    
    [self setupTabbleView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [VENUserTypeManager sharedUserTypeManager].isMaster ? 7 : 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENPersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.titleLabelTextMuArr[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:self.leftImageViewImageNameMuArr[indexPath.row]];
    
    cell.rightImageView.hidden = indexPath.row == 0 ? YES : NO;
    
    if (indexPath.row == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 51, 0, 0);
    } else if (indexPath.row == 2){
        cell.separatorInset = UIEdgeInsetsMake(0, 51, 0, 0);
    } else {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([VENUserTypeManager sharedUserTypeManager].isMaster) {
        if (indexPath.row == 0) {
            VENMyOrderViewController *vc = [[VENMyOrderViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            self.hiddenNav = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            VENMyBalanceViewController *vc = [[VENMyBalanceViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            self.hiddenNav = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            VENMyOrderViewController *vc = [[VENMyOrderViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            self.hiddenNav = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            VENMyFocusingViewController *vc = [[VENMyFocusingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            self.hiddenNav = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kMainScreenWidth, kMainScreenHeight + 20) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VENPersonalCenterTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    // headerView
    CGFloat headerViewHeight = [VENUserTypeManager sharedUserTypeManager].isMaster ? 369 / 2 : 520 / 2;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, headerViewHeight)];
    headerView.backgroundColor = UIColorFromRGB(0x5b25e6);
    tableView.tableHeaderView = headerView;
    
    // 头像
    UIButton *iconButton = [[UIButton alloc] init];
    [iconButton setImage:[UIImage imageNamed:@"user_img1"] forState:UIControlStateNormal];
    iconButton.layer.cornerRadius = 35.0f;
    iconButton.layer.masksToBounds = YES;
    [headerView addSubview:iconButton];
    
    // 用户名
    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.text = @"大牛";
    userLabel.textColor = [UIColor whiteColor];
    userLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:24.0f];
    [headerView addSubview:userLabel];
    
    if ([VENUserTypeManager sharedUserTypeManager].isMaster) {
        [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(headerView.mas_centerY);
            make.width.height.mas_equalTo(70);
        }];
        
        userLabel.textAlignment = NSTextAlignmentLeft;
        [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconButton.mas_right).mas_offset(22);
            make.centerY.mas_equalTo(headerView.mas_centerY).mas_offset(-18.5);
            make.width.mas_equalTo(kMainScreenWidth - 15 - 70 - 22 - 15);
            make.height.mas_equalTo(29);
        }];
        
        // 技能等级
        UILabel *skillLevelLabel = [[UILabel alloc] init];
        
        NSString *str = @"v5";
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"技能等级：%@", str]];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xcab6ff) range:NSMakeRange(0, 5)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(4, attributedStr.length - 4)];
        skillLevelLabel.attributedText = attributedStr;
        skillLevelLabel.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:skillLevelLabel];
        
        [skillLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconButton.mas_right).mas_offset(22);
            make.centerY.mas_equalTo(headerView.mas_centerY).mas_offset(22.5);
            make.width.mas_equalTo(kMainScreenWidth - 15 - 70 - 22 - 15);
            make.height.mas_equalTo(29);
        }];
        
    } else {
        
        [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(52);
            make.centerX.mas_equalTo(headerView.mas_centerX);
            make.width.height.mas_equalTo(70);
        }];
        
        userLabel.textAlignment = NSTextAlignmentCenter;
        [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconButton.mas_bottom).mas_offset(25);
            make.centerX.mas_equalTo(headerView.mas_centerX);
            make.width.mas_equalTo(kMainScreenWidth);
            make.height.mas_equalTo(29);
        }];
        
        // 地址
        UIView *placeView = [[UIView alloc] init];
        //        placeView.backgroundColor = [UIColor redColor];
        [headerView addSubview:placeView];
        
        [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userLabel.mas_bottom).mas_offset(21.5);
            make.centerX.mas_equalTo(headerView.mas_centerX);
            make.width.mas_equalTo(kMainScreenWidth);
            make.height.mas_equalTo(24);
        }];
        
        UILabel *placeLabel = [[UILabel alloc] init];
        placeLabel.text = @"安徽合肥";
        placeLabel.textAlignment = NSTextAlignmentCenter;
        placeLabel.textColor = [UIColor whiteColor];
        placeLabel.font = [UIFont systemFontOfSize:14.0f];
        [placeView addSubview:placeLabel];
        
        [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(3.5);
            make.centerX.mas_equalTo(headerView.mas_centerX).mas_offset(8);
            make.height.mas_equalTo(17);
        }];
        
        UIImageView *placeImageView = [[UIImageView alloc] init];
        placeImageView.image = [UIImage imageNamed:@"user_addr"];
        [placeView addSubview:placeImageView];
        
        [placeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(placeLabel.mas_left).mas_offset(-5);
            make.width.height.mas_equalTo(24);
        }];
    }
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 59)];
    footerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.tableFooterView = footerView;
    
    // 退出登录
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 49)];
    logoutButton.backgroundColor = [UIColor whiteColor];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [logoutButton addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutButton];
}

- (void)logoutButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:determineAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSMutableArray *)titleLabelTextMuArr {
    if (_titleLabelTextMuArr == nil) {
        _titleLabelTextMuArr = [NSMutableArray arrayWithArray:[VENUserTypeManager sharedUserTypeManager].isMaster ? @[@"我的订单", @"未付款", @"进行中", @"已完成", @"我的余额", @"我的消息", @"联系客服"] : @[@"我的订单", @"未付款", @"进行中", @"已完成", @"我的关注", @"联系客服"]];
    }
    return _titleLabelTextMuArr;
}

- (NSMutableArray *)leftImageViewImageNameMuArr {
    if (_leftImageViewImageNameMuArr == nil) {
        _leftImageViewImageNameMuArr = [NSMutableArray arrayWithArray:[VENUserTypeManager sharedUserTypeManager].isMaster ? @[@"user_order", @"", @"", @"", @"user_focus", @"user_money", @"user_message", @"user_service"] : @[@"user_order", @"", @"", @"", @"user_focus", @"user_service"]];
    }
    return _leftImageViewImageNameMuArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.hiddenNav) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        [super viewWillDisappear:animated];
    }
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
