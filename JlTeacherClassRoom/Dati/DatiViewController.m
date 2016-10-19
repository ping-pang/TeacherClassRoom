//
//  DatiViewController.m
//  JlTeacherClassRoom
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 app. All rights reserved.
//

#import "DatiViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MBProgressController.h"
#import "UserModel.h"
#import "LoginViewController.h"
@interface DatiViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)WebViewJavascriptBridge * bridge;
@property(nonatomic,strong)UIWebView * DatiWebview;

@end



@implementation DatiViewController

{
    UISegmentedControl *segment;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HEXCOLOR(0x51c095);
    [self addNavigationViewWithLeftImg:nil title:@"" rightImg:nil];
    [self createTopButton];
    [self topBtnClick:segment];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CLog(@"加载成功");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createTopButton{

    
    NSArray *segmentArray = @[@"班级统计",@"课程统计"];
    segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
    [segment setTintColor:[UIColor whiteColor]];

    segment.frame = CGRectMake(Screen_Width/2-100, 30,200, 25);
    [segment addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    [self.view addSubview:segment];
    
}


-(void)topBtnClick:(UISegmentedControl *)sender{
    if (!_DatiWebview) {
        
        self.DatiWebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height -64)];
        self.DatiWebview.delegate = self;
        self.DatiWebview.scalesPageToFit=YES;
        [self.view addSubview:self.DatiWebview];
    }
    
    NSString *strurl = @"";
    if (sender.selectedSegmentIndex == 0) {
        
        
        strurl=[NSString stringWithFormat:@"%@ssk-fzkt/mWeb/prepareAnswer4Teacher.html",HTTP_UTL];
        
    }else{
        
        strurl=[NSString stringWithFormat:@"%@ssk-fzkt/mWeb/learningAnswerCharts4Teacher.html",HTTP_UTL];
    }
    
    [_DatiWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]]];
    [WebViewJavascriptBridge enableLogging];
    _bridge =[[WebViewJavascriptBridge alloc]init];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.DatiWebview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"~%@",dic);
        /*
         *  timeOut   ->    toLogin
         */
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{@"userId":[[UserModel sharedUser]uid],@"S":[[UserModel sharedUser]my_cookie]}];//传值

}


-(void)toLogin{
    [[MBProgressController sharedInstance]showWithText:@""];
    
    [RequestManage getRequestLoginOut:[UserModel sharedUser] AppCode:@"" complete:^(NSDictionary *dic) {
        [[MBProgressController sharedInstance]hide];
        BOOL isSuceess=[dic[@"success"]boolValue];
        if (isSuceess) {
            [[AppPreFerence sharedAppPreference] setUserLoggedin:NO];
            [[AppPreFerence sharedAppPreference] setPwdRemembered:NO];
            [[AppPreFerence sharedAppPreference] setLoginAutomatically:NO];
            [[AppPreFerence sharedAppPreference] saveToLocal];
            UserModel * model=[UserModel sharedUser];
            model.uid=@"";
            model.password=@"";
            [model saveToLocal];
            
            [self addLogin];
        }else{
            CLog(@"退出失败");
        }
    } fail:^{
        [[MBProgressController sharedInstance]hide];
    }];
}

- (void)addLogin{
    LoginViewController * log=[[LoginViewController alloc]init];
    log.blockEnterMain=^(){
       
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:log animated:YES completion:nil];
}

@end
