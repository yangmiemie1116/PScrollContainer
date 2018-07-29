//
//  PScrollViewController.m
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "PScrollViewController.h"
#import "Masonry.h"
#import "PScrollViewConfig.h"
#define Iphone6Width_Sheep 375.0f
#define RGB_Sheep(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#define Sheep_NaviHeight [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height

@interface PScrollViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *stateLine;
@property (nonatomic, strong) UIButton *unfoldButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableDictionary *registerViewDict;
@property (nonatomic, strong) NSMutableDictionary *reuseViewDict;
@end

@implementation PScrollViewController
@synthesize selectIndex = _selectIndex;
CGFloat AdaptNorm(CGFloat fitInput) {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat multiple = bounds.size.width/Iphone6Width_Sheep;
    return fitInput * multiple;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reuseViewDict = @{}.mutableCopy;
        self.registerViewDict = @{}.mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    [self initTopScrollView];
    self.stateLine = [UIView new];
    [self.topScrollView addSubview:self.stateLine];
    [self createUnfoldButton];
    [self initCollectionView];
}

- (NSInteger)selectIndex {
    CGFloat offset_x = self.collectionView.contentOffset.x;
    NSInteger index = offset_x / self.view.bounds.size.width;
    return index;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    BOOL animated = NO;
    if ([self.config respondsToSelector:@selector(enableScroll)]) {
        animated = [self.config enableScroll];
    }
    [self.collectionView setContentOffset:CGPointMake(selectIndex*self.collectionView.frame.size.width, 0) animated:animated];
}

- (void)expendButtonDown {
    if ([self.delegate respondsToSelector:@selector(didTapExpandButton)]) {
        [self.delegate didTapExpandButton];
    }
}

#pragma mark - 创建展开按钮
- (void)createUnfoldButton {
    CGFloat extendWidth = 35;
    if ([self.config respondsToSelector:@selector(extendButton)]) {
        self.unfoldButton = [self.config extendButton];
        self.unfoldButton.hidden = YES;
        [self.unfoldButton addTarget:self action:@selector(expendButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.unfoldButton];
        if ([self.config respondsToSelector:@selector(buttonWidth)]) {
            extendWidth = [self.config buttonWidth];
        }
        self.unfoldButton.frame = CGRectMake(CGRectGetWidth(self.topScrollView.frame)-extendWidth, 0, extendWidth, CGRectGetHeight(self.topScrollView.frame));
    }
}

#pragma mark - 初始化顶部分类scrollview
- (void)initTopScrollView {
    CGFloat scrollHeight = AdaptNorm(46);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self.config respondsToSelector:@selector(categoryHeight)]) {
        scrollHeight = [self.config categoryHeight];
    }
    if ([self.config respondsToSelector:@selector(categoryBgColor)]) {
        self.topScrollView.backgroundColor = [self.config categoryBgColor];
    }
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollHeight)];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.topScrollView];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.topScrollView addSubview:self.containerView];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topScrollView.frame)-0.5, self.view.frame.size.width, 0.5)];
    if ([self.config respondsToSelector:@selector(separateLineColor)]) {
        self.bottomLine.backgroundColor = [self.config separateLineColor];
    } else {
        self.bottomLine.backgroundColor = RGB_Sheep(0xe5e5e5);
    }
    [self.view addSubview:self.bottomLine];
}

