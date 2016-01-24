//
//  SegmentControl.m
//  SegmentControl
//
//  Created by MyMac on 16/1/23.
//  Copyright © 2016年 MyMac. All rights reserved.
//

#import "SegmentControl.h"
#import <UIImageView+WebCache.h>

#import "UIColor+Expanded.h"

#define SegmentControlItemFont (15)

#define SegmentControlHspace (0)

#define SegmentControlLineHeight (2)

#define SegmentControlAnimationTime (0.3)

#define SegmentControlIconWidth (50.0)

#define SegmentControlIconSpace (4)


typedef NS_ENUM(NSInteger, SegmentControlItemType) {
    SegmentControlItemTypeTitle = 0,
    SegmentControlItemTypeIconUrl,
    SegmentControlItemTypeTitleAndIcon,
};

/*******************   SegmentControlItem  *******************/
@interface SegmentControlItem : UIView

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *titleIconView;

@property (nonatomic,assign) SegmentControlItemType type;

@property (nonatomic,strong) UIColor *normalColor;

- (void)setSelected:(BOOL)selected normalColor:(UIColor *)normalColor selectedTitleColor:(UIColor *)selectedTitleColor;

@end


@implementation SegmentControlItem {
    UIColor *_normalTitleColor;
    UIColor *_selectedTitleColor;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title type:(SegmentControlItemType)type normalColor:(UIColor *)normalColor selectedTitleColor:(UIColor *)selectedTitleColor{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _type = type;
        _normalTitleColor = normalColor;
        _selectedTitleColor = selectedTitleColor;
        
        switch (_type) {
            case SegmentControlItemTypeIconUrl: {
                _titleIconView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-40)/2, (CGRectGetHeight(self.bounds)-40)/2, 40, 40)];
                if (title) {
                    //                    [_titleIconView sd_setImageWithURL:[NSURL URLWithString:nil] placeholderImage:nil];
                }else {
                    //                    [_titleIconView setImage:[UIImage imageNamed:nil]];
                }
                [self addSubview:_titleIconView];
                break;
            }
            case SegmentControlItemTypeTitleAndIcon: {
                _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
//                _titleLable.font = [UIFont systemFontOfSize:(kDevice_Is_iPhone6Plus) ? (XTSegmentControlItemFont + 1) : (kDevice_Is_iPhone6 ? XTSegmentControlItemFont : XTSegmentControlItemFont - 2)];
                _titleLabel.font = [UIFont systemFontOfSize:SegmentControlItemFont];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                _titleLabel.text = title;
                _titleLabel.textColor = [UIColor redColor];
                _titleLabel.backgroundColor = [UIColor clearColor];
                [_titleLabel sizeToFit];
                if (_titleLabel.frame.size.width > CGRectGetWidth(self.bounds) - SegmentControlIconSpace - 10) {
                    CGRect frame = _titleLabel.frame;
                    frame.size.width = CGRectGetWidth(self.bounds) - SegmentControlIconSpace - 10;
                    _titleLabel.frame = frame;
                }
                _titleLabel.center = CGPointMake((CGRectGetWidth(self.bounds) - SegmentControlIconSpace - 10) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
                break;
            }
            case SegmentControlItemTypeTitle:
            default: {
                
                _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SegmentControlHspace, 0, CGRectGetWidth(self.bounds) - 2 * SegmentControlHspace, CGRectGetHeight(self.bounds))];
                _titleLabel.font = [UIFont systemFontOfSize:SegmentControlItemFont];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                _titleLabel.text = title;
                _titleLabel.textColor = normalColor;
                _titleLabel.backgroundColor = [UIColor clearColor];
                
                [self addSubview:_titleLabel];
                
                break;
            }
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected normalColor:(UIColor *)normalColor selectedTitleColor:(UIColor *)selectedTitleColor
{
    switch (_type) {
        case SegmentControlItemTypeIconUrl:
        {
        }
            break;
        case SegmentControlItemTypeTitleAndIcon:
        {
            if (_titleLabel) {
                [_titleLabel setTextColor:(selected ? selectedTitleColor:normalColor)];
            }
            if (_titleIconView) {
                [_titleIconView setImage:[UIImage imageNamed: selected ? @"tag_list_down" : @"tag_list_up"]];
            }
        }
            break;
        default:
        {
            if (_titleLabel) {
                [_titleLabel setTextColor:(selected ? selectedTitleColor:normalColor)];
            }
        }
            break;
    }
}

