//
//  VENWorkAndLuckViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/6.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENWorkAndLuckViewController.h"
#import "VENMyFocusingTableViewCell.h"
#import "VENWorkAndLuckDetailViewController.h"

@interface VENWorkAndLuckViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *headerViewTitleLabelTextMuArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENWorkAndLuckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"事业财运";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTabbleView];
    [self setupLeftBtn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMyFocusingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENWorkAndLuckDetailViewController *vc = [[VENWorkAndLuckDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    // 整个 HeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 59)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    // 分割线
    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    splitLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:splitLineView];

    // 大师级别
    UIImageView *titleViewImageView = [[UIImageView alloc] init];
    titleViewImageView.backgroundColor = COLOR_THEME;
    [headerView addSubview:titleViewImageView];

    [titleViewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(headerView.mas_centerY).mas_offset(5);
        make.width.mas_equalTo(5 / 2);
        make.height.mas_equalTo(35 / 2);
    }];

    UILabel *titleViewLabel = [[UILabel alloc] init];
    titleViewLabel.text = self.headerViewTitleLabelTextMuArr[section];
    titleViewLabel.textColor = UIColorFromRGB(0x333);
    titleViewLabel.font = [UIFont systemFontOfSize:17.0f];
    [headerView addSubview:titleViewLabel];

    [titleViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleViewImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(headerView.mas_centerY).mas_offset(5);
    }];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 59;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VENMyFocusingTableViewCell  class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    [self.view addSubview:tableView];
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

- (NSMutableArray *)headerViewTitleLabelTextMuArr {
    if (_headerViewTitleLabelTextMuArr == nil) {
        _headerViewTitleLabelTextMuArr = [NSMutableArray arrayWithArray:@[@"大师级", @"专家级", @"执业师", @"研究员", @"爱好者"]];
    }
    return _headerViewTitleLabelTextMuArr;
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