#pragma mark - 顶部分类按钮
- (UIButton*)createClassifyButton:(NSString*)buttonTitle index:(NSInteger)index preButton:(UIButton*)preButton {
    FillType fillType = FillTypeEqually;
    if ([self.config respondsToSelector:@selector(fillType)]) {
        fillType = [self.config fillType];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.tag = index;
    if ([self.config respondsToSelector:@selector(textFont)]) {
        button.titleLabel.font = [self.config textFont];
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:AdaptNorm(14)];
    }
    CGFloat button_width = 0;
    CGSize button_size = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    if (fillType == FillTypeEqually) {
        button_width = self.view.frame.size.width / [self.datasouce numberOfRows];
    } else {
        button_width = button_size.width + 2;
    }
    UIColor *normal = RGB_Sheep(0x9b9b99);
    if ([self.config respondsToSelector:@selector(textNormalColor)]) {
        normal = [self.config textNormalColor];
    }
    if (index == 0) {
        normal = RGB_Sheep(0x4c4c4c);
        if ([self.config respondsToSelector:@selector(textHighLightColor)]) {
            normal = [self.config textHighLightColor];
        }
    }
    [button setTitleColor:normal forState:UIControlStateNormal];
    [button addTarget:self action:@selector(naviButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:button];
    CGFloat gap_margin = 0;
    if ([self.config respondsToSelector:@selector(gap_margin)]) {
        gap_margin = [self.config gap_margin];
    }
    CGFloat scrollHeight = AdaptNorm(46);
    if ([self.config respondsToSelector:@selector(categoryHeight)]) {
        scrollHeight = [self.config categoryHeight];
    }
    CGFloat leftMargin = AdaptNorm(14);
    if ([self.config respondsToSelector:@selector(left_margin)]) {
        leftMargin = [self.config left_margin];
    }
    if (preButton) {
        button.frame = CGRectMake(CGRectGetMaxX(preButton.frame)+gap_margin, 0, button_width, scrollHeight);
    } else {
        button.frame = CGRectMake(leftMargin, 0, button_width, scrollHeight);
    }
    UILabel *redLab = [self unreadLab];
    [button addSubview:redLab];
    if (self.unreadCountArray.count > index) {
        NSString *text = self.unreadCountArray[index];
        if (text.length > 0) {
            redLab.text = text;
            [self p_layoutUnreadLabel:redLab count:text parent:button];
        }
    }
    return button;
}

#pragma mark - 更新状态线的frame
- (void)updateStatusLineFrame:(UIButton*)relativeButton animated:(BOOL)animated {
    FillType fillType = FillTypeEqually;
    if ([self.config respondsToSelector:@selector(fillType)]) {
        fillType = [self.config fillType];
    }
    CGFloat lineHeight = 3;
    if ([self.config respondsToSelector:@selector(highlightLineHeight)]) {
        lineHeight = [self.config highlightLineHeight];
    }
    self.stateLine.backgroundColor = [self.config respondsToSelector:@selector(highlightLineColor)] ? [self.config highlightLineColor] : RGB_Sheep(0xffdb4c);
    CGFloat lineWidth = 0;
    if (fillType == FillTypeEqually) {
        lineWidth = self.view.frame.size.width / [self.datasouce numberOfRows];
    } else {
        lineWidth = relativeButton.frame.size.width;
    }
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.stateLine.frame = CGRectMake(CGRectGetMinX(relativeButton.frame), CGRectGetHeight(self.topScrollView.frame)-lineHeight, lineWidth, lineHeight);
        }];
    } else {
        self.stateLine.frame = CGRectMake(CGRectGetMinX(relativeButton.frame), CGRectGetHeight(self.topScrollView.frame)-lineHeight, lineWidth, lineHeight);
    }
}

#pragma mark - 创建扩展按钮
- (void)updateExpandButtonFrame {
    CGFloat extendWidth = 35;
    if ([self.config respondsToSelector:@selector(buttonWidth)]) {
        extendWidth = [self.config buttonWidth];
    }
    if (self.topScrollView.contentSize.width > self.view.bounds.size.width) {
        if (self.unfoldButton) {
            self.unfoldButton.hidden = NO;
            CGRect oldContainerFrame = self.containerView.frame;
            self.topScrollView.contentSize = CGSizeMake(self.topScrollView.contentSize.width+self.unfoldButton.frame.size.width+5, self.topScrollView.contentSize.height);
            self.containerView.frame = CGRectMake(CGRectGetMinX(oldContainerFrame), CGRectGetMinY(oldContainerFrame), self.topScrollView.contentSize.width, CGRectGetHeight(oldContainerFrame));
        }
    } else {
        if (self.unfoldButton) {
            self.unfoldButton.hidden = YES;
        }
    }
}