- (void)resetTitle:(NSString *)title
{
    if (_titleLabel) {
        _titleLabel.text = title;
    }
    if (_type == SegmentControlItemTypeTitleAndIcon) {
        [_titleLabel sizeToFit];
        if (_titleLabel.frame.size.width > CGRectGetWidth(self.bounds) - SegmentControlIconSpace - 10) {
            CGRect frame = _titleLabel.frame;
            frame.size.width = CGRectGetWidth(self.bounds) - SegmentControlIconSpace - 10;
            _titleLabel.frame = frame;
        }
        _titleLabel.center = CGPointMake((CGRectGetWidth(self.bounds) - SegmentControlIconSpace - 10) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
        
        CGRect frame = _titleIconView.frame;
        frame.origin.x = CGRectGetMaxX(_titleLabel.frame) + SegmentControlIconSpace;
        _titleIconView.frame = frame;
    }
}

@end





/*******************   SegmentControl  *******************/
@interface SegmentControl ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *contentView;

@property (nonatomic , strong) UIView *leftShadowView;

@property (nonatomic , strong) UIView *rightShadowView;

@property (nonatomic , strong) UIView *lineView;

@property (nonatomic , strong) NSMutableArray *itemFrames;

@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , weak) id <SegmentControlDelegate> delegate;

@property (nonatomic , copy) SegmentControlBlock block;

@end


@implementation SegmentControl {
    UIColor *_normalTitleColor; //正常字体颜色
    UIColor *_selectedTitleColor; //选中字体颜色
    UIColor *_lineViewColor; //移动横线的颜色
    UIColor *_bottomLineViewColor; //底部横线颜色
}

- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems withIcon:(BOOL)isIcon {
    if (self = [super initWithFrame:frame]) {
        [self initUIWith:isIcon Items:titleItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems {
    if (self = [super initWithFrame:frame]) {
        [self initUIWith:NO Items:titleItems];
    }
    return self;
}

- (void)initUIWith:(BOOL)isIcon Items:(NSArray *)titleItem {
    _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.delegate = self;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.scrollsToTop = NO;
    [self addSubview:_contentView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [_contentView addGestureRecognizer:tapGes];
    [tapGes requireGestureRecognizerToFail:_contentView.panGestureRecognizer];
    
    [self initItemsWithTitleArray:titleItem withIcon:isIcon];
}


- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems delegate:(id<SegmentControlDelegate>)delegate normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor lineViewColor:(UIColor *)lineViewColor bottomLineViewColor:(UIColor *)bottomLineViewColor{
    
    _normalTitleColor = normalTitleColor == nil ? [UIColor colorWithHexString:@"555555"] : normalTitleColor;
    _selectedTitleColor = selectedTitleColor == nil ? [UIColor colorWithHexString:@"ffbd40"] : selectedTitleColor;
    _lineViewColor = lineViewColor == nil ? [UIColor colorWithHexString:@"ffbd40"] : lineViewColor;
    _bottomLineViewColor = bottomLineViewColor == nil ? [UIColor colorWithHexString:@"dddddd"] : bottomLineViewColor;
    
    self = [self initWithFrame:frame titleItems:titleItems];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems withIcon:(BOOL)isIcon selectedBlock:(SegmentControlBlock)selectedHandle normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor lineViewColor:(UIColor *)lineViewColor bottomLineViewColor:(UIColor *)bottomLineViewColor{
    
    _normalTitleColor = normalTitleColor == nil ? [UIColor colorWithHexString:@"555555"] : normalTitleColor;
    _selectedTitleColor = selectedTitleColor == nil ? [UIColor colorWithHexString:@"ffbd40"] : selectedTitleColor;
    _lineViewColor = lineViewColor == nil ? [UIColor colorWithHexString:@"ffbd40"] : lineViewColor;
    _bottomLineViewColor = bottomLineViewColor == nil ? [UIColor colorWithHexString:@"dddddd"] : bottomLineViewColor;
    
    self = [self initWithFrame:frame titleItems:titleItems withIcon:isIcon];
    if (self) {
        self.block = selectedHandle;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleItems:(NSArray *)titleItems selectedBlock:(SegmentControlBlock)selectedHandle normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor lineViewColor:(UIColor *)lineViewColor bottomLineViewColor:(UIColor *)bottomLineViewColor{
    
    _normalTitleColor = normalTitleColor == nil ? [UIColor colorWithHexString:@"555555"] : normalTitleColor;
    _selectedTitleColor = selectedTitleColor == nil ? [UIColor colorWithHexString:@"ffbd40"] : selectedTitleColor;
    _lineViewColor = lineViewColor == nil ? [UIColor colorWithHexString:@"ffbd40"] : lineViewColor;
    _bottomLineViewColor = bottomLineViewColor == nil ? [UIColor colorWithHexString:@"dddddd"] : bottomLineViewColor;
    
    self = [self initWithFrame:frame titleItems:titleItems];
    if (self) {
        self.block = selectedHandle;
    }
    return self;
}

- (void)doTap:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    
    __weak typeof(self) weakSelf = self;
    
    [_itemFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect rect = [obj CGRectValue];
        
        if (CGRectContainsPoint(rect, point)) {
            
            [weakSelf selectIndex:idx];
            
            [weakSelf transformAction:idx];
            
            *stop = YES;
        }
    }];
}

- (void)transformAction:(NSInteger)index {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SegmentControlDelegate)] && [self.delegate respondsToSelector:@selector(segmentControl:selectedIndex:)]) {
        
        [self.delegate segmentControl:self selectedIndex:index];
        
    }else if (self.block) {
        
        self.block(index);
    }
}

- (void)initItemsWithTitleArray:(NSArray *)titleArray withIcon:(BOOL)isIcon{
    _itemFrames = @[].mutableCopy;
    _items = @[].mutableCopy;
    float y = 0;
    float height = CGRectGetHeight(self.bounds);
    
    NSObject *obj = [titleArray firstObject];
    if ([obj isKindOfClass:[NSString class]]) {
        for (int i = 0; i < titleArray.count; i++) {
            float x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
            float width = [UIScreen mainScreen].bounds.size.width / titleArray.count;
            CGRect rect = CGRectMake(x, y, width, height);
            [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
        }
        
        for (int i = 0; i < titleArray.count; i++) {
            CGRect rect = [_itemFrames[i] CGRectValue];
            NSString *title = titleArray[i];
            
            SegmentControlItem *item = [[SegmentControlItem alloc] initWithFrame:rect title:title type: isIcon ?SegmentControlItemTypeTitleAndIcon : SegmentControlItemTypeTitle normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
            if (!isIcon && i == 0) {
                [item setSelected:YES normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
            }
            [_items addObject:item];
            [_contentView addSubview:item];
        }
        
    }
    
    [_contentView setContentSize:CGSizeMake(CGRectGetMaxX([[_itemFrames lastObject] CGRectValue]), CGRectGetHeight(self.bounds))];
    self.currentIndex = 0;
    [self selectIndex:0];
    if (isIcon) {
        [self selectIndex:-1];
        for (int i=1; i<_itemFrames.count; i++) {
            CGRect rect = [_itemFrames[i] CGRectValue];
            
            UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rect),(CGRectGetHeight(rect) - 14) * 0.5,1,14)];
            lineView.backgroundColor = [UIColor grayColor];
            [self addSubview:lineView];
        }
    }
}

- (void)addRedLine {
    if (!_lineView) {
        CGRect rect = [_itemFrames[0] CGRectValue];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rect),CGRectGetHeight(rect) - SegmentControlLineHeight,CGRectGetWidth(rect) - 2 * SegmentControlHspace,SegmentControlLineHeight)];
        _lineView.backgroundColor = _lineViewColor;
        [_contentView addSubview:_lineView];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rect)-0.5, CGRectGetWidth(self.bounds), 0.5f)];
        bottomLineView.backgroundColor = _bottomLineViewColor;
        [self addSubview:bottomLineView];
    }
}

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index
{
    SegmentControlItem *curItem = [_items objectAtIndex:index];
    [curItem resetTitle:title];
}

