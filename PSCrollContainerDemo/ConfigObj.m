//
//  ConfigObj.m
//  PSCrollContainerDemo
//
//  Created by 杨志强 on 2017/6/14.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "ConfigObj.h"
@implementation ConfigObj
- (NSArray<NSString *>*)scrollNavigationTitles {
    return @[@"我关注的", @"最近下单",@"我看过的",@"粉丝",@"黑名单",@"我看过的",@"粉丝",@"黑名单"];
}

- (CGFloat)topNavigationHeight {
    return 46;
}

- (CGFloat)topLineHeight {
    return 3;
}

- (UIColor*)topLineColor {
    return [UIColor redColor];
}

- (NSString*)navigaitonBarTitle {
    return @"通讯录";
}

- (CGFloat)stack_space {
    return 25;
}

- (CGFloat)stack_left {
    return 15;
}

- (CGFloat)stack_right {
    return 15;
}

@end
