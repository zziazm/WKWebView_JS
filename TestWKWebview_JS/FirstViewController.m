//
//  FirstViewController.m
//  TestWKWebview_JS
//
//  Created by 赵铭 on 2017/12/29.
//  Copyright © 2017年 zm. All rights reserved.
//

#import "FirstViewController.h"

#import <WebKit/WebKit.h>

@interface FirstViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong)WKWebView * webView;

@end

@implementation FirstViewController

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
    NSString * s = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:s]];
    [self.webView loadRequest:request];
}

#pragma mark -- WKUIDelegate

#pragma mark -- WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURLRequest *request = [navigationAction request];
    NSString * scheme = request.URL.scheme;
    NSString * host = request.URL.host;
    NSString * query = request.URL.query;
    if ([scheme isEqualToString:@"test1"]) {
        NSString *methodName = host;
        if (query) {
            methodName = [methodName stringByAppendingString:@":"];
        }
        SEL sel = NSSelectorFromString(methodName);
        NSString *parameter = [[query componentsSeparatedByString:@"="] lastObject];
        [self performSelector:sel withObject:parameter];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
        
    }else if ([scheme isEqualToString:@"test2"]){//JS中的是Test2,在拦截到的url scheme全都被转化为小写。
        NSURL *url = request.URL;
        NSArray *params =[url.query componentsSeparatedByString:@"&"];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (NSString *paramStr in params) {
            NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
            if (dicArray.count > 1) {
                NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [tempDic setObject:decodeValue forKey:dicArray[0]];
            }
        }
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式一" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"tempDic:%@",tempDic);
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showToast {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"JS调用OC代码成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showToastWithParameter:(NSString *)parama {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:[NSString stringWithFormat:@"JS调用OC代码成功 - JS参数：%@",parama] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
