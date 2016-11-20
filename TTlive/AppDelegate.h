//
//  AppDelegate.h
//  TTlive
//
//  Created by jiguang on 16/11/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QQShareDelegate <NSObject>

-(void)shareSuccssWithQQCode:(NSInteger)code;
@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak  , nonatomic) id<QQShareDelegate> qqDelegate;

@end

