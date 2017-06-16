//
//  PScrollViewController.h
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PScrollViewConfig.h"
@interface PScrollViewController : UIViewController
@property (nonatomic, strong, nonnull) id<PScrollViewConfig> config;
@property (nonatomic, copy) void(^ _Nullable reloadData)(UITableView * _Nonnull tableView, NSInteger index);
@property (nonatomic, copy) UITableView *_Nonnull(^ _Nullable createTableView)(NSInteger index);
@end
