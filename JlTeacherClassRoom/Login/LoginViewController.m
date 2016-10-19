//
//  LoginViewController.m
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressController.h"
#import "RequestManage.h"
#import "UserModel.h"
#import "AppPreFerence.h"

#define LOGIN_VIEW_TAG 109
@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL isKeyShow;///<是否有键盘
    BOOL isdo_log;
}
@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor whiteColor];
    isdo_log=NO;
    self.phonetf.clearButtonMode = UITextFieldViewModeWhileEditing;
    //self.phonetf.clearButtonMode = UITextFieldViewModeAlways;
    self.phonetf.delegate=self;
    self.pswtf.delegate=self;
    [self.phonetf setValue:HEXCOLOR(0x91fdd3) forKeyPath:@"_placeholderLabel.textColor"];
    [self.pswtf setValue:HEXCOLOR(0x91fdd3) forKeyPath:@"_placeholderLabel.textColor"];
    if (Screen_Width==320) {
        self.phonetf.font=[UIFont systemFontOfSize:16];
        self.pswtf.font=[UIFont systemFontOfSize:16];
        self.center_bg_top.constant-=20;
        self.teacher_topcon.constant-=20;
        self.teacher_h.constant-=10;
        self.teacher_w.constant-=20;
        self.teacherlable.font=[UIFont systemFontOfSize:22];
        
        self.logobg_h.constant-=25;
        self.logobg_w.constant-=20;
        
        self.pswtf_w.constant-=40;
        self.phonetf_w.constant-=40;
        
        self.tf_center_cons.constant-=12;
        self.tfbg_center_cons.constant-=10;
        
        self.logBtn_topCon.constant-=40;
        self.logBtn_w.constant-=50;
        self.phone_left.constant+=25;
        self.phone_right.constant+=25;
    }if (wCurrentScreen6p) {
        self.pswtf_w.constant+=10;
        self.phonetf_w.constant+=10;
    }
    NSString * phone=[[UserModel sharedUser] log_name];
    if (phone!=nil||[phone isEqualToString:@""]) {
        self.phonetf.text=phone;
    }
    
//       _cancelBtn.frame = CGRectMake(self.phonetf.frame.size.width, 0, self.phonetf.frame.size.height, self.phonetf.frame.size.height);
//       [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)cancelClick
{
    self.phonetf.text = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (wCurrentScreen4) {
        [self updateLogBgFrameY:-140];
    }if (wCurrentScreen5) {
        [self updateLogBgFrameY:-80];
    }if (wCurrentScreen6) {
        [self updateLogBgFrameY:-80];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (wCurrentScreen4) {
        [self updateLogBgFrameY:140];
    }if (wCurrentScreen5) {
        [self updateLogBgFrameY:80];
    }if (wCurrentScreen6) {
        [self updateLogBgFrameY:80];
    }
}
- (void)updateLogBgFrameY:(CGFloat)frameY{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y+=frameY;
        self.view.frame=frame;
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)loginBtn:(id)sender {
    [self.view endEditing:YES];
    if (self.phonetf.text==nil||[self.phonetf.text isEqualToString:@""]) {
        [self addAlertTitle:@"提示" withMessage:@"用户名不能为空" withConfirmbtn:nil withCancelBtn:@"确定" withAlertTag:0 withDelegate:nil];
        return;
    }
    if (self.pswtf.text==nil||[self.pswtf.text isEqualToString:@""]) {
        [self addAlertTitle:@"提示" withMessage:@"密码不能为空" withConfirmbtn:nil withCancelBtn:@"确定" withAlertTag:0 withDelegate:nil];
        return;
    }
//    if (self.phonetf.text.length!=11) {
//        [self addAlertTitle:@"提示" withMessage:@"你输入用户名有误" withConfirmbtn:nil withCancelBtn:@"确定" withAlertTag:0 withDelegate:nil];
//        return;
//    }
    if (isdo_log) {
        return;
    }
    [[MBProgressController sharedInstance]showWithText:@"登录中..."];
    [RequestManage getRequestLoginWithUserName:self.phonetf.text Password:self.pswtf.text AppCode:@"TEACHER_APP" complete:^(NSDictionary *dic) {
        if (dic) {
            BOOL isSuccess=[dic[@"success"]boolValue];
            if(!isSuccess){
                isdo_log=NO;
                [[MBProgressController sharedInstance]hide];
                [self addAlertTitle:@"登录失败" withMessage:@"用户名错误或密码错误" withConfirmbtn:@"确定" withCancelBtn:nil withAlertTag:0 withDelegate:nil];
            }else{
                [[MBProgressController sharedInstance]hide];
                CLog(@"登录成功的信息==%@",dic);
                UserModel * user=[UserModel sharedUser];
                user.password=self.pswtf.text;
                user.log_name=self.phonetf.text;
                NSArray * dataArr=dic[@"data"];
                if (dataArr.count>0) {
                    NSDictionary *dataDic=dataArr[0];
                    user.userName=dataDic[@"userName"];
                    user.my_cookie=dataDic[@"S"];
                    user.uid=dataDic[@"userId"];
                }
                [user saveToLocal];
                AppPreFerence * appFerence=[AppPreFerence sharedAppPreference];
                [appFerence setUserLoggedin:YES];
                appFerence.loginAutomatically=YES;
                [appFerence saveToLocal];
                isdo_log=NO;
                if (self.blockEnterMain) {
                    self.blockEnterMain();
                }

            }
        }
    }fail:^{
        [[MBProgressController sharedInstance]hide];
        isdo_log=NO;
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)addAlertTitle:(NSString*)title withMessage:(NSString*)message withConfirmbtn:(NSString*)confirmBtn withCancelBtn:(NSString*)cancaleBtn withAlertTag:(NSInteger)alertTag withDelegate:(id)del{
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:title message:message delegate:del cancelButtonTitle:cancaleBtn otherButtonTitles:confirmBtn, nil];
    alert.tag=alertTag;
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
