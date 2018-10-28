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
#import "VENLoginViewController.h"
#import <SDImageCache.h>
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZPhotoPickerController.h"
#import "TZImageManager.h"
#import "VENHomePageModel.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface VENPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, TZImagePickerControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *titleLabelTextMuArr;
@property (nonatomic, strong) NSMutableArray *leftImageViewImageNameMuArr;
@property (nonatomic, assign) BOOL hiddenNav;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, assign) NSInteger maxCount; // 选取最大的张数
@property (nonatomic, assign) NSInteger maxColumn; // 选取照片展示列表的列数
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, retain) NSMutableArray *selectedAssets;
@property (nonatomic, retain) NSMutableArray *selectedPhotos;

@property (nonatomic, strong) VENHomePageModel *model;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    _maxCount = 1;
    _maxColumn = 4;
}

- (void)loadData {
    [[VENNetworkTool sharedManager] GET:@"index/userCenter" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            VENHomePageModel *model = [VENHomePageModel yy_modelWithJSON:responseObject[@"data"]];
            self.model = model;
            
            [self setupTabbleView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [VENUserTypeManager sharedManager].isMaster ? 7 : 6;
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
    
    if ([VENUserTypeManager sharedManager].isMaster) { // 大师
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
    } else { // 用户
        if (indexPath.row == 0) {
            VENMyOrderViewController *vc = [[VENMyOrderViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            self.hiddenNav = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) { // 我的关注
            VENMyFocusingViewController *vc = [[VENMyFocusingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            self.hiddenNav = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 5) { // 联系客服
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", self.model.kefu];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (void)setupTabbleView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - tabBarHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VENPersonalCenterTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
//    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    CGFloat headerViewHeight = [VENUserTypeManager sharedManager].isMaster ? 369 / 2 : 520 / 2;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, headerViewHeight)];
    headerView.backgroundColor = UIColorFromRGB(0x5b25e6);
    tableView.tableHeaderView = headerView;
    
    // 头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatarUrl] placeholderImage:[UIImage imageNamed:@"user_img1"]];
    [iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    iconImageView.layer.cornerRadius = 35.0f;
    iconImageView.layer.masksToBounds = YES;
    [headerView addSubview:iconImageView];
    
    UITapGestureRecognizer *tapGestureLogo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogoEvent:)];
    tapGestureLogo.numberOfTapsRequired = 1;
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:tapGestureLogo];
    
    self.iconImageView = iconImageView;
    
    // 用户名
    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.text = self.model.nickname;
    userLabel.textColor = [UIColor whiteColor];
    userLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
    [headerView addSubview:userLabel];
    
    if ([VENUserTypeManager sharedManager].isMaster) {
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(headerView.mas_centerY);
            make.width.height.mas_equalTo(70);
        }];
        
        userLabel.textAlignment = NSTextAlignmentLeft;
        [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImageView.mas_right).mas_offset(22);
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
            make.left.mas_equalTo(iconImageView.mas_right).mas_offset(22);
            make.centerY.mas_equalTo(headerView.mas_centerY).mas_offset(22.5);
            make.width.mas_equalTo(kMainScreenWidth - 15 - 70 - 22 - 15);
            make.height.mas_equalTo(29);
        }];
        
    } else {
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(52);
            make.centerX.mas_equalTo(headerView.mas_centerX);
            make.width.height.mas_equalTo(70);
        }];
        
        userLabel.textAlignment = NSTextAlignmentCenter;
        [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconImageView.mas_bottom).mas_offset(25);
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
        placeLabel.text = [NSString stringWithFormat:@"%@%@", self.model.province_name, self.model.city_name];
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
    
    _tableView = tableView;
}

- (void)tapLogoEvent:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"相机", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 1001) {
        if (buttonIndex == 0) {
            [self pushImagePickerController];
        }else if (buttonIndex == 1) {
            [self takePhoto];
        }
    }
}

//相册选取
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxCount columnNumber:_maxColumn delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (_maxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = COLOR_THEME;
    //    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //    imagePickerVc.oKButtonTitleColorNormal = COLOR_THEME;
    imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    
    
    imagePickerVc.cropRect = CGRectMake((kMainScreenWidth - kMainScreenWidth * 0.8) / 2, (kMainScreenHeight - kMainScreenWidth * 1) / 2, kMainScreenWidth * 0.8, kMainScreenWidth * 1);
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    [[VENNetworkTool sharedManager] POST:@"index/userUploadAvatar" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *fileData = UIImagePNGRepresentation(photos[0]);
        [formData appendPartWithFileData:fileData name:@"avatar" fileName:@"icon.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"avatarUrl"]]];
            [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_img1"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//拍照
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    }else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            self.tabBarController.tabBar.hidden=YES;
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset

        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        BOOL needCrop = YES;
                        if (needCrop) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            
                            imagePicker.needCircleCrop = NO;
                            imagePicker.cropRect = CGRectMake((kMainScreenWidth - kMainScreenWidth * 0.754) / 2, (kMainScreenHeight - kMainScreenWidth * 1) / 2, kMainScreenWidth * 0.754, kMainScreenWidth * 1);
                            self.tabBarController.tabBar.hidden = NO;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.tabBarController.tabBar.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[VENNetworkTool sharedManager] POST:@"index/userUploadAvatar" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *fileData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:fileData name:@"avatar" fileName:@"icon.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"msg"]];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"avatarUrl"]]];
            [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_img1"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)logoutButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"\n清除前");
        NSLog(@"\nUSER_TYPE - %d", [[VENUserTypeManager sharedManager] isMaster]);
        NSLog(@"\nLogin - %d", [[VENUserTypeManager sharedManager] isLogin]);
        
        // 回到首页
        self.tabBarController.selectedIndex = 0;
        
        // 清除本地存储信息
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];

        // 跳转到登录页面
        VENLoginViewController *vc = [[VENLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
        [self.titleLabelTextMuArr removeAllObjects];
        self.titleLabelTextMuArr = nil;
        [self.leftImageViewImageNameMuArr removeAllObjects];
        self.leftImageViewImageNameMuArr = nil;
        
        NSLog(@"\n清除后");
        NSLog(@"\nUSER_TYPE - %d", [[VENUserTypeManager sharedManager] isMaster]);
        NSLog(@"\nLogin - %d", [[VENUserTypeManager sharedManager] isLogin]);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:determineAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSMutableArray *)titleLabelTextMuArr {
    if (_titleLabelTextMuArr == nil) {
        _titleLabelTextMuArr = [NSMutableArray arrayWithArray:[VENUserTypeManager sharedManager].isMaster ? @[@"我的订单", @"未付款", @"进行中", @"已完成", @"我的余额", @"我的消息", @"联系客服"] : @[@"我的订单", @"未付款", @"进行中", @"已完成", @"我的关注", @"联系客服"]];
    }
    return _titleLabelTextMuArr;
}

- (NSMutableArray *)leftImageViewImageNameMuArr {
    if (_leftImageViewImageNameMuArr == nil) {
        _leftImageViewImageNameMuArr = [NSMutableArray arrayWithArray:[VENUserTypeManager sharedManager].isMaster ? @[@"user_order", @"", @"", @"", @"user_focus", @"user_money", @"user_message", @"user_service"] : @[@"user_order", @"", @"", @"", @"user_focus", @"user_service"]];
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
