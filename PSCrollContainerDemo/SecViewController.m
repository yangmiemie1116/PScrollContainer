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
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PScrollViewController *scrollContainer;
@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    PScrollViewController *scrollContainer = [[PScrollViewController alloc] initScrollEvent:^(NSInteger page) {
        [self.tableView reloadData];
    } createTableView:^UIView * _Nonnull{
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        return self.tableView;
    }];
    scrollContainer.config = [[ConfigObj alloc] init];
    [self addChildViewController:scrollContainer];
    [self.view addSubview:scrollContainer.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"index %@", @(indexPath.row)];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
