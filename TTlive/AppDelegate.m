//
//  AppDelegate.m
//  TTlive
//
//  Created by jiguang on 16/11/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "ViewController.h"
#import "TTMainViewController.h"

#define TENCENT_CONNECT_APP_KEY @"1105729575"
#define WEIBO_CONNECT_APP_KEY @"403559393"

@interface AppDelegate ()<QQApiInterfaceDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    if([[NSUserDefaults standardUserDefaults]stringForKey:@"openId"].length > 0)
//        _window.rootViewController = [ViewController new];
//    else
    UINavigationController *rootNV = [[UINavigationController alloc]initWithRootViewController:[TTMainViewController new]];
    _window.rootViewController = rootNV;
    
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[TencentOAuth alloc] initWithAppId:TENCENT_CONNECT_APP_KEY andDelegate:self];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBO_CONNECT_APP_KEY];
    //    NSLog(@"%@",oauth.appId);
    return YES;
}

#pragma mark WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
    NSLog(@"%@",content); //这里会返回 一些Base Info
}
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@",response);
}
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"%@",result);
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    /**
     处理由手Q唤起的跳转请求
     \param url 待处理的url跳转请求
     \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
     \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
     */
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
        
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    /**
     处理由手Q唤起的跳转请求
     \param url 待处理的url跳转请求
     \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
     \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
     */
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"wb%@",WEIBO_CONNECT_APP_KEY]]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    /**
     处理由手Q唤起的跳转请求
     \param url 待处理的url跳转请求
     \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
     \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
     */
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"wb%@",WEIBO_CONNECT_APP_KEY]]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
}
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    NSLog(@" ----req %@",req);
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    NSLog(@" ----resp %@",resp);
    
    // SendMessageToQQResp应答帮助类
    if ([resp.class isSubclassOfClass: [SendMessageToQQResp class]]) {  //QQ分享回应
        if (_qqDelegate) {
            if ([_qqDelegate respondsToSelector:@selector(shareSuccssWithQQCode:)]) {
                SendMessageToQQResp *msg = (SendMessageToQQResp *)resp;
                NSLog(@"code %@  errorDescription %@  infoType %@",resp.result,resp.errorDescription,resp.extendInfo);
                [_qqDelegate shareSuccssWithQQCode:[msg.result integerValue]];
            }
        }
    }
}
/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{
    
}


#pragma mark deal weibo response

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}


- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
        NSLog(@"accessToken is:%@",[(WBAuthorizeResponse *)response accessToken]);
        NSLog(@"userID is:%@",[(WBAuthorizeResponse *)response userID]);
        NSLog(@"wbRefreshToken is:%@",[(WBAuthorizeResponse *)response refreshToken]);
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        [params setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"access_token"];
        [params setObject:[(WBAuthorizeResponse *)response userID] forKey:@"uid"];
        NSLog(@"params:%@", params);
        
        WBHttpRequest * asiRequest = [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:params delegate:self withTag:@"getUserInfo"];
        
        [alert show];
    }
    NSLog(@"%@",response);
}


@end
