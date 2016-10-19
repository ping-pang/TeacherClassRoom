//
//  YuxiViewController.m
//  JlTeacherClassRoom
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 app. All rights reserved.
//

#import "YuxiViewController.h"
#import "WebViewJavascriptBridge.h"
#import "UserModel.h"
#import "MBProgressController.h"
@interface YuxiViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webview;

@property(nonatomic,strong)UIWebView *reportWeb;

@property(nonatomic,strong)WebViewJavascriptBridge * bridge;
@end

@implementation YuxiViewController

{

    UISegmentedControl *segment;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HEXCOLOR(0x51c095);
    
    [self addNavigationViewWithLeftImg:@"pic_back" title:@"" rightImg:nil];
    [self createTopButton];

    [self topBtnClick:segment];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CLog(@"加载成功了");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}



-(void)createTopButton{

    NSArray *segmentArray = @[@"班级统计",@"课程统计"];
    segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
    [segment setTintColor:[UIColor whiteColor]];
    segment.frame = CGRectMake(Screen_Width/2-100, 30, 200, 25);
    [segment addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    [self.view addSubview:segment];
    
    
    
}


-(void)topBtnClick:(UISegmentedControl *)seg{
    if (!_reportWeb) {
    
    self.reportWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height -64)];
        self.reportWeb.delegate = self;
        [self.view addSubview:self.reportWeb];
    }
   
 NSString *strurl = @"";
    if (seg.selectedSegmentIndex == 0) {

        strurl=[NSString stringWithFormat:@"%@ssk-fzkt/mWeb/prepare4Teacher.html",HTTP_UTL];
    }else{

        strurl=[NSString stringWithFormat:@"%@ssk-fzkt/mWeb/learningTimeCharts4Teacher.html",HTTP_UTL];
    }
   
    
    // 253
    
//    NSString *strurl = [NSString stringWithFormat:@"%@ssk-fzkt/mWeb/courseExplain.html",HTTP_UTL];
    
 
    [_reportWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]]];
    [WebViewJavascriptBridge enableLogging];
    _bridge =[[WebViewJavascriptBridge alloc]init];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.reportWeb webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"~%@",dic);
            
        }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{@"userId":[[UserModel sharedUser]uid],@"S":[[UserModel sharedUser]my_cookie]}];//传值

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
