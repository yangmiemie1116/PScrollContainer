//
//  PScrollViewController.h
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PScrollViewConfig;

@protocol PSContainerDelegate<NSObject>
- (void)reloadContainer:(UIView* _Nonnull)containerView viewForRowAtIndex:(NSInteger)index;
@optional
/**
 展开按钮点击事件
 */
- (void)didTapExpandButton;
@end

@protocol PSContainerDataSource<NSObject>
- (UIView* _Nonnull)containerView:(UICollectionView* _Nonnull)collectionView viewForRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfRows;
- (NSString* _Nonnull)titleForRow:(NSInteger)row;
- (NSInteger)selectedIndex;
@end

@interface PScrollViewController : UIViewController
@property (nonatomic, assign) NSInteger selectIndex;//选中的index
/**
 每个title都可以设置一个未读消息数
 */
@property (nonatomic, strong) NSArray <NSString*>* _Nullable unreadCountArray;
@property (nonatomic, weak) id <PSContainerDelegate> _Nullable delegate;
@property (nonatomic, weak) id <PSContainerDataSource> _Nullable datasouce;
@property (nonatomic, strong, nonnull) id<PScrollViewConfig> config;
- (void)reloadContainer;

@property (nonatomic, copy) void(^ _Nullable reloadData)(UIView * _Nonnull contentView, NSInteger index) __deprecated;
@property (nonatomic, copy) UIView *_Nonnull(^ _Nullable createContentView)(NSInteger index) __deprecated;
@end

