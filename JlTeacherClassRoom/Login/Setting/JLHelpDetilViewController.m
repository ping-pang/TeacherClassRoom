//
//  JLHelpDetilViewController.m
//  JLClassroom
//
//  Created by JingLun on 15/6/30.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "JLHelpDetilViewController.h"
#import "MBProgressHUD.h"

@interface JLHelpDetilViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView * contentView;

@end

@implementation JLHelpDetilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addNavigationViewWithLeftImg:nil title:@"帮助详情" rightImg:nil];
    _contentView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-navHeight-20)];
    _contentView.delegate=self;
//    [_contentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.wassk.cn/ssk-fzkt/mobile/exec?m=getQaInfo&userId=790152&S=1b664e4f-9db7-45ee-bf34-37921463d790&businessSysId=2&qaId=10"]]];
    [self.view addSubview:_contentView];
    NSString *str = [self.contentDic objectForKey:@"qaAnswer"];
   
    [self.contentView loadHTMLString:str baseURL:nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_contentView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
    [_contentView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 300, 50)];
    errorLabel.text = @"对不起，亲，页面不存在的......";
    errorLabel.textAlignment = NSTextAlignmentLeft;
    errorLabel.font = [UIFont systemFontOfSize:16.0];
    errorLabel.backgroundColor = [UIColor clearColor];
    [webView addSubview:errorLabel];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"Loading...";
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
