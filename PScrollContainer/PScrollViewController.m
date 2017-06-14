//
//  PScrollViewController.m
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "PScrollViewController.h"
#import "PSCollectionCell.h"
#import "Masonry.h"
@interface PScrollViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation PScrollViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.config navigaitonBarTitle];
    self.view.backgroundColor = [UIColor grayColor];
    [self setupView];
}

- (void)setupView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topScrollView = [[UIScrollView alloc] init];
    self.topScrollView.backgroundColor = [UIColor whiteColor];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.topScrollView];
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@64);
        make.height.equalTo(@([self.config topNavigationHeight]));
    }];
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.distribution = UIStackViewDistributionFillProportionally;
    self.stackView.spacing = [self.config stack_space];
    [self.topScrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset([self.config stack_space]);
        make.right.equalTo(self.topScrollView).offset(-[self.config stack_space]);
        make.top.bottom.equalTo(self.topScrollView);
    }];
    [[self.config scrollNavigationTitles] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.stackView addArrangedSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.topScrollView).offset(-[self.config topLineHeight]);
        }];
    }];
    UIButton *sub_button = self.stackView.arrangedSubviews[0];
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [self.config topLineColor];
    [self.view addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sub_button);
        make.width.equalTo(sub_button);
        make.height.equalTo(@([self.config topLineHeight]));
        make.bottom.equalTo(self.topScrollView);
    }];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[PSCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass(PSCollectionCell.class)];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger max_index = [self.config scrollNavigationTitles].count-1;
        CGFloat offset_x = scrollView.contentOffset.x;
        NSInteger index = offset_x / self.view.bounds.size.width;
        if (index >= 0 && index < max_index) {
            UIButton *des_button = self.stackView.arrangedSubviews[index+1];
            CGFloat center_x = des_button.center.x;
            CGFloat center_offset = center_x - self.view.center.x;
            if (center_offset > 0) {
                [self.topScrollView setContentOffset:CGPointMake(center_offset, 0) animated:YES];
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.config scrollNavigationTitles].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PSCollectionCell.class) forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-[self.config topNavigationHeight]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
