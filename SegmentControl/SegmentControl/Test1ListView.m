//
//  Test1ListView.m
//  SegmentControl
//
//  Created by MyMac on 16/1/24.
//  Copyright © 2016年 MyMac. All rights reserved.
//

#import "Test1ListView.h"

@interface Test1ListView()<UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation Test1ListView {
    NSArray *_dataArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        [self addSubview:self.tableView];
    }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
    
    NSLog(@"1111");
    
    
}


#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.bounds;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor redColor];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Test1ListView====%ld",(long)indexPath.row];
    
    return cell;
}



@end
