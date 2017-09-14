//
//  ConfigObj.m
//  PSCrollContainerDemo
//
//  Created by 杨志强 on 2017/6/14.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "ConfigObj.h"
#define RGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
@implementation ConfigObj
- (NSArray<NSString *>*)categoryTitles {
    return @[@"我关注的", @"最近下单",@"我看过的",@"粉丝",@"黑名单"];
}

- (NSInteger)selectPage {
    return 0;
}

- (CGFloat)right_margin {
    return 0;
}

- (BOOL)enableScroll {
    return NO;
}

- (BOOL)contentOffsetAnimation {
    return NO;
}

- (UIButton*)extendButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"cart_arrow_down_able"] forState:UIControlStateNormal];
    return button;
}

- (CGFloat)buttonWidth {
    return [UIImage imageNamed:@"cart_arrow_down_able"].size.width+26;
}

@end
