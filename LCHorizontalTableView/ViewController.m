//
//  ViewController.m
//  LCHorizontalTableView
//
//  Created by licong on 2017/11/6.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ViewController.h"
#import "LCHorizontalTableView.h"
#import "LCCustomCell.h"

@interface ViewController ()<LCHorizontalTableViewDataSource, LCHorizontalTableViewDelegate>
@property (nonatomic, copy)NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 10; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"测试数据%ld",i]];
    }
    
    LCHorizontalTableView * tableView = [[LCHorizontalTableView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 30)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    tableView.innerSpace = 10;
    [tableView registerClass:[LCHorizontalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LCHorizontalTableViewCell class]) ];
    [tableView reloadData];
}


- (UIView *)addLabelWithTitle:(NSString *)title {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = UIColor.blackColor;
    label.frame = CGRectMake(15, 15, 120, 25);
    label.font = [UIFont systemFontOfSize:19];
    label.text = title;
    [view addSubview:label];
    return view;
}


- (NSUInteger)numberOfColumnInTableView:(LCHorizontalTableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(LCHorizontalTableView *)tableView widthForColumAtIndex:(NSInteger)index{
    NSString *text = self.dataArray[index];
    CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width + 30;
    return width;
}

- (void)tableView:(LCHorizontalTableView *)tableView didSelectRowAtIndex:(NSInteger)index{
    [self addLabelWithTitle:@"我的热门搜索"];
}

- (LCHorizontalTableViewCell *)tableView:(LCHorizontalTableView *)tableView cellAtIndex:(NSInteger)index{
    LCHorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHorizontalTableViewCell class]) forIndex:index];
    cell.label.text = self.dataArray[index];
    return cell;
}


@end
