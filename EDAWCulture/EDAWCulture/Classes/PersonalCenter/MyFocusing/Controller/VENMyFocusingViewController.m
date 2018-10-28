//
//  VENMyFocusingViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/6.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyFocusingViewController.h"
#import "VENMyFocusingTableViewCell.h"
#import "VENHomePageModel.h"
#import "VENWorkAndLuckDetailViewController.h"

@interface VENMyFocusingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSDictionary *dataSourceDict;
@property (nonatomic, copy) NSArray *resultArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMyFocusingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的关注";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self setupLeftBtn];
    [self loadData];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] GET:@"index/userSubscribeMasters" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageModel *model = self.resultArr[indexPath.row];
    
    VENMyFocusingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:nil];
    cell.nameLabel.text = model.nickname;
    cell.skillsLabel.text = [model.goodFields componentsJoinedByString:@"  "];
    cell.profilesLabel.text = model.summary;
    cell.priceLabel.text = model.price_text;
    
    if ([model.isSubscribe integerValue] == 1) {
        cell.likeButton.selected = YES;
        cell.likeButton.hidden = NO;
    } else if ([model.isSubscribe integerValue] == 2) {
        cell.likeButton.selected = NO;
        cell.likeButton.hidden = YES;
    }
    
    [cell.likeButton addTarget:self action:@selector(likeButtonClick:WithEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)likeButtonClick:(UIButton *)button WithEvent:(id)event{
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil)  {
        // 执行你想要的操作
    }
    
    button.selected = !button.selected;
    
    VENHomePageModel *model = self.resultArr[indexPath.row];
    
    NSDictionary *parameters = @{@"masterId": model.bannersID};
    
    [[VENNetworkTool sharedManager] POST:button.selected == NO ? @"index/userUnsubscribe" : @"index/userSubscribe" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageModel *model = self.resultArr[indexPath.row];
    
    VENWorkAndLuckDetailViewController *vc = [[VENWorkAndLuckDetailViewController alloc] init];
    vc.navTitle = self.navigationItem.title;
    vc.masterId = model.bannersID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, kMainScreenHeight - statusNavHeight - 10) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VENMyFocusingTableViewCell  class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 分割线
//    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
//    splitLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
//    tableView.tableHeaderView = splitLineView;
//
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
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
