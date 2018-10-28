//
//  VENWebViewController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/10/26.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENWebViewController.h"

@interface VENWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIView *progressLine;

@end

@implementation VENWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.navTitle;
    
    [self setupWebView];
    [self setupLeftBtn];
}

- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [webView loadRequest:request];
    
    UIView *progressLine = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 3)];
    progressLine.backgroundColor = COLOR_THEME;
    [self.view addSubview:progressLine];
    
    self.progressLine = progressLine;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [self stopLoading];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self stopLoading];
    [self endLoadingAnimation];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self startLoadingAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self endLoadingAnimation];
    [self stopLoading];
}

- (void)startLoading {
    if (self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    self.view.userInteractionEnabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)stopLoading {
    if (self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    self.view.userInteractionEnabled = YES;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

// 假进度条
- (void)startLoadingAnimation{
    self.progressLine.hidden = NO;
    self.progressLine.frame = CGRectMake(0, 0, 0, 3);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.progressLine.frame = CGRectMake(0, 0, kMainScreenWidth * 0.6, 3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.progressLine.frame = CGRectMake(0, 0, kMainScreenWidth * 0.8, 3);
        }];
    }];
}

- (void)endLoadingAnimation{
    [UIView animateWithDuration:0.2 animations:^{
        self.progressLine.frame = CGRectMake(0, 0, kMainScreenWidth, 3);
    } completion:^(BOOL finished) {
        self.progressLine.hidden = YES;
    }];
}

- (void)setupLeftBtn {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"top_back01"] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)buttonClick {
    [self.navigationController popViewControllerAnimated:YES];
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
