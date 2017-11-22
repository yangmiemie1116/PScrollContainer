//
//  PScrollViewController.h
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PScrollViewConfig;
@class PScrollViewController;
#pragma mark - delegate
@protocol PSContainerDelegate<NSObject>
@optional
- (void)willDisplayIndex:(NSInteger)index currentView:(UIView* _Nullable)currentView;
/**
 展开按钮点击事件
 */
- (void)didTapExpandButton;
@end
#pragma mark - datasouce
@protocol PSContainerDataSource<NSObject>
/**
 创建容器内的view
 
 @param index row
 @return contentView
 */
- (UIView* _Nonnull)scrollContainer:(PScrollViewController* _Nonnull)scrollContainer viewForRowAtIndex:(NSInteger)index;

/**
 容器的页数

 @return number
 */
- (NSInteger)numberOfRows;

/**
 title

 @param row row
 @return title
 */
- (NSString* _Nonnull)titleForRow:(NSInteger)row;
@optional
/**
默认选中的page
 
 @return index
 */
- (NSInteger)defaultSelectedIndex;
@end

@interface PScrollViewController : UIViewController
@property (nonatomic, weak) id <PSContainerDelegate> _Nullable delegate;
@property (nonatomic, weak) id <PSContainerDataSource> _Nullable datasouce;
/**
 一些界面元素的配置信息
 */
@property (nonatomic, strong, nonnull) id<PScrollViewConfig> config;

/**
 当前所在page
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 每个title都可以设置一个未读消息数
 */
@property (nonatomic, strong) NSArray <NSString*>* _Nullable unreadCountArray;

/**
 刷新整个容器
 */
- (void)reloadContainer;

/**
 注册一个类

 @param class 注册类
 @param identify 注册类的标记
 */
- (void)registerClass:(Class _Nonnull)class reuseIdentifier:(NSString *_Nonnull)identify;

/**
 重用注册的类

 @param identify 注册类的标记
 @return 重用注册的类
 */
- (UIView* _Nullable)dequeueReusableWithReuseIdentifier:(NSString *_Nonnull)identify;
@end

