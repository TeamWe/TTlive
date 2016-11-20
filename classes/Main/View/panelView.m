//
//  panelView.m
//  test
//
//  Created by User on 15/1/23.
//  Copyright (c) 2015年 wzl. All rights reserved.
//

#import "panelView.h"

@implementation panelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    
//    UIVisualEffectView   
    /*不加裁剪以及 hitTest的话超出的部分也能响应事件
     *加了roundBtn.layer.masksToBounds = YES;之后也tm也能响应事件
     *
     *还是hitTest牛逼。
     *
     */
    UIButton *roundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    roundBtn.frame = CGRectMake(self.frame.size.width / 2 - 30, -30, 60, 60);
    roundBtn.backgroundColor = [UIColor blueColor];
        [roundBtn setImage:[UIImage imageNamed:@"mg_room_btn_jidu_n"] forState:UIControlStateNormal];
    roundBtn.layer.cornerRadius = 30;
    roundBtn.tag = 101;
    [self addSubview:roundBtn];
    _roundBtn = roundBtn;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 15, 30, 30);
    leftBtn.backgroundColor = [UIColor yellowColor];
    leftBtn.tag = 102;
    [self addSubview:leftBtn];
    _leftBtn = leftBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.frame.size.width - 30, 15, 30, 30);
    rightBtn.backgroundColor = [UIColor yellowColor];
    rightBtn.tag = 103;
    [self addSubview:rightBtn];
    _rightBtn = rightBtn;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = nil;

    BOOL pointInRound = [self touchPointInsideCircle:_roundBtn.center radius:30 targetPoint:point];
    if (pointInRound) {
        hitView = _roundBtn;
    } else if(CGRectContainsPoint(_leftBtn.frame, point)) {
        hitView  = _leftBtn;//如果在这个范围内放回左button
    } else if(CGRectContainsPoint(_rightBtn.frame, point)) {
        hitView = _rightBtn;//同上
    } else if(CGRectContainsPoint(self.frame, point)){
        hitView = self;//其余情况下返回自己的试图控制就是在这里面重写。touchesbagan-重复的位置会相应button。
    }
    return hitView;//这样子每个子视图都可以相应自己的控制，响应者都有自己的响应方法。---很厉害！！
}

- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    return (dist <= radius);
}


@end
