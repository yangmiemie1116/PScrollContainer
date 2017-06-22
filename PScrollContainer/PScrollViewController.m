//
//  PScrollViewController.m
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "PScrollViewController.h"
#import "Masonry.h"
#define Iphone6Width_Sheep 375.0f
#define RGB_Sheep(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
@interface PScrollViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *stateLine;
@end

@implementation PScrollViewController

CGFloat AdaptNorm(CGFloat fitInput) {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat multiple = bounds.size.width/Iphone6Width_Sheep;
    return fitInput * multiple;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    //MARK:init top category scrollView
    self.topScrollView = [[UIScrollView alloc] init];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.topScrollView];
    CGFloat scrollHeight = AdaptNorm(46);
    if ([self.config respondsToSelector:@selector(categoryHeight)]) {
        scrollHeight = [self.config categoryHeight];
    }
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@64);
        make.height.equalTo(@(scrollHeight));
    }];
    
    CGFloat leftMargin = AdaptNorm(14);
    CGFloat rightMargin = AdaptNorm(14);
    if ([self.config respondsToSelector:@selector(left_margin)]) {
        leftMargin = [self.config left_margin];
    }
    if ([self.config respondsToSelector:@selector(right_margin)]) {
        rightMargin = [self.config right_margin];
    }
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.distribution = UIStackViewDistributionFillProportionally;
    CGFloat gap = AdaptNorm(25);
    if ([self.config respondsToSelector:@selector(gap_margin)]) {
        gap = [self.config gap_margin];
    }
    self.stackView.spacing = gap;
    [self.topScrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(leftMargin);
        make.right.equalTo(self.topScrollView).offset(-rightMargin);
        make.top.bottom.equalTo(self.topScrollView);
    }];
    
    self.bottomLine = [UIView new];
    if ([self.config respondsToSelector:@selector(separatorColor)]) {
        self.bottomLine.backgroundColor = [self.config separateLineColor];
    } else {
        self.bottomLine.backgroundColor = RGB_Sheep(0xe5e5e5);
    }
    [self.view addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.topScrollView);
    }];
    
    CGFloat lineHeight = 3;
    if ([self.config respondsToSelector:@selector(highlightLineHeight)]) {
        lineHeight = [self.config highlightLineHeight];
    }
    [[self.config categoryTitles] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:obj forState:UIControlStateNormal];
        button.tag = idx;
        if ([self.config respondsToSelector:@selector(textFont)]) {
            button.titleLabel.font = [self.config textFont];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:AdaptNorm(14)];
        }
        UIColor *normal = RGB_Sheep(0x9b9b99);
        if ([self.config respondsToSelector:@selector(textNormalColor)]) {
            normal = [self.config textNormalColor];
        }
        if (idx == 0) {
            normal = RGB_Sheep(0x4c4c4c);
            if ([self.config respondsToSelector:@selector(textHighLightColor)]) {
                normal = [self.config textHighLightColor];
            }
        }
        [button setTitleColor:normal forState:UIControlStateNormal];
        [button addTarget:self action:@selector(naviButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.stackView addArrangedSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.topScrollView);
        }];
    }];
    UIButton *sub_button = self.stackView.arrangedSubviews[0];
    self.stateLine = [UIView new];
    self.stateLine.backgroundColor = [self.config respondsToSelector:@selector(highlightLineColor)] ? [self.config highlightLineColor] : RGB_Sheep(0xffdb4c);
    [self.topScrollView addSubview:self.stateLine];
    [self.stateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sub_button);
        make.width.equalTo(sub_button);
        make.height.equalTo(@(lineHeight));
        make.bottom.equalTo(self.topScrollView);
    }];
    
    //MARK: init collectionView
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
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    NSInteger page = 0;
    if ([self.config respondsToSelector:@selector(selectPage)]) {
        page = [self.config selectPage] > ([self.config categoryTitles].count-1) ? 0 : [self.config selectPage];
    }
    [self.view layoutIfNeeded];
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.frame.size.width, 0)];
    [self generateCellContent:0];
}