#pragma mark - 未读消息数
- (UILabel*)unreadLab {
    UILabel *redLab = [UILabel new];
    redLab.backgroundColor = [UIColor colorWithRed:1.000 green:0.310 blue:0.125 alpha:1.000];
    redLab.layer.cornerRadius = 8;
    redLab.textAlignment = NSTextAlignmentCenter;
    redLab.font = [UIFont systemFontOfSize:13];
    redLab.textColor = [UIColor whiteColor];
    redLab.layer.masksToBounds = YES;
    redLab.hidden = YES;
    return redLab;
}

#pragma mark - 初始化collectionview
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = [self.config respondsToSelector:@selector(enableScroll)] ? [self.config enableScroll] : YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.topScrollView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.topScrollView.frame));
}

#pragma mark - 更新未读消息数
- (void)setUnreadCountArray:(NSArray *)unreadCountArray {
    _unreadCountArray = unreadCountArray;
    [self p_updateUnread];
}

- (void)p_updateUnread {
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *buttonSubs = button.subviews;
        for (UILabel *unreadLab in buttonSubs) {
            if ([unreadLab isMemberOfClass:[UILabel class]]) {
                if (self.unreadCountArray.count > idx) {
                    NSString *count = self.unreadCountArray[idx];
                    if (count.length > 0) {
                        unreadLab.text = count;
                        [self p_layoutUnreadLabel:unreadLab count:count parent:button];
                    }
                }
            }
        }
    }];
}

- (void)p_layoutUnreadLabel:(UILabel*)unreadLab count:(NSString*)count parent:(UIButton*)parent{
    if ([count isEqualToString:@"0"]) {
        unreadLab.hidden = YES;
    } else {
        unreadLab.hidden = NO;
    }
    if (count.integerValue > 99) {
        unreadLab.text = @"99+";
        [unreadLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(parent.titleLabel.mas_right);
            make.top.equalTo(parent.titleLabel).offset(-5);
            make.width.equalTo(@30);
            make.height.equalTo(@16);
        }];
    } else if (count.integerValue >= 10) {
        [unreadLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(parent.titleLabel.mas_right);
            make.top.equalTo(parent.titleLabel).offset(-5);
            make.width.equalTo(@22);
            make.height.equalTo(@16);
        }];
    } else if (count.integerValue < 10 && count.integerValue > 0) {
        [unreadLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(parent.titleLabel.mas_right);
            make.top.equalTo(parent.titleLabel).offset(-5);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
    } else {
        [unreadLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(parent.titleLabel.mas_right);
            make.top.equalTo(parent.titleLabel).offset(-5);
            make.width.equalTo(@22);
            make.height.equalTo(@16);
        }];
    }
}

#pragma mark - 分类按钮点击事件
- (void)naviButtonDown:(UIButton*)button {
    NSInteger tag = button.tag;
    BOOL animated = YES;
    if ([self.config respondsToSelector:@selector(enableScroll)]) {
        animated = [self.config enableScroll];
    }
    if (!animated) {
        [self.collectionView reloadData];
    }
    [self.collectionView setContentOffset:CGPointMake(tag*self.collectionView.frame.size.width, 0) animated:animated];
}

