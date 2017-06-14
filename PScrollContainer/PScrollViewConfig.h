//
//  PScrollViewConfig.h
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol PScrollViewConfig <NSObject>
@optional
/**
 顶部导航按钮列表

 @return array
 */
- (NSArray<NSString *>*)scrollNavigationTitles;

/**
 顶部导航的高度

 @return default 46
 */
- (CGFloat)topNavigationHeight;

/**
 顶部导航线的高度
 
 @return default 3
 */
- (CGFloat)topLineHeight;

/**
 顶部导航线的颜色
 
 @return color
 */
- (UIColor*)topLineColor;

/**
 导航栏title

 @return title
 */
- (NSString*)navigaitonBarTitle;

/**
stackView 距离父视图左边距离

 @return 15
 */
- (CGFloat)stack_left;

/**
 stackView 距离父视图右边距离

 @return 15
 */
- (CGFloat)stack_right;

/**
 stackView 子视图间距
 @return 0
 */
- (CGFloat)stack_space;

/**
 顶部导航字体大小

 @return font
 */
- (UIFont*)topTitlesFont;

/**
 顶部导航字体颜色

 @return color
 */
- (UIColor*)topTitlesFontColor;

/**
 是否允许下拉刷新

 @return default YES
 */
- (BOOL)enablePullRefresh;

/**
 是否允许上拉刷新

 @return default YES
 */
- (BOOL)enableUpRefresh;

@end
