//
//  LCHorizontalTableView.m
//  LCHorizontalTableView
//
//  Created by licong on 2017/11/6.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "LCHorizontalTableView.h"

@interface LCHorizontalTableView()<UIScrollViewDelegate, LCHorizontalTableViewCellDelegate>{
    CGFloat _lastOffestX;
}

@property (nonatomic, strong)UIScrollView *scroll;

/** 所有cell的frame数据 */
@property (nonatomic, strong)NSMutableArray *cellFrames;
/** 正在展示的cell */
@property (nonatomic, strong)NSMutableDictionary *displayingCells;
/** 缓存池（用Set，存放离开屏幕的cell） */
@property (nonatomic, strong)NSMutableSet *reusableCells;
/** 用字典来映射identifier 和 注册的cell之间的关系 */
@property (nonatomic, strong)NSMutableDictionary *mapDict;

@end

@implementation LCHorizontalTableView


- (NSMutableArray *)cellFrames {
    if (_cellFrames == nil) {
        self.cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells {
    if (_displayingCells == nil) {
        self.displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet *)reusableCells {
    if (_reusableCells == nil) {
        self.reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (NSMutableDictionary *)mapDict{
    if (_mapDict == nil) {
        self.mapDict = [NSMutableDictionary dictionary];
    }
    return _mapDict;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _lastOffestX = 0;
        _innerSpace = 0;
        _scroll = [[UIScrollView alloc]initWithFrame:frame];
        _scroll.delegate = self;
        [self addSubview:_scroll];
        _scroll.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setDelegate:(id<LCHorizontalTableViewDelegate>)delegate{
    _delegate  = delegate;
    if ([_delegate respondsToSelector:@selector(viewForHeaderInTableView:)]) {
        UIView *header = [_delegate viewForHeaderInTableView:self];
        [self addSubview:header];
        header.frame = CGRectMake(0, 0, header.bounds.size.width, header.bounds.size.height);
        _scroll.frame = CGRectMake(0, CGRectGetMaxY(header.frame), header.bounds.size.width, self.bounds.size.height - header.frame.size.height);
    } else {
        _scroll.frame = self.bounds;
    }
}

- (void)reloadData{
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnInTableView:)]) {
        NSUInteger numberOfCells = [self.dataSource numberOfColumnInTableView:self];
        for (int i = 0; i < numberOfCells; i++) {
            [self.cellFrames addObject:[NSValue valueWithCGRect:[self getCellFrameWithIndex:i]]];
        }
        CGRect maxFrame = [self.cellFrames.lastObject CGRectValue];
        CGFloat contentMaxX = CGRectGetMaxX(maxFrame);
        self.scroll.contentSize = CGSizeMake(contentMaxX + self.edgeInset.right, self.scroll.bounds.size.height);
        [self updateReusableCell];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateReusableCell];
}

//滑动的时候复用cell的celue
- (void)updateReusableCell{
    CGFloat currentOffset = self.scroll.contentOffset.x;
    _lastOffestX = currentOffset;
    NSUInteger numberOfCells = self.cellFrames.count;
    for (NSInteger i = 0; i < numberOfCells; i++) {
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        LCHorizontalTableViewCell *cell = nil;
        cell = self.displayingCells[@(i)];
        if ([self isInScreen:cellFrame]){
            if (!cell) {
                cell = [self.dataSource tableView:self cellAtIndex:i];
                cell.frame = cellFrame;
                cell.tag = i;
                self.displayingCells[@(i)] =  cell;
                [self.scroll addSubview:cell];
            }
        } else{
            if (cell) {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                [self.reusableCells addObject:cell];
            }
        }
    }
}

//判断一个fame有无显示在屏幕上
- (BOOL)isInScreen:(CGRect)frame {
    return (CGRectGetMaxX(frame) > self.scroll.contentOffset.x) &&
    (CGRectGetMinX(frame) < self.scroll.contentOffset.x + self.bounds.size.width);
}

- (void)registerClass:(Class )cellClass forCellReuseIdentifier:(NSString *)identifier{
    self.mapDict[identifier] = NSStringFromClass(cellClass);
}

//从复用的池子里取出cell
- (LCHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSInteger )index{
    Class cellClass = NSClassFromString(self.mapDict[identifier]);
    __block LCHorizontalTableViewCell *reusableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(LCHorizontalTableViewCell* cell, BOOL *stop) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) {
        [self.reusableCells removeObject:reusableCell];
    } else {
        reusableCell = [[cellClass alloc]initWithFrame:[self getCellFrameWithIndex:index]];
        reusableCell.reuseIdentifier = identifier;
        reusableCell.delegate = self;
    }
    return reusableCell;
}

- (CGRect )getCellFrameWithIndex:(NSInteger)index{
    NSInteger preIndex = 0;
    CGRect frame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(tableView:widthForColumAtIndex:)]) {
        CGFloat currentCellWidth = ceil([self.delegate tableView:self widthForColumAtIndex:index]);
        if (index == 0) {
            CGFloat cellX =  self.edgeInset.left;
            frame = CGRectMake(cellX, self.edgeInset.top, currentCellWidth, self.scroll.frame.size.height);
        } else {
            preIndex = index - 1;
            CGRect preCellFrame = [self.cellFrames[preIndex] CGRectValue];
            frame = CGRectMake(CGRectGetMaxX(preCellFrame) + self.innerSpace, self.edgeInset.top, currentCellWidth, self.scroll.frame.size.height);
        }
    }
    return frame;
}

#pragma  mark  - LCHorizontalTableViewCellDelegate

- (void)didSelectCellAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndex:)]) {
        [self.delegate  tableView:self didSelectRowAtIndex:index];
    }
}

@end