#pragma mark - reloadData
- (void)reloadContainer {
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat scrollHeight = AdaptNorm(46);
    if ([self.config respondsToSelector:@selector(categoryHeight)]) {
        scrollHeight = [self.config categoryHeight];
    }
    CGFloat rightMargin = AdaptNorm(14);
    if ([self.config respondsToSelector:@selector(right_margin)]) {
        rightMargin = [self.config right_margin];
    }
    if ([self.datasouce respondsToSelector:@selector(numberOfRows)]) {
        NSInteger count = [self.datasouce numberOfRows];
        UIButton *preButton = nil;
        for (NSInteger index = 0; index < count; index++) {
            NSString *buttonTitle = [self.datasouce titleForRow:index];
            preButton = [self createClassifyButton:buttonTitle index:index preButton:preButton];
        }
        self.topScrollView.contentSize = CGSizeMake(CGRectGetMaxX(preButton.frame)+rightMargin, scrollHeight);
    }
    NSInteger index = 0;
    if ([self.datasouce respondsToSelector:@selector(defaultSelectedIndex)]) {
        index = [self.datasouce defaultSelectedIndex];
    }
    self.containerView.frame = CGRectMake(0, 0, self.topScrollView.contentSize.width, scrollHeight);
    [self updateStatusLineFrame:self.containerView.subviews.firstObject animated:NO];
    [self updateExpandButtonFrame];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(index * self.collectionView.frame.size.width, 0)];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offset_x = scrollView.contentOffset.x;
        NSInteger index = offset_x / self.view.bounds.size.width;
        if (index < 0) {
            index = 0;
        } else if (index >= [self.datasouce numberOfRows]-1) {
            index = [self.datasouce numberOfRows]-1;
        }
        UIButton *current_button = self.containerView.subviews[index];
        [self updateStatusLineFrame:current_button animated:YES];
        CGFloat mod = fmod(offset_x, self.view.frame.size.width);
        if (mod==0) {
            NSInteger final_index = offset_x / self.view.bounds.size.width;
            [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.config respondsToSelector:@selector(textNormalColor)]) {
                    [obj setTitleColor:[self.config textNormalColor] forState:UIControlStateNormal];
                } else {
                    [obj setTitleColor:RGB_Sheep(0x9b9b99) forState:UIControlStateNormal];
                }
            }];
            UIButton *now_button = self.containerView.subviews[final_index];
            if ([self.config respondsToSelector:@selector(textHighLightColor)]) {
                [now_button setTitleColor:[self.config textHighLightColor] forState:UIControlStateNormal];
            } else {
                [now_button setTitleColor:RGB_Sheep(0x4c4c4c) forState:UIControlStateNormal];
            }
            CGFloat des_center = now_button.frame.origin.x - (self.view.center.x-now_button.frame.size.width/2)+self.containerView.frame.origin.x;
            CGFloat max_offset = self.topScrollView.contentSize.width - CGRectGetWidth(self.topScrollView.frame);
            if (des_center > max_offset) {
                des_center = max_offset;
            }
            if (des_center > 0) {
                [self.topScrollView setContentOffset:CGPointMake(des_center, 0) animated:YES];
            } else {
                [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
    }
}

- (void)registerClass:(Class)class reuseIdentifier:(NSString *)identify {
    self.registerViewDict[NSStringFromClass(class)] = identify;
}

- (UIView*)dequeueReusableWithReuseIdentifier:(NSString *)identify {
    UIView *reuseVuew = self.reuseViewDict[identify];
    if ([reuseVuew isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return reuseVuew;
}

#pragma mark - collectionView delegate && dataSource
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self p_cellConfig:cell indexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(willDisplayIndex:currentView:)]) {
        [self.delegate willDisplayIndex:indexPath.row currentView:cell.contentView.subviews.firstObject];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datasouce numberOfRows];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, collectionView.frame.size.height);
}

- (void)p_cellConfig:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    BOOL hasContentView = cell.contentView.subviews.count > 0;
    NSArray *registerKeys = self.registerViewDict.allKeys;
    NSAssert(registerKeys.count>0, @"call registerClass: reuseIdentifier: ");
    NSArray *registerValues = self.registerViewDict.allValues;
    if (hasContentView) {
        UIView *contentView = cell.contentView.subviews.firstObject;
        NSString *classString = NSStringFromClass(contentView.class);
        NSInteger index = [registerKeys indexOfObject:classString];
        NSString *identify = [registerValues objectAtIndex:index];
        self.reuseViewDict[identify] = cell.contentView.subviews.firstObject;
    }
    if ([self.datasouce respondsToSelector:@selector(scrollContainer:viewForRowAtIndex:)]) {
        UIView *contentView = [self.datasouce scrollContainer:self viewForRowAtIndex:indexPath.row];
        if (!hasContentView && contentView) {
            NSString *classString = NSStringFromClass(contentView.class);
            NSInteger index = [registerKeys indexOfObject:classString];
            NSString *identify = [registerValues objectAtIndex:index];
            self.reuseViewDict[identify] = [NSNull null];
            [cell.contentView addSubview:contentView];
            contentView.frame = CGRectZero;
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(@0);
                make.width.height.equalTo(cell.contentView);
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
