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

- (NSInteger)selectPage {
    return 0;
}

- (CGFloat)left_margin {
    return 13;
}

- (CGFloat)right_margin {
    return 13;
}

- (BOOL)enableScroll {
    return NO;
}

- (CGFloat)gap_margin {
    return 15;
}

- (FillType)fillType {
    return FillTypeProportionally;
}

- (UIButton*)extendButton {
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.backgroundColor = [UIColor whiteColor];
    [butt setImage:[UIImage imageNamed:@"cart_arrow_down_able"] forState:UIControlStateNormal];
    return butt;
}

- (CGFloat)buttonWidth {
    return 30;
}
@end
