//
//  VENCulturalCircleApprenticeViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/7.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCulturalCircleApprenticeViewController.h"
#import "VENCulturalCircleApprenticeTableViewCell.h"

@interface VENCulturalCircleApprenticeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) CGFloat cellHeight;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENCulturalCircleApprenticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"我要拜师";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    // 计算 cell 高度
    VENCulturalCircleApprenticeTableViewCell *cell = [[VENCulturalCircleApprenticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell layoutSubviews];
    self.cellHeight = cell.maxHeight;
    
    [self setupLeftBtn];
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCulturalCircleApprenticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[VENCulturalCircleApprenticeTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 49 + 10 + 49 + 10 + 49 + 20 + 49 + 20)];
    footerView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = footerView;
    
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kMainScreenWidth - 30, 49)];
    nameTextField.backgroundColor = UIColorFromRGB(0xf5f5f5);
    nameTextField.placeholder = @"请填写您的姓名";
    nameTextField.font = [UIFont systemFontOfSize:15.0f];
    nameTextField.layer.cornerRadius = 4.0f;
    nameTextField.layer.masksToBounds = YES;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 49)];
    nameTextField.leftView = leftView;
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [footerView addSubview:nameTextField];
    
    UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 49 + 10, kMainScreenWidth - 30, 49)];
    phoneTextField.backgroundColor = UIColorFromRGB(0xf5f5f5);
    phoneTextField.placeholder = @"请填写联系方式";
    phoneTextField.font = [UIFont systemFontOfSize:15.0f];
    phoneTextField.layer.cornerRadius = 4.0f;
    phoneTextField.layer.masksToBounds = YES;
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 49)];
    phoneTextField.leftView = leftView2;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    [footerView addSubview:phoneTextField];
    
    UITextField *schoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 49 + 10 + 49 + 10, kMainScreenWidth - 30, 49)];
    schoolTextField.backgroundColor = UIColorFromRGB(0xf5f5f5);
    schoolTextField.placeholder = @"请填写学派";
    schoolTextField.font = [UIFont systemFontOfSize:15.0f];
    schoolTextField.layer.cornerRadius = 4.0f;
    schoolTextField.layer.masksToBounds = YES;
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 49)];
    schoolTextField.leftView = leftView3;
    schoolTextField.leftViewMode = UITextFieldViewModeAlways;
    [footerView addSubview:schoolTextField];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 49 + 10 + 49 + 10 + 49 + 20, kMainScreenWidth - 30, 49)];
    submitButton.backgroundColor = COLOR_THEME;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    submitButton.layer.cornerRadius = 4.0f;
    submitButton.layer.masksToBounds = YES;
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
}

- (void)submitButtonClick {
    
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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
