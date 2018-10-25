//
//  VENWorkAndLuckDetailPopupView.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/7.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENWorkAndLuckDetailPopupView.h"
#import "VENHomePageModel.h"

@interface VENWorkAndLuckDetailPopupView () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENWorkAndLuckDetailPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 49.0f;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.tableFooterView = [UIView new];
        [self addSubview:tableView];
        
        UIButton *purchaseButton = [[UIButton alloc] init];
        [purchaseButton setTitle:@"购买" forState:UIControlStateNormal];
        [purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        purchaseButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        purchaseButton.backgroundColor = COLOR_THEME;
        purchaseButton.layer.cornerRadius = 4;
        purchaseButton.layer.masksToBounds = YES;
        [self addSubview:purchaseButton];
        
        _tableView = tableView;
        _purchaseButton = purchaseButton;
        
        self.indexPath = -1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, self.frame.size.height - 49);
    self.purchaseButton.frame = CGRectMake(15, self.frame.size.height - 44, kMainScreenWidth - 30, 39);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENHomePageModel *model = self.dataSourceArr[indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.price;
    
    cell.textLabel.textColor = indexPath.row == self.indexPath ? COLOR_THEME : UIColorFromRGB(0x333333);
    cell.detailTextLabel.textColor = indexPath.row == self.indexPath ? COLOR_THEME : UIColorFromRGB(0x333333);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.indexPath = indexPath.row;
    
    cell.textLabel.textColor = COLOR_THEME;
    cell.detailTextLabel.textColor = COLOR_THEME;
    
    self.block(self.dataSourceArr[indexPath.row]);
    
    [tableView reloadData];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
