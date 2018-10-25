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
#import "VENHomePageModel.h"

@interface VENWorkAndLuckViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSDictionary *dataSourceDict;
@property (nonatomic, copy) NSArray *resultArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENWorkAndLuckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = @"事业财运";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    [self setupLeftBtn];
}

- (void)loadData {
    
    NSDictionary *parameters = @{@"serviceIconId": self.pageID};
    
    [[VENNetworkTool sharedManager] GET:@"index/levelGroupMasters" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            NSDictionary *dataSourceDict = responseObject[@"data"];
            
            NSArray *resultArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:dataSourceDict[@"result"]];

            self.resultArr = resultArr;
            self.dataSourceDict = dataSourceDict;
            
            [self setupTabbleView];
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resultArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *mastersArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:self.dataSourceDict[@"result"][section][@"masters"]];

    return mastersArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *mastersArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:self.dataSourceDict[@"result"][indexPath.section][@"masters"]];
    
    VENHomePageModel *model = mastersArr[indexPath.row];

    VENMyFocusingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:nil];
    cell.nameLabel.text = model.nickname;
    cell.skillsLabel.text = [model.goodFields componentsJoinedByString:@"  "];
    cell.profilesLabel.text = model.summary;
    cell.priceLabel.text = model.price_text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *mastersArr = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:self.dataSourceDict[@"result"][indexPath.section][@"masters"]];
    
    VENHomePageModel *model = mastersArr[indexPath.row];
    
    VENWorkAndLuckDetailViewController *vc = [[VENWorkAndLuckDetailViewController alloc] init];
    vc.navTitle = self.navigationItem.title;
    vc.masterId = model.bannersID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    VENHomePageModel *model = self.resultArr[section];
    
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
    titleViewLabel.text = model.name;
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
