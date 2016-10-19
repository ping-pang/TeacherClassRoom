//
//  MianViewController.m
//  JlTeacherClassRoom
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 app. All rights reserved.
//

#import "MianViewController.h"
#import "YuxiViewController.h"
#import "DatiViewController.h"
#import "TeacherAnserViewController.h"
#import "InteractionViewController.h"
#import "AutoPushViewController.h"
#import "MBProgressController.h"
#import "MianNavViewController.h"
#import "AppPreFerence.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "RequestManage.h"
#import "SettingViewController.h"
@interface MianViewController (){
    MBProgressHUD*_hud;

}
@end

@implementation MianViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=HEXCOLOR(0x51c095);
    if (![[AppPreFerence sharedAppPreference] userLoggedin]) {
        [self automatiacLogin];
    }
    if (wCurrentScreen4) {
        self.yuxi_top_cons.constant-=(20+64);
        self.yuxi_w_cons.constant-=40;
        self.yuxi_h_cons.constant-=40;
        
        self.dati_top_cons.constant-=10;
        self.dati_h_cons.constant-=40;
        self.dati_w_cons.constant-=40;
    }if (wCurrentScreen5) {
        self.yuxi_top_cons.constant-=(0+64);
        self.yuxi_w_cons.constant-=40;
        self.yuxi_h_cons.constant-=40;
        
        self.dati_top_cons.constant-=10;
        self.dati_h_cons.constant-=40;
        self.dati_w_cons.constant-=40;
    }if (wCurrentScreen6) {
        self.yuxi_top_cons.constant-=(0+20);
    }if (wCurrentScreen6p) {
        self.yuxi_top_cons.constant-=(0+20);
    }
}
#pragma mark------自动登录------
- (void)automatiacLogin{
    
    __weak UserModel *user = [UserModel sharedUser];
    
    // 会员自动登录
    if ([[AppPreFerence sharedAppPreference] loginAutomatically] && user.log_name.length!=0 &&user.password.length !=0)
    {
        CLog(@"自动登录");
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.square = YES;//设置显示框的高度和宽度一样
        [_hud show:YES];
        [RequestManage getRequestLoginWithUserName:user.log_name Password:user.password AppCode:@"TEACHER_APP" complete:^(NSDictionary *dic) {
            if (dic) {
                BOOL isSuccess=[dic[@"success"]boolValue];
                if(!isSuccess){
                    _hud.hidden=YES;
                    _hud=nil;
                    [[AppPreFerence sharedAppPreference] setUserLoggedin:NO];
                    [[AppPreFerence sharedAppPreference]saveToLocal];
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                    [self addLogin];//////////自动登录失败后再登陆
                    
                }else{
                    CLog(@"自动登录成功");
                    _hud.hidden=YES;
                    _hud=nil;
                    UserModel * user=[UserModel sharedUser];
                    NSArray * dataArr=dic[@"data"];
                    if (dataArr.count>0) {
                        NSDictionary *dataDic=dataArr[0];
                        user.userName=dataDic[@"userName"];
                        user.my_cookie=dataDic[@"S"];
                        user.uid=dataDic[@"userId"];
                        user.log_name=dataDic[@"loginName"];
                    }
                    [user saveToLocal];
                    AppPreFerence * appFerence=[AppPreFerence sharedAppPreference];
                    [appFerence setUserLoggedin:YES];
                    appFerence.loginAutomatically=YES;
                    [appFerence saveToLocal];
                    
                }
            }}fail:^{
                _hud.hidden=YES;
                _hud=nil;
            }];
    }
}
#pragma mark----跳转预习统计
- (IBAction)pushYuxi:(id)sender {
    YuxiViewController *vc=[[YuxiViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark----跳转答题统计
- (IBAction)pushDati:(id)sender {
    DatiViewController * vc=[[DatiViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------我的解答  // select
- (IBAction)pushReplay:(id)sender {
//    TeacherAnserViewController *vc = [[TeacherAnserViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---推送
- (IBAction)pushAutoPush:(id)sender {
//    [[MBProgressController sharedInstance]showTipsOnlyText:@"敬请期待" AndDelay:2];
    AutoPushViewController *vc = [[AutoPushViewController alloc]initWithNibName:@"AutoPushViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ----课程互动
- (IBAction)pushInteraction:(id)sender {
    TeacherAnserViewController *vc = [[TeacherAnserViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)loginout:(id)sender {
    
    SettingViewController *setVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
    

}

- (void)addLogin{
    
    LoginViewController * log=[[LoginViewController alloc]init];
    log.blockEnterMain=^(){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:log animated:YES completion:nil];
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
