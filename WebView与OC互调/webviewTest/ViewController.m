//
//  ViewController.m
//  webviewTest
//
//  Created by lzhl_iOS on 2017/12/8.
//  Copyright © 2017年 lzhl_iOS. All rights reserved.
//

#import "ViewController.h"
#import "JSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface ViewController () <UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeWeb];
}

- (IBAction)OCAndJSCLickAction:(id)sender {
    
    JSViewController *jsVC = [JSViewController new];
    [self.navigationController pushViewController:jsVC animated:YES];
}

- (IBAction)UIWebviewOCAndJS:(id)sender {
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showTitleMessage('%@')",@"WebView oc调用了js的内容"]];
}

/** 以下是 UIWebView 与 OC 的交互 */
-(void)makeWeb {
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height - 400)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    NSString *webPath = [[NSBundle mainBundle] pathForResource:@"ocandjs" ofType:@"html"];
    NSURL *webURL = [NSURL fileURLWithPath:webPath];
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:webURL];
    [self.webView loadRequest:URLRequest];
    [self.view addSubview:self.webView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    JSContext *content = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    content[@"bdgtasdw"] = ^() {
        NSLog(@"js调用oc---------begin--------");
        NSArray *thisArr = [JSContext currentArguments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (JSValue *jsValue in thisArr) {
                
                UIAlertView * messAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",jsValue] delegate:nil cancelButtonTitle:@"yes"otherButtonTitles:nil,nil];
                [messAlert show];
            }
        });
        
        NSLog(@"js调用oc---------The End-------");
    };
}

@end
