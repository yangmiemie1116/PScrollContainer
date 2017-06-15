//
//  ViewController.m
//  PSCrollContainerDemo
//
//  Created by 杨志强 on 2017/6/8.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "PScrollViewController.h"
#import "ConfigObj.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PScrollViewController *scrollContainer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 0, 80, 80);
    button.center = self.view.center;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitle:@"NEXT" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor brownColor];
    [button addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonDown {
    self.scrollContainer = [[PScrollViewController alloc] initScrollEvent:^(NSInteger page) {
        [self.tableView reloadData];
    } createTableView:^{
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.scrollContainer.tableView = self.tableView;
    }];
    self.scrollContainer.config = [[ConfigObj alloc] init];
    [self.navigationController pushViewController:self.scrollContainer animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"index %@", @(indexPath.row)];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
