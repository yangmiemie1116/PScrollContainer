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
@property (nonatomic, copy) void(^block)(NSInteger page);
@end

@implementation PScrollViewController

- (instancetype)initWithConfig:(void (^)(NSInteger))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
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
        button.tag = idx;
        [button addTarget:self action:@selector(naviButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.stackView addArrangedSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.topScrollView).offset(-[self.config topLineHeight]);
        }];
    }];
    UIButton *sub_button = self.stackView.arrangedSubviews[0];
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [self.config topLineColor];
    [self.topScrollView addSubview:self.bottomLine];
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

- (void)naviButtonDown:(UIButton*)button {
    NSInteger tag = button.tag;
    [self.collectionView setContentOffset:CGPointMake(tag*self.collectionView.frame.size.width, 0) animated:YES];
    [self executeBolck:tag];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offset_x = scrollView.contentOffset.x;
        NSInteger index = offset_x / self.view.bounds.size.width;
        if (index < 0) {
            index = 0;
        } else if (index >= [self.config scrollNavigationTitles].count-2) {
            index = [self.config scrollNavigationTitles].count-2;
        }
        CGFloat relative_x = offset_x - index * self.view.bounds.size.width;
        CGFloat offset_percent = (CGFloat)(relative_x / self.view.bounds.size.width);
        UIButton *current_button = self.stackView.arrangedSubviews[index];
        UIButton *next_button = self.stackView.arrangedSubviews[index+1];
        CGFloat center_offset = next_button.center.x - current_button.center.x;
        CGFloat width_offset = next_button.frame.size.width - current_button.frame.size.width;
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(current_button).offset(center_offset*offset_percent);
            make.width.equalTo(@(current_button.frame.size.width+width_offset*offset_percent));
            make.height.equalTo(@([self.config topLineHeight]));
            make.bottom.equalTo(self.topScrollView);
        }];
        
        CGFloat mod = fmod(offset_x, self.view.frame.size.width);
        if (mod==0) {
            UIButton *current_button = self.stackView.arrangedSubviews[index];
            CGFloat center_x = current_button.center.x;
            CGFloat des_center = center_x - self.view.center.x;
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset_x = scrollView.contentOffset.x;
    NSInteger page = offset_x / self.view.bounds.size.width;
    [self executeBolck:page];
}

- (void)executeBolck:(NSInteger)page {
    if (self.block) {
        self.block(page);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.config scrollNavigationTitles].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PSCollectionCell.class) forIndexPath:indexPath];
    BOOL hasContentView = [cell.subviews containsObject:cell.contentView];
    if (!hasContentView) {
        [cell addSubview:cell.contentView];
    }
    [cell.contentView addSubview:self.tableView];
    self.tableView.frame = CGRectZero;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-[self.config topNavigationHeight]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
