//
//  PSCollectionCell.m
//  PSCrollContainerDemo
//
//  Created by sheep on 2017/6/9.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "PSCollectionCell.h"

@implementation PSCollectionCell
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    BOOL hasContentView = [self.subviews containsObject:self.contentView];
    if (hasContentView) {
        [self.contentView removeFromSuperview];
    }
}

@end
