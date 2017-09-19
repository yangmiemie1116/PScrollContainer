//
//  SecViewController.m
//  PSCrollContainerDemo
//
//  Created by 杨志强 on 2017/6/16.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "SecViewController.h"
#import "Masonry.h"
#import "PScrollViewController.h"
#import "ConfigObj.h"
@interface SecViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PScrollViewController *scrollContainer;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    NSMutableArray *originArr = @[@[@"1",@"1",@"1",@"1",@"1"], @[@"2",@"2",@"2",@"2",@"2"], @[@"3",@"3",@"3",@"3",@"3"], @[@"4",@"4",@"4",@"4",@"4"], @[@"5",@"5",@"5",@"5",@"5"]].mutableCopy;
    self.dataArray = [originArr[0] mutableCopy];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollContainer = [[PScrollViewController alloc] init];
    __weak SecViewController *weakSelf = self;
    self.scrollContainer.createContentView = ^UIView * _Nonnull(NSInteger index) {
        weakSelf.dataArray = [originArr[index] mutableCopy];
        UITableView *tableView = [[UITableView alloc] initWithFrame:weakSelf.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        tableView.delegate = weakSelf;
        tableView.dataSource = weakSelf;
        tableView.tableFooterView = [UIView new];
        return tableView;
    };
    self.scrollContainer.reloadData = ^(UIView * _Nonnull contentView, NSInteger index) {
        weakSelf.dataArray = [originArr[index] mutableCopy];
        if ([contentView isKindOfClass:[UITableView class]]) {
            [(UITableView*)contentView reloadData];
        }
    };
    self.scrollContainer.extendButtonAction = ^{
        
    };
    self.scrollContainer.config = [[ConfigObj alloc] init];
    [self addChildViewController:self.scrollContainer];
    [self.view addSubview:self.scrollContainer.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat width = self.scrollContainer.contentWidth;
    self.scrollContainer.selectIndex = 2;
    NSInteger index = self.scrollContainer.selectIndex;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"index %@", self.dataArray[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
