//
//  ViewController.m
//  SegmentControl
//
//  Created by MyMac on 16/1/23.
//  Copyright © 2016年 MyMac. All rights reserved.
//

#import "ViewController.h"

#import "SegmentControl.h"

@interface ViewController ()

@property (nonatomic,strong) SegmentControl *segementControl;
@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segementControl = [[SegmentControl alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44) titleItems:self.titlesArray selectedBlock:^(NSInteger index){
        
    } normalTitleColor:nil selectedTitleColor:nil lineViewColor:nil bottomLineViewColor:nil];
    
    [self.view addSubview:self.segementControl];
    
    
}

- (NSArray*)titlesArray
{
    if (nil == _titlesArray) {
        _titlesArray = @[@"周", @"月", @"季", @"年", @"总排行"];
    }
    return _titlesArray;
}


@end
