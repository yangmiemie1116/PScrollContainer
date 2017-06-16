//
//  ViewController.m
//  PSCrollContainerDemo
//
//  Created by 杨志强 on 2017/6/8.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "ViewController.h"
#import "SecViewController.h"
@interface ViewController ()
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
    SecViewController *vc = [[SecViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
