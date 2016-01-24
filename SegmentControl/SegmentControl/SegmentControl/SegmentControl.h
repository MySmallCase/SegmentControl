//
//  SegmentControl.h
//  SegmentControl
//
//  Created by MyMac on 16/1/23.
//  Copyright © 2016年 MyMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SegmentControlBlock)(NSInteger index);

@class SegmentControl;
@protocol SegmentControlDelegate <NSObject>

- (void)segmentControl:(SegmentControl *)control selectedIndex:(NSInteger)index;

@end


@interface SegmentControl : UIView

@property (nonatomic,assign) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems delegate:(id<SegmentControlDelegate>)delegate normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor lineViewColor:(UIColor *)lineViewColor bottomLineViewColor:(UIColor *)bottomLineViewColor;

- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems selectedBlock:(SegmentControlBlock)selectedHandle normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor lineViewColor:(UIColor *)lineViewColor bottomLineViewColor:(UIColor *)bottomLineViewColor;

- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems withIcon:(BOOL)isIcon selectedBlock:(SegmentControlBlock)selectedHandle normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor lineViewColor:(UIColor *)lineViewColor bottomLineViewColor:(UIColor *)bottomLineViewColor;


- (void)selectIndex:(NSInteger)index;

- (void)moveIndexWithProgress:(CGFloat)progress;

- (void)endMoveIndex:(NSInteger)index;

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index;


@end
