//
//  AutoPushViewController.m
//  JlTeacherClassRoom
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 app. All rights reserved.
//

#import "AutoPushViewController.h"
#import "PublishPushViewController.h"
#import "WebViewJavascriptBridge.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AutoPushViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *pushListWeb;
@property(nonatomic,strong)WebViewJavascriptBridge *bridge;

@end

@implementation AutoPushViewController

{
    NSString *_goodsVersion;// 商品的版本
    NSString *goodsID;
    NSString *goodsName;
}

//-(void)viewWillAppear:(BOOL)animated{
//    if (_pushListWeb) {
//        [_pushListWeb reload];
//    }
//}


-(void)creatPushListWeb{

    _pushListWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64)];
    _pushListWeb.delegate = self;
    [self.view addSubview:_pushListWeb];
    [self loadViewPushListView];
}
-(void)loadViewPushListView{
    //测试
//    NSString *strurl = [NSString stringWithFormat:@"http://128.0.4.183:8080/ssk-fzkt/mWeb/push-summary.html?t=%@&s=%@",[[UserModel sharedUser] uid],[[UserModel sharedUser]my_cookie]];
    

    NSString * strurl=[NSString stringWithFormat:@"%@ssk-fzkt/mWeb/push-summary.html?t=%@&s=%@",HTTP_UTL,[[UserModel sharedUser] uid],[[UserModel sharedUser]my_cookie]];

    
    NSLog(@"%@",strurl);
    [self.pushListWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]]];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [[WebViewJavascriptBridge alloc]init] ;
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.pushListWeb webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"dic===%@",dic);
        /*
         * 点击视频，返回视频 信息
           */
//         if ([dic[@"key"] isEqualToString:@"goodsId"]) {
//             
//             goodsID = dic[@"value"];
//            [self getGoodsId:dic[@"value"]];
//        }
        
       
        
    }];
    
//    [_bridge callHandler:@"testJavascriptHandler" data:@{@"userId":[[User sharedUser] uid],@"S":[[User sharedUser] my_cookies],@"courseId":self.courseId,@"baseOutlineId":self.outlineDetailID,@"baseOutLineDetailId":self.baseOutlineId}];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationViewWithLeftImg:nil title:@"我的推送" rightImg:nil];
    [self.navView.rightButton setTitle:@"推送" forState:UIControlStateNormal];
    [self creatPushListWeb];

}

- (void)rightBtnClick:(UIButton *)sender
{
    PublishPushViewController *public = [[PublishPushViewController alloc]init];
     [self.navigationController pushViewController:public animated:YES];
    [public returnReload:^(NSString *str) {
        if (_pushListWeb) {
            CLog(@"%@",str);
            [_pushListWeb reload];
        }
    }];
    
   
   
}

- (void)back:(UIButton *)sender
{
    
    
    if ([self.pushListWeb canGoBack]) {
        [self.pushListWeb goBack];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获取视频播放链接
-(void)getGoodsId:(NSString *)goodId{
    NSDictionary *dic = @{@"userId":[[UserModel sharedUser] uid],@"S":[[UserModel sharedUser] my_cookie],@"goodsId":goodId,@"osVer":@"05",@"mobileType":@"02"};
    CLog(@"paramss:%@",dic);
//朱
    NSString *urlStr = @"http://128.0.3.32:8080/ssk-fzkt/mobile/exec?m=getGoodsInfo";
    
 //王
//    NSString *urlStr =  @"http://128.0.4.183/ssk-fzkt/mobile/exec?m=getGoodsInfo";
    
//    NSString *urlStr =[NSString stringWithFormat:@"%@ssk-fzkt/mobile/exec?m=getGoodsInfo",HTTP_UTL];
    
    [[HTTPManage shareInstance]afpostRequsetWithUrl:urlStr withPariermet:dic success:^(id responseObject) {

        CLog(@"what are you nong sha lai :::%@::%@",responseObject,responseObject[@"message"]);
        
        if ([[responseObject objectForKey:@"success"] boolValue])
        {
            NSDictionary *data = [[responseObject objectForKey:@"data"] objectAtIndex:0];
            NSString *goodsId = [data objectForKey:@"goodsId"];
            
            if ([data objectForKey:@"isNullCode"])
            {
                if ([[data objectForKey:@"isNullCode"] isEqualToString:@"01"])
                {
                    [self addAlertTitle:@"提示" withMessage:@"敬请期待" withConfirmbtn:@"确定" withCancelBtn:nil withAlertTag:500 withDelegate:nil];
                    return ;
                }
            }
//            BOOL goodExist = [[LocalDataManager sharedLocalDataManager] goodsExistInLocal:goodsId];
//            if (goodExist)
//            {
//                __weak NSString *version = [data objectForKey:@"goodsVer"];
//                __weak NSString *l_version = [[LocalDataManager sharedLocalDataManager] getVersionWithGoodsId:goodsId];
//                // 判断是否从本地读取数据
//                if ([version isEqualToString:l_version])
//                {
//                    /* 调用本地读取函数 */
//                    [self loadDataWithCode:[JLFactory getCodeInfoFromLocal:goodsId] fromLocal:YES
//                               withCodeNum:nil withGoodsID:goodsId];
//                    return;
//                }
//            }
            // 从网上获取数据
            [self getQrContentInfo:nil withGoodsID:goodsId withVersion:[data objectForKey:@"goodsVer"]];
        }else{
            [self addAlertTitle:@"提示" withMessage:[responseObject objectForKey:@"message"] withConfirmbtn:@"确定" withCancelBtn:nil withAlertTag:500 withDelegate:nil];
        }
        
    } fail:^{
        [[MBProgressController sharedInstance]showTipsOnlyText:@"faile" AndDelay:2];
        
    }];

}

- (void)getQrContentInfo:(NSString *)codeNumber withGoodsID:(NSString *)goods_id withVersion:(NSString *)version
{
    NSDictionary *dic = @{@"userId":[[UserModel sharedUser] uid],@"S":[[UserModel sharedUser] my_cookie],@"goodsId":goods_id,@"osVer":@"05",@"mobileType":@"02"};
    NSString *path = [NSString stringWithFormat:@"http://128.0.3.32:8080/ssk-fzkt/mobile/exec?m=getGoodsRes"];
    [[HTTPManage shareInstance]afpostRequsetWithUrl:path withPariermet:dic success:^(id responseObject) {
        CLog(@"耳机联动%@",responseObject);
    } fail:^{
        CLog(@"get secon list is fail");
    }];
}

@end
