//
//  JSViewController.m
//  webviewTest
//
//  Created by lzhl_iOS on 2017/12/8.
//  Copyright © 2017年 lzhl_iOS. All rights reserved.
//

#import "JSViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface JSViewController () <WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic, strong) WKWebView *wkWeb;


@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"WKWebView";
    
    /** 加载HTML  */
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"untitled.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    
    /** 以下 方法会接受OC传给JS 的参数 之后再打印出来  */
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc]init];
    [theConfiguration.userContentController addScriptMessageHandler:self name:@"myName"];
    /** 以上 */
    
    self.wkWeb = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:theConfiguration];
    self.wkWeb.backgroundColor = [UIColor redColor];
    self.wkWeb.navigationDelegate = self;
    self.wkWeb.UIDelegate = self;
    self.wkWeb.clipsToBounds = YES;
    [self.view addSubview:self.wkWeb];
    [self.wkWeb loadRequest:request];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    /** 此方法是向JS代码传参数 */
    NSString * jsStr = [NSString stringWithFormat:@"payResult('%@')",@"OC调用JS"];
    [self.wkWeb evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"==%@----%@",result, error);
    }];
}

/**
 *  此方法会接受 JS 的alert
 *  但是 JS 的alert 不会在客户端弹出，会接受到 弹窗要弹出的数据 然后可以打印出来
 *  OC 调用 JS
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler  {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  使用此方法的回调
 *  WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc]init];
 *  [theConfiguration.userContentController addScriptMessageHandler:self name:@"myName"];
 *  JS 调用 OC
 */
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSString *str = message.body;
    UIAlertView * messAlert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"yes"otherButtonTitles:nil,nil];
    [messAlert show];
}

@end