- (void)selectIndex:(NSInteger)index {
    [self addRedLine];
    if (index < 0) {
        _currentIndex = -1;
        _lineView.hidden = TRUE;
        for (SegmentControlItem *curItem in _items) {
            [curItem setSelected:NO normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
        }
    } else {
        _lineView.hidden = FALSE;
        
        if (index != _currentIndex) {
            SegmentControlItem *curItem = [_items objectAtIndex:index];
            CGRect rect = [_itemFrames[index] CGRectValue];
            CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + SegmentControlHspace, CGRectGetHeight(rect) - SegmentControlLineHeight, CGRectGetWidth(rect) - 2 * SegmentControlHspace, SegmentControlLineHeight);
            if (_currentIndex < 0) {
                _lineView.frame = lineRect;
                [curItem setSelected:YES normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
                _currentIndex = index;
            } else {
                [UIView animateWithDuration:SegmentControlAnimationTime animations:^{
                    _lineView.frame = lineRect;
                } completion:^(BOOL finished) {
                    [_items enumerateObjectsUsingBlock:^(SegmentControlItem *item, NSUInteger idx, BOOL *stop) {
                        [item setSelected:NO normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
                    }];
                    [curItem setSelected:YES normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
                    _currentIndex = index;
                }];
            }
        }
        [self setScrollOffset:index];
    }
}


- (void)moveIndexWithProgress:(CGFloat)progress {
    progress = MAX(0, MIN(progress, _items.count));
    float delta = progress - _currentIndex;
    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;
    
    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + SegmentControlHspace, CGRectGetHeight(origionRect) - SegmentControlLineHeight, CGRectGetWidth(origionRect) - 2 * SegmentControlHspace, SegmentControlLineHeight);
    
    CGRect rect;
    if (delta > 0) {
        //        如果delta大于1的话，不能简单的用相邻item间距的乘法来计算距离
        if (delta > 1) {
            self.currentIndex += floorf(delta);
            delta -= floorf(delta);
            origionRect = [_itemFrames[_currentIndex] CGRectValue];;
            origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + SegmentControlHspace, CGRectGetHeight(origionRect) - SegmentControlLineHeight, CGRectGetWidth(origionRect) - 2 * SegmentControlHspace, SegmentControlLineHeight);
        }
        
        if (_currentIndex == _itemFrames.count - 1) {
            return;
        }
        
        rect = [_itemFrames[_currentIndex + 1] CGRectValue];
        
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + SegmentControlHspace, CGRectGetHeight(rect) - SegmentControlLineHeight, CGRectGetWidth(rect) - 2 * SegmentControlHspace, SegmentControlLineHeight);
        
        CGRect moveRect = CGRectZero;
        
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) + delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) + delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _lineView.frame = moveRect;
    } else if (delta < 0){
        
        if (_currentIndex == 0) {
            return;
        }
        rect = [_itemFrames[_currentIndex - 1] CGRectValue];
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + SegmentControlHspace, CGRectGetHeight(rect) - SegmentControlLineHeight, CGRectGetWidth(rect) - 2 * SegmentControlHspace, SegmentControlLineHeight);
        CGRect moveRect = CGRectZero;
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) - delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) - delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _lineView.frame = moveRect;
        if (delta < -1) {
            self.currentIndex -= 1;
        }
    }    
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    currentIndex = MAX(0, MIN(currentIndex, _items.count));
    
    if (currentIndex != _currentIndex) {
        SegmentControlItem *preItem = [_items objectAtIndex:_currentIndex];
        SegmentControlItem *curItem = [_items objectAtIndex:currentIndex];
        [preItem setSelected:NO normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
        [curItem setSelected:YES normalColor:_normalTitleColor selectedTitleColor:_selectedTitleColor];
        _currentIndex = currentIndex;
    }
    [self setScrollOffset:currentIndex];
}

- (void)endMoveIndex:(NSInteger)index {
    [self selectIndex:index];
}

- (void)setScrollOffset:(NSInteger)index {
    if (_contentView.contentSize.width <= [UIScreen mainScreen].bounds.size.width) {
        return;
    }
    
    CGRect rect = [_itemFrames[index] CGRectValue];
    
    float midX = CGRectGetMidX(rect);
    
    float offset = 0;
    
    float contentWidth = _contentView.contentSize.width;
    
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;
    }else{
        offset = midX - halfWidth;
    }
    
    [UIView animateWithDuration:SegmentControlAnimationTime animations:^{
        [_contentView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

int ExceMinIndex(float f){
    int i = (int)f;
    if (f != i) {
        return i+1;
    }
    return i;
}

@end
