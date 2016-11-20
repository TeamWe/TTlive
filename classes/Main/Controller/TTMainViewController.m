//
//  TTMainViewController.m
//  TTlive
//
//  Created by jiguang on 16/11/19.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "TTMainViewController.h"
#import "panelView.h"
#import "TTLiveViewController.h"
#import "TTHomeViewController.h"
#import "TTMineViewController.h"

@interface TTMainViewController (){
    TTLiveViewController *liveVC;
    TTHomeViewController *homeVC;
    TTMineViewController *mineVC;
    UIViewController *currentVC;
    panelView *panel;
}

@end

@implementation TTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChild];
    [self initViews];
}

- (void)addChild{
    liveVC = [TTLiveViewController new];
    homeVC = [TTHomeViewController new];
    mineVC = [TTMineViewController new];
    [self addChildViewController:homeVC];
    [self addChildViewController:liveVC];
    [self addChildViewController:mineVC];
    [self.view addSubview:homeVC.view];
//    [homeVC didMoveToParentViewController:self];
    currentVC = homeVC;
}


- (void)initViews
{
    panel = [[panelView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 60,
                                                                   CGRectGetWidth(self.view.frame), 60)];
    panel.tag = 100001;
    panel.backgroundColor = [UIColor grayColor];
    panel.userInteractionEnabled = YES;
//    [[UIApplication sharedApplication].windows[0] addSubview:panel];
    [currentVC.view addSubview:panel];
//    [self.view bringSubviewToFront:panel];
//    panel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [panel.roundBtn addTarget:self action:@selector(beginOurLive:) forControlEvents:UIControlEventTouchUpInside];
    [panel.leftBtn addTarget:self action:@selector(beginOurLive:) forControlEvents:UIControlEventTouchUpInside];
    [panel.rightBtn addTarget:self action:@selector(beginOurLive:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beginOurLive:(UIButton *)sender{
    if((sender.tag==101 && currentVC==liveVC) || (sender.tag==102 && currentVC==homeVC) || (sender.tag==103 && currentVC==mineVC))
        return;
    
    UIViewController *newVC;
    switch (sender.tag) {
        case 101:
            newVC = liveVC;
            break;
        case 102:
            newVC = homeVC;
            break;
        case 103:
            newVC = mineVC;
            break;
    }
    [self transitionFromViewController:currentVC toViewController:newVC duration:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
        ;
    } completion:^(BOOL finished) {
        [panel removeFromSuperview];
        [newVC.view addSubview:panel];
        currentVC = newVC;
        NSLog(@"1");
    }];
    
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"...");
//    return self.view;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
