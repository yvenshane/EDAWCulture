//
//  VENTabBarController.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/14.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENTabBarController.h"
#import "VENNavigationController.h"
#import "VENLoginViewController.h"

@interface VENTabBarController () <UITabBarControllerDelegate>

@end

@implementation VENTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIViewController *vc1 = [self loadChildViewControllerWithClassName:@"VENHomePageViewController" andTitle:@"首页" andImageName:@"ic_home"];
    UIViewController *vc2 = [self loadChildViewControllerWithClassName:@"VENMessageViewController" andTitle:@"消息" andImageName:@"ic_message"];
    UIViewController *vc3 = [self loadChildViewControllerWithClassName:@"VENCulturalCircleViewController" andTitle:@"文化圈" andImageName:@"ic_culture"];
    UIViewController *vc4 = [self loadChildViewControllerWithClassName:@"VENPersonalCenterViewController" andTitle:@"个人中心" andImageName:@"ic_user"];
    vc4.tabBarItem.tag = 3;
    
    self.viewControllers = @[vc1, vc2, vc3, vc4];
    
    self.tabBar.tintColor = COLOR_THEME;
    self.delegate = self;
    //    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController.tabBarItem.tag == 3) {
        VENLoginViewController *vc = [[VENLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        return NO;
    } else {

        return YES;
    }
}

- (UIViewController *)loadChildViewControllerWithClassName:(NSString *)className andTitle:(NSString *)title andImageName:(NSString *)imageName {
    
    // 把类名的字符串转成类的类型
    Class class = NSClassFromString(className);
    
    // 通过转换出来的类的类型来创建控制器
    UIViewController *vc = [class new];
    
    // 设置TabBar的文字
    vc.tabBarItem.title = title;
    
    NSString *normalImageName = [imageName stringByAppendingString:@"_nor"];
    // 设置默认状态的图片
    vc.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 拼接选中状态的图片
    NSString *selectedImageName = [imageName stringByAppendingString:@"_on"];
    // 设置选中图片
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 创建导航控制器
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    
    return nav;
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
