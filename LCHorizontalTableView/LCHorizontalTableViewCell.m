//
//  LCHorizontalTableviewCell.m
//  LCHorizontalTableView
//
//  Created by licong on 2017/11/6.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "LCHorizontalTableViewCell.h"

@implementation LCHorizontalTableViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = UIColor.redColor;
    self.label = [[UILabel alloc]init];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.text = @"测试";
    self.label.textColor = UIColor.blackColor;
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.backgroundColor = UIColor.clearColor;
    self.clipsToBounds = YES;
    [self addSubview:self.label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, self.bounds.size.width - 30, 30);
    self.label.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
    self.layer.cornerRadius = self.bounds.size.height/2;
}


- (void)tapAction:(UITapGestureRecognizer *)gesture{
    NSUInteger index = gesture.view.tag;
    if ([self.delegate respondsToSelector:@selector(didSelectCellAtIndex:)]) {
        [self.delegate didSelectCellAtIndex:index];
    }
}

@end
