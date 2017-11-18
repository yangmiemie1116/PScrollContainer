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
@interface SecViewController ()<UITableViewDataSource, UITableViewDelegate, PSContainerDelegate, PSContainerDataSource>
@property (nonatomic, strong) PScrollViewController *scrollContainer;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *originArr;
@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.titleArray = @[@"我关注的", @"最近下单",@"我看过的",@"粉丝",@"黑名单",@"黑名单",@"黑名单",@"黑名单",@"黑名单"];
    self.originArr = @[@[@"1",@"1",@"1",@"1",@"1"], @[@"2",@"2",@"2",@"2",@"2"], @[@"3",@"3",@"3",@"3",@"3"], @[@"4",@"4",@"4",@"4",@"4"], @[@"5",@"5",@"5",@"5",@"5"]];
    self.dataArray = self.originArr[0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollContainer = [[PScrollViewController alloc] init];
    self.scrollContainer.delegate = self;
    self.scrollContainer.datasouce = self;
    self.scrollContainer.config = [[ConfigObj alloc] init];
    [self addChildViewController:self.scrollContainer];
    [self.view addSubview:self.scrollContainer.view];
    [self.scrollContainer reloadContainer];
}

- (NSString*)titleForRow:(NSInteger)row {
    return self.titleArray[row];
}

- (NSInteger)numberOfRows {
    return self.titleArray.count;
}

- (NSInteger)selectedIndex {
    return 0;
}

- (UIView*)containerView:(UICollectionView *)collectionView viewForRowAtIndex:(NSInteger)index {
    self.dataArray = self.originArr[index];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [tableView reloadData];
    return tableView;
}

- (void)reloadContainer:(UIView *)containerView viewForRowAtIndex:(NSInteger)index {
    self.dataArray = self.originArr[index];
    [(UITableView*)containerView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
