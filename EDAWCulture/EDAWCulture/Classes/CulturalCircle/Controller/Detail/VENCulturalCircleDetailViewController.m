//
//  VENCulturalCircleDetailViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/9.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCulturalCircleDetailViewController.h"
#import "VENCulturalCircleApprenticeTableViewCell.h"
#import "VENHomePageModel.h"

@interface VENCulturalCircleDetailViewController () <UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, copy) NSDictionary *resultDict;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIWebView *webView;
@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENCulturalCircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"详情";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupLeftBtn];
    [self loadData];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] GET:@"index/infoDetail" parameters:@{@"id": self.infoID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            NSDictionary *resultDict = responseObject[@"data"][@"result"];
            self.resultDict = resultDict;
            
            [self setupTableView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight)];
    webView.delegate = self;
    webView.scrollView.scrollEnabled = NO;
    [webView loadHTMLString:self.resultDict[@"content"] baseURL:nil];
    [headerView addSubview:webView];
    
    self.tableView = tableView;
    self.headerView = headerView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kMainScreenWidth, webViewHeight);
    self.tableView.tableHeaderView = self.headerView;
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
