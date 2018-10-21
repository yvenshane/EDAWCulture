//
//  VENCityPickerView.m
//  EDAWCulture
//
//  Created by YVEN on 2018/10/8.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCityPickerView.h"

@interface VENCityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *provincesMuArr;
@property (nonatomic, strong) NSMutableArray *citiesMuArr;

@property (nonatomic, strong) NSMutableArray *provincesNameMuArr;
@property (nonatomic, strong) NSMutableArray *citiesNameMuArr;

@property (nonatomic, strong) NSMutableArray *provincesIDMuArr;
@property (nonatomic, strong) NSMutableArray *citiesIDMuArr;

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *provinceID;
@property (nonatomic, copy) NSString *cityID;

@end

@implementation VENCityPickerView

- (instancetype)initWithFrame:(CGRect)frame forData:(NSDictionary *)dataDict {
    if (self = [super initWithFrame:frame]) {
        
        [self.provincesMuArr addObjectsFromArray:dataDict[@"provinces"]];
        [self.citiesMuArr addObjectsFromArray:dataDict[@"cities"]];
        
        for (NSDictionary *dict in dataDict[@"provinces"]) {
            [self.provincesNameMuArr addObject:dict[@"province"]];
        }
        
        for (NSDictionary *dict in dataDict[@"cities"]) {
            [self.citiesNameMuArr addObject:dict[@"city"]];
        }
        
        for (NSDictionary *dict in dataDict[@"provinces"]) {
            [self.provincesIDMuArr addObject:dict[@"province_id"]];
        }
        
        for (NSDictionary *dict in dataDict[@"cities"]) {
            [self.citiesIDMuArr addObject:dict[@"city_id"]];
        }
        
        self.provinceName = self.provincesNameMuArr[0];
        self.cityName = self.citiesNameMuArr[0];
        
        self.provinceID = self.provincesIDMuArr[0];
        self.cityID = self.citiesIDMuArr[0];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:pickerView];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitle:@"取消" forState: UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *finishButton = [[UIButton alloc] init];
        [finishButton setTitle:@"完成" forState: UIControlStateNormal];
        [finishButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self addSubview:lineView];
        
        _backgroundView = backgroundView;
        _cancelButton = cancelButton;
        _finishButton = finishButton;
        _pickerView = pickerView;
        _lineView = lineView;
    }
    
    return self;
}

- (void)cancelButtonClick {
    self.block(@"cancel");
}

- (void)finishButtonClick {
    self.block([NSString stringWithFormat:@"%@-%@,%@,%@", self.provinceName, self.cityName, self.provinceID, self.cityID]);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundView.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
    _cancelButton.frame = CGRectMake(0, 0, 88, 44);
    _finishButton.frame = CGRectMake(kMainScreenWidth - 88, 0, 88, 44);
    _pickerView.frame = CGRectMake(0, 44, kMainScreenWidth, 216);
    _lineView.frame = CGRectMake(0, 43, kMainScreenWidth, 1);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? self.provincesNameMuArr.count : self.citiesNameMuArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return component == 0 ? self.provincesNameMuArr[row] : self.citiesNameMuArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:self.provincesMuArr[row][@"province_id"] forKey:@"provinceId"];

        // 请求城市数据
        [[VENNetworkTool sharedManager] GET:@"index/city" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            [self.citiesNameMuArr removeAllObjects];
            [self.citiesIDMuArr removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"][@"cities"]) {
                [self.citiesNameMuArr addObject:dict[@"city"]];
            }
            
            for (NSDictionary *dict in responseObject[@"data"][@"cities"]) {
                [self.citiesIDMuArr addObject:dict[@"city_id"]];
            }
            
            // 刷新城市列表
            [pickerView reloadComponent:1];
            // 更换省份 城市列表 恢复到第一行
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            self.cityName = self.citiesNameMuArr[0];
            
            self.cityID = self.citiesIDMuArr[0];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
        
        self.provinceName = self.provincesNameMuArr[row];
        
        self.provinceID = self.provincesIDMuArr[row];
    } else {
        self.cityName = self.citiesNameMuArr[row];
        
        self.cityID = self.citiesIDMuArr[row];
    }
}

- (NSMutableArray *)provincesMuArr {
    if (_provincesMuArr == nil) {
        _provincesMuArr = [NSMutableArray array];
    }
    return _provincesMuArr;
}

- (NSMutableArray *)citiesMuArr {
    if (_citiesMuArr == nil) {
        _citiesMuArr = [NSMutableArray array];
    }
    return _citiesMuArr;
}

- (NSMutableArray *)provincesNameMuArr {
    if (_provincesNameMuArr == nil) {
        _provincesNameMuArr = [NSMutableArray array];
    }
    return _provincesNameMuArr;
}

- (NSMutableArray *)citiesNameMuArr {
    if (_citiesNameMuArr == nil) {
        _citiesNameMuArr = [NSMutableArray array];
    }
    return _citiesNameMuArr;
}

- (NSMutableArray *)provincesIDMuArr {
    if (_provincesIDMuArr == nil) {
        _provincesIDMuArr = [NSMutableArray array];
    }
    return _provincesIDMuArr;
}

- (NSMutableArray *)citiesIDMuArr {
    if (_citiesIDMuArr == nil) {
        _citiesIDMuArr = [NSMutableArray array];
    }
    return _citiesIDMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
