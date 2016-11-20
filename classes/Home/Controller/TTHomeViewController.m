//
//  TTHomeViewController.m
//  TTlive
//
//  Created by jiguang on 16/11/19.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "TTHomeViewController.h"
#import "TTVedioViewController.h"

@interface TTHomeViewController ()

@end

@implementation TTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    /*
     *自定义navigation
     *
     */
    
    self.navigationController.navigationBarHidden = YES;
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 44)];
    aView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:aView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:aView.bounds];
    label.text = @"This is new navigation bar";
    label.textAlignment = NSTextAlignmentCenter;
    [aView addSubview:label];
    
}


- (void)clickButton{
    TTVedioViewController *vedioVC = [TTVedioViewController new];
    [self.navigationController pushViewController:vedioVC animated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
