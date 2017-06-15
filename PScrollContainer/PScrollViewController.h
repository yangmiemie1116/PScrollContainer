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
@property (nonatomic, strong, nonnull) UITableView *tableView;
- (instancetype _Nullable )initScrollEvent:(void(^_Nullable)(NSInteger page))scrollEvent createTableView:(void(^_Nullable)())createTableView;
@end