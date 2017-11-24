//
//  LCHorizontalTableView.h
//  LCHorizontalTableView
//
//  Created by licong on 2017/11/6.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHorizontalTableViewCell.h"

@class LCHorizontalTableView;

@protocol LCHorizontalTableViewDataSource<NSObject>
@required
- (NSUInteger)numberOfColumnInTableView:(LCHorizontalTableView *)tableView;

- (LCHorizontalTableViewCell* )tableView:(LCHorizontalTableView *)tableView cellAtIndex:(NSInteger)index;

@end

@protocol LCHorizontalTableViewDelegate <NSObject>

@required
- (CGFloat)tableView:(LCHorizontalTableView *)tableView widthForColumAtIndex:(NSInteger )index;

@optional
- (void)tableView:(LCHorizontalTableView *)tableView didSelectRowAtIndex:(NSInteger )index;
- (UIView *)viewForHeaderInTableView:(LCHorizontalTableView *)tableView;


@end


@interface LCHorizontalTableView : UIView
/** 数据源 */
@property (nonatomic, weak) id<LCHorizontalTableViewDataSource> dataSource;
/** 代理 */
@property (nonatomic, weak) id<LCHorizontalTableViewDelegate> delegate;
/** item之间的间距 */
@property (nonatomic, assign) CGFloat innerSpace;

/** table的edgeInset */
@property (nonatomic, assign) UIEdgeInsets edgeInset;

/** 刷新数据（只要调用这个方法，会重新向数据源和代理发送请求，请求数据）*/
- (void)reloadData;

- (LCHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSInteger )index;


- (void)registerClass:(Class )cellClass forCellReuseIdentifier:(NSString *)identifier;

@end