- (void)naviButtonDown:(UIButton*)button {
    NSInteger tag = button.tag;
    BOOL animated = YES;
    if ([self.config respondsToSelector:@selector(contentOffsetAnimation)]) {
        animated = [self.config contentOffsetAnimation];
    }
    [self.collectionView setContentOffset:CGPointMake(tag*self.collectionView.frame.size.width, 0) animated:animated];
}

- (void)generateCellContent:(NSInteger)index {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    __block BOOL hasContentView = NO;
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            hasContentView = YES;
        }
    }];
    if (!hasContentView) {
        if (self.createTableView) {
            UITableView *tableView = self.createTableView(index);
            [cell.contentView addSubview:tableView];
            tableView.frame = CGRectZero;
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(@0);
                make.width.height.equalTo(cell.contentView);
            }];
        }
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat lineHeight = 3;
        if ([self.config respondsToSelector:@selector(highlightLineHeight)]) {
            lineHeight = [self.config highlightLineHeight];
        }
        CGFloat offset_x = scrollView.contentOffset.x;
        NSInteger index = offset_x / self.view.bounds.size.width;
        if (index < 0) {
            index = 0;
        } else if (index >= [self.config categoryTitles].count-2) {
            index = [self.config categoryTitles].count-2;
        }
        CGFloat relative_x = offset_x - index * self.view.bounds.size.width;
        CGFloat offset_percent = (CGFloat)(relative_x / self.view.bounds.size.width);
        UIButton *current_button = self.stackView.arrangedSubviews[index];
        UIButton *next_button = self.stackView.arrangedSubviews[index+1];
        CGFloat center_offset = next_button.center.x - current_button.center.x;
        CGFloat width_offset = next_button.frame.size.width - current_button.frame.size.width;
        [self.view layoutIfNeeded];
        [self.stateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(current_button).offset(center_offset*offset_percent);
            make.width.equalTo(@(current_button.frame.size.width+width_offset*offset_percent));
            make.height.equalTo(@(lineHeight));
            make.bottom.equalTo(self.topScrollView);
        }];
        if ([self.config respondsToSelector:@selector(contentOffsetAnimation)]) {
            if (![self.config contentOffsetAnimation]) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.view layoutIfNeeded];
                }];
            }
        }
        CGFloat mod = fmod(offset_x, self.view.frame.size.width);
        if (mod==0) {
            NSInteger final_index = offset_x / self.view.bounds.size.width;
            [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.config respondsToSelector:@selector(textNormalColor)]) {
                    [obj setTitleColor:[self.config textNormalColor] forState:UIControlStateNormal];
                } else {
                    [obj setTitleColor:RGB_Sheep(0x9b9b99) forState:UIControlStateNormal];
                }
            }];
            UIButton *now_button = self.stackView.arrangedSubviews[final_index];
            if ([self.config respondsToSelector:@selector(textHighLightColor)]) {
                [now_button setTitleColor:[self.config textHighLightColor] forState:UIControlStateNormal];
            } else {
                [now_button setTitleColor:RGB_Sheep(0x4c4c4c) forState:UIControlStateNormal];
            }
            CGFloat des_center = now_button.frame.origin.x - (self.view.center.x-now_button.frame.size.width/2)+self.stackView.frame.origin.x;
            CGFloat max_offset = self.topScrollView.contentSize.width - CGRectGetWidth(self.topScrollView.frame);
            if (des_center > max_offset) {
                des_center = max_offset;
            }
            if (des_center > 0) {
                [self.topScrollView setContentOffset:CGPointMake(des_center, 0) animated:YES];
            } else {
                [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            [self generateCellContent:final_index];
        }
    }
}

#pragma mark - collectionView delegate && dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.config categoryTitles].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    __block BOOL hasContentView = NO;
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            hasContentView = YES;
            if (self.reloadData) {
                self.reloadData(obj, indexPath.row);
            }
        }
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, collectionView.frame.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
