//
//  PScrollViewController.h
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PScrollViewConfig;
@interface PScrollViewController : UIViewController
@property (nonatomic, strong, nonnull) id<PScrollViewConfig> config;
@property (nonatomic, copy) void(^ _Nullable reloadData)(UIView * _Nonnull contentView, NSInteger index);
@property (nonatomic, copy) UIView *_Nonnull(^ _Nullable createContentView)(NSInteger index);
@property (nonatomic, assign) NSInteger selectIndex;//选中的index
/**
 扩展按钮点击事件
 */
@property (nonatomic, copy) void(^ _Nullable extendButtonAction)();
@end
