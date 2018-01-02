//
//  ThirdViewController.m
//  TestWKWebview_JS
//
//  Created by 赵铭 on 2018/1/2.
//  Copyright © 2018年 zm. All rights reserved.
//

#import "ThirdViewController.h"
#import <WebKit/WebKit.h>

@interface ThirdViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong)WKWebView * webView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    configuration.userContentController = userContentController;//用于和js交互
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [self loadRequest];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"shareTitle"];
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"shareNothing"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"shareTitle"];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"shareNothing"];
}

- (void)loadRequest{
    NSString * s = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:s]];
    [self.webView loadRequest:request];
}

#pragma mark -- WKUIDelegate

#pragma mark -- WKNavigationDelegate



#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSString *name = message.name;
    id body = message.body;
    NSLog(@"%@", message.name);
    NSLog(@"%@", message.body);
    
    if ([name isEqualToString:@"shareTitle"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"JS调用OC代码成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if ([name isEqualToString:@"shareNothing"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"JS调用OC代码成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)showToast {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"JS调用OC代码成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)showToastWithParameter:(NSString *)parama {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:[NSString stringWithFormat:@"JS调用OC代码成功 - JS参数：%@",parama] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
