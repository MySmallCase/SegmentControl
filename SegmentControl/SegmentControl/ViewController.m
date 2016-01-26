//
//  ViewController.m
//  SegmentControl
//
//  Created by MyMac on 16/1/23.
//  Copyright © 2016年 MyMac. All rights reserved.
//

#import "ViewController.h"

#import "SegmentControl.h"
#import <iCarousel.h>

#import "Test1ListView.h"
#import "Test2ListView.h"

@interface ViewController ()<iCarouselDataSource,iCarouselDelegate>

@property (nonatomic,strong) SegmentControl *segementControl;
@property (strong, nonatomic) NSArray *titlesArray;

@property (nonatomic,strong) iCarousel *myCarousel;


@property (nonatomic,strong) NSArray *Test1ListViewArray;

@property (nonatomic,strong) NSArray *Test2ListViewArray;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加Carousel
    self.myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.myCarousel.delegate = self;
    self.myCarousel.dataSource = self;
    self.myCarousel.decelerationRate = 1.0;
    self.myCarousel.scrollSpeed = 1.0;
    self.myCarousel.type = iCarouselTypeLinear;
    self.myCarousel.pagingEnabled = YES;
    self.myCarousel.clipsToBounds = YES;
    self.myCarousel.bounceDistance = 0.2;
//    self.myCarousel.wrapEnabled = YES;
    [self.view addSubview:self.myCarousel];
    
    __weak typeof(self) weakSelf = self;
    self.segementControl = [[SegmentControl alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44) titleItems:self.titlesArray selectedBlock:^(NSInteger index){
        [weakSelf.myCarousel scrollToItemAtIndex:index animated:NO];
    } normalTitleColor:nil selectedTitleColor:nil lineViewColor:nil bottomLineViewColor:nil];
    
    [self.view addSubview:self.segementControl];
    
    
}

- (NSArray*)titlesArray
{
    if (nil == _titlesArray) {
//        _titlesArray = @[@"周", @"月", @"季", @"年", @"总排行"];
        _titlesArray = @[@"周", @"月"];
    }
    return _titlesArray;
}

- (NSArray *)Test1ListViewArray {
    if (!_Test1ListViewArray) {
        _Test1ListViewArray = @[@"",@"",@"",@"",@"",@""];
    }
    return _Test1ListViewArray;
}

- (NSArray *)Test2ListViewArray {
    if (!_Test2ListViewArray) {
        _Test2ListViewArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@""];
    }
    return _Test2ListViewArray;
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.titlesArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (index == 0) {
        Test1ListView *listView = (Test1ListView *)view;
        if (!listView) {
            listView = [[Test1ListView alloc] initWithFrame:carousel.bounds];
            listView.dataArray = self.Test1ListViewArray;
        }
        return listView;
    }else {
        Test2ListView *listView = (Test2ListView *)view;
        if (!listView) {
            listView = [[Test2ListView alloc] initWithFrame:carousel.bounds];
        }
        return listView;
    }
    
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    if (self.segementControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
          [self.segementControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if (_segementControl) {
        _segementControl.currentIndex = carousel.currentItemIndex;
    }
    
    if (carousel.currentItemIndex == 0) {
        Test1ListView *listView = (Test1ListView *)carousel.currentItemView;
        listView.dataArray = @[@"",@"",@""];
    }
    
    if (carousel.currentItemIndex == 1) {
        Test2ListView *listView = (Test2ListView *)carousel.currentItemView;
        listView.dataArray = @[@"",@"",@""];
    }
    
    
}



@end
