//
//  SecondViewController.m
//  TestWKWebview_JS
//
//  Created by 赵铭 on 2017/12/29.
//  Copyright © 2017年 zm. All rights reserved.
//

#import "SecondViewController.h"
#import <WebKit/WebKit.h>

@interface SecondViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong)WKWebView * webView;

@end

@implementation SecondViewController

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

- (void)loadRequest{
    NSString * s = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:s]];
    [self.webView loadRequest:request];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNativeApiToJS];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"shareTitle"];
}
- (void)addNativeApiToJS
{
    //防止频繁IO操作，造成性能影响
    static NSString *nativejsSource;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nativejsSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NativeApi" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    });
    //添加自定义的脚本
    WKUserScript *js = [[WKUserScript alloc] initWithSource:nativejsSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:js];
    //注册回调
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"shareTitle"];
}

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
