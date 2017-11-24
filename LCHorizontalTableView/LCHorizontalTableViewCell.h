//
//  LCHorizontalTableviewCell.h
//  LCHorizontalTableView
//
//  Created by licong on 2017/11/6.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCHorizontalTableViewCellDelegate<NSObject>

- (void)didSelectCellAtIndex:(NSInteger )index;

@end

@interface LCHorizontalTableViewCell : UIView
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, weak) id <LCHorizontalTableViewCellDelegate> delegate;
- (void)setup;

@end
