//
//  PScrollViewConfig.h
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FillType) {
    FillTypeEqually=1,       //根据frame均分
    FillTypeProportionally //根据内容适配
};
@protocol PScrollViewConfig <NSObject>
/**
 顶部分类按钮列表

 @return array
 */
- (NSArray<NSString *>*)categoryTitles;

@optional

/**
 默认选中状态, start from 0

 @return 0
 */
- (NSInteger)selectPage;

/**
 按钮填充方式
 
 @return 0
 */
- (FillType)fillType;

/**
 顶部分类的高度

 @return default 46
 */
- (CGFloat)categoryHeight;

/**
 顶部高亮线的高度
 
 @return default 3
 */
- (CGFloat)highlightLineHeight;

/**
 顶部分类字体大小
 
 @return font
 */
- (UIFont*)textFont;

/**
stackView 距离父视图左边距离

 @return 15
 */
- (CGFloat)left_margin;

/**
 stackView 距离父视图右边距离

 @return 15
 */
- (CGFloat)right_margin;

/**
 stackView 子视图间距
 @return 0
 */
- (CGFloat)gap_margin;

/**
 顶部分割线的颜色
 
 @return color
 */
- (UIColor*)separateLineColor;

/**
 顶部分类字体颜色
 
 @return color
 */
- (UIColor*)textNormalColor;

/**
 顶部分类字体高亮颜色
 
 @return color
 */
- (UIColor*)textHighLightColor;

/**
 顶部状态线的颜色
 
 @return color
 */
- (UIColor*)highlightLineColor;

/**
 是否允许左右滑动

 @return default YES
 */
- (BOOL)enableScroll;

/**
 设置collectionView的偏移时，是否animated

 @return default YES
 */
- (BOOL)contentOffsetAnimation;

/**
 分类导航条扩展按钮，展示在最右边
 @return button
 */
- (UIButton*)extendButton;

/**
 扩展按钮的宽度
 @return width
 */
- (CGFloat)buttonWidth;
@end
