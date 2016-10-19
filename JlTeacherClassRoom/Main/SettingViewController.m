//
//  SettingViewController.m
//  JlTeacherClassRoom
//
//  Created by app on 16/1/11.
//  Copyright © 2016年 app. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUsViewController.h"
#import "FeedBackViewController.h"
#import "JLHelpBackViewController.h"
#import "LoginViewController.h"
#import "JLFactory.h"
#import "MianViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
}
@property (nonatomic,strong)NSString *currentVision;
@property(nonatomic,assign)BOOL isForceup;
@property(nonatomic,strong)NSString    * path;
@property (strong, nonatomic) NSURL *updateUrl;



@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationViewWithLeftImg:@"" title:@"设置" rightImg:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    [self settableview];
    [self setBtn];
}

- (void)settableview
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, 250)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
}

- (void)setBtn
{
    UIButton *changeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(tableview.frame)+30, Screen_Width-60, 40)];
    changeBtn.backgroundColor = RGB(87, 191, 148, 1);
    [changeBtn setTitle:@"切换账号" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
}

- (void)changeBtnClick
{
    
           [[MBProgressController sharedInstance]showWithText:@""];
    
           [RequestManage getRequestLoginOut:[UserModel sharedUser] AppCode:@"" complete:^(NSDictionary *dic) {
            [[MBProgressController sharedInstance]hide];
            BOOL isSuceess=[dic[@"success"]boolValue];
               if (isSuceess || [dic[@"code"] isEqualToString:@"401"]) {
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
               
            [[MBProgressController sharedInstance]showTipsOnlyText:@"退出失败" AndDelay:2];
            
            }
        } fail:^{
            [[MBProgressController sharedInstance]hide];
            [[MBProgressController sharedInstance]showTipsOnlyText:@"退出失败" AndDelay:1.5];
            
        }];
}

- (void)addLogin{
    
    LoginViewController * log=[[LoginViewController alloc]init];
    log.blockEnterMain=^(){
         [self enterMain];
         [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:log animated:YES completion:nil];
}

- (void)enterMain{
    MianViewController *mainVC = [[MianViewController alloc]init];
    [self.navigationController pushViewController:mainVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *china_cell_iden = @"china_cell_iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:china_cell_iden];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:china_cell_iden];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    UIImageView *myimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 30)];
    [cell.contentView addSubview:myimg];
    UILabel *mylab = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, 30)];
    mylab.font = [UIFont systemFontOfSize:20];
    [cell.contentView addSubview:mylab];
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width - 30, 15, 13, 20)];
    arrow.image = [UIImage imageNamed:@"set_arrow"];
    [cell.contentView addSubview:arrow];
    if (indexPath.row == 0) {
        myimg.image = [UIImage imageNamed:@"set_clean"];
        mylab.text = @"清除缓存";
    }else if(indexPath.row == 1)
    {
        myimg.image = [UIImage imageNamed:@"set_advice"];
        mylab.text = @"意见反馈";
        
    }else if(indexPath.row == 2)
    {
        myimg.image = [UIImage imageNamed:@"set_check"];
        mylab.text = @"版本检查";
        
    }else if(indexPath.row == 3)
    {
        myimg.image = [UIImage imageNamed:@"set_aboutus"];
        mylab.text = @"关于我们";
        
    }else if(indexPath.row == 4)
    {
        myimg.image = [UIImage imageNamed:@"set_help"];
        mylab.text = @"帮助信息";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self clearHasData];
            break;
        
        case 1:
            [self feeback];
        
            break;
        case 2:
            [self updateNewest];
            break;
        case 3:{
            AboutUsViewController * aVC=[[AboutUsViewController alloc]init];
            
            [self.navigationController pushViewController:aVC animated:YES];
            
        }
            break;
        case 4:
            [self getHelpInfo];
            break;
        
        default:
            break;
    }
}

- (void)feeback
{
    FeedBackViewController * fVC=[[FeedBackViewController alloc]init];
    fVC.isFromSetvc=YES;
    [self.navigationController pushViewController:fVC animated:YES];
}

#pragma mark---版本更新
-(void)updateNewest{
    
    
    NSDictionary    *JLClassroomDic = [[NSBundle mainBundle] infoDictionary];
    self.currentVision = [JLClassroomDic objectForKey:@"CFBundleVersion"];
    
    [[MBProgressController sharedInstance] showWithText:@"正在检查版本"];
    NSString *url_str = [NSString stringWithFormat:JL_UPDATE_VERSION,[[UserModel sharedUser] uid],[[UserModel sharedUser] my_cookie],self.currentVision];
    CLog(@"版本更新的url===%@",url_str);
    HTTPManage * manage=[HTTPManage shareInstance];
    
    [manage afgetRequestWithUrl:url_str withPariermet:nil success:^(id responseObject) {
        NSDictionary * resDic=(NSDictionary*)responseObject;
        NSString * message=resDic[@"message"];
        [[MBProgressController sharedInstance] hide];
        CLog(@"data is %@====%@",resDic,message);
        if ([[resDic objectForKey:@"data"] count] == 0)
        {
            [self addAlertTitle:ALERT_TITLE withMessage:@"当前是最新版本" withConfirmbtn:ALERT_CONFIRM withCancelBtn:nil withAlertTag:0 withDelegate:nil];
            return ;
        }
        if ([[resDic objectForKey:@"success"] boolValue])
        {
            NSDictionary *data = [[resDic objectForKey:@"data"] objectAtIndex:0];
            //            float server_version = [[data objectForKey:@"ver"] floatValue];
            NSString * ser=data[@"ver"];
            _isForceup = [[data objectForKey:@"forceup"] boolValue];
            _path = [data objectForKey:@"path"];
            self.updateUrl = [NSURL URLWithString:_path];
            
            BOOL isNew=[self version:self.currentVision  lessthan:ser];
            if (isNew) {
                CLog(@"版本更新");
                //                float verson = [ser floatValue];
                //                if ([self.currentVision  floatValue] > verson ) {
                //                    return ;
                //                }
                if (_isForceup) {
                    //强制更新
                    [self addAlertTitle:ALERT_TITLE withMessage:@"版本有更新，请更新！" withConfirmbtn:@"更新" withCancelBtn:nil withAlertTag:100 withDelegate:self];
                    
                }else{
                    //不用强制更新
                    [self addAlertTitle:ALERT_TITLE withMessage:@"版本有更新，请更新！" withConfirmbtn:@"前往更新" withCancelBtn:@"取消"withAlertTag:99 withDelegate:self];
                }
                
            }else{
                CLog(@"不需要");
                [self addAlertTitle:ALERT_TITLE withMessage:[NSString stringWithFormat:@"当前版本号%@",self.currentVision] withConfirmbtn:ALERT_CONFIRM withCancelBtn:nil withAlertTag:0 withDelegate:nil];
                
            }
        }

        
    } fail:^{
        [[MBProgressController sharedInstance] hide];
    }];
    
 
}
- (BOOL)version:(NSString *)_oldver lessthan:(NSString *)_newver
{
    NSArray *a1 = [_oldver componentsSeparatedByString:@"."];
    NSArray *a2 = [_newver componentsSeparatedByString:@"."];
    
    for (int i = 0; i < [a1 count]; i++) {
        if ([a2 count] > i) {
            if ([[a1 objectAtIndex:i] floatValue] < [[a2 objectAtIndex:i] floatValue]) {
                return YES;
            }
            else if ([[a1 objectAtIndex:i] floatValue] > [[a2 objectAtIndex:i] floatValue])
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return [a1 count] < [a2 count];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        //强制更新
        [[UIApplication sharedApplication] openURL:self.updateUrl];
        sleep(2);
        exit(0);
    }
    if (alertView.tag==99) {
        if (buttonIndex==0) {
            
        }if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:self.updateUrl];
            sleep(2);
            exit(0);
        }
        
    }
}

#pragma mark---清除缓存
-(void)clearHasData{
//    [[SDImageCache sharedImageCache] clearMemory];
//    [[SDImageCache sharedImageCache] clearDisk];
//    if ([[AppPreFerence sharedAppPreference] userLoggedin]==YES) {
//        [[DatabaseManage sharedManager] clearHistoryTable];
//        [[DatabaseManage sharedManager] clearMessageTable];
//    }
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[JLFactory getTmpCachesPath] error:&error];
    if (error) CLog(@"clearLocalData error:%@", error.description);
    [self addAlertTitle:@"提示" withMessage:@"清除成功" withConfirmbtn:@"OK" withCancelBtn:nil withAlertTag:0 withDelegate:nil];
    //[tableview reloadData];
    
}


#pragma mark---获得帮助信息
-(void)getHelpInfo{
    WeakSelf
    [[MBProgressController sharedInstance] showTipsLoadingWithText:@"正在加载..." AndDelay:1.5];
    NSString * systemkey=@"2";
    NSString * filterKey=@"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *base = [NSString stringWithFormat:@"userId=%@&S=%@&businessSysId=%@",[[UserModel sharedUser]uid],[[UserModel sharedUser]my_cookie],@"2"];

            NSString * url=[[NSString stringWithFormat:@"%@getQAList&%@&systemKey=%@&filterKey=%@",JL_HTTP_URL111,base,systemkey,filterKey]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        @"http://www.wassk.cn/ssk-fzkt/mobile/exec?m=getQAList&userId=790152&S=c1209678-f903-4b9b-bd44-648a6df7b5c6&businessSysId=2&systemKey=2&filterKey="
        
        NSLog(@"url is %@ ",url);
        [[HTTPManage shareInstance] afgetRequestWithUrl:url withPariermet:nil success:^(id responseObject) {
//            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
          
                if ([responseObject[@"success"] isEqualToString:@"true"]) {
                    if (responseObject[@"data"] != [NSNull null]/* && [resDic[@"data"] count] !=0*/)
                    {
                        
                            
                            JLHelpBackViewController  *projectHelp = [[JLHelpBackViewController alloc]init];
                        if (!projectHelp.dataList) {
                            projectHelp.dataList = [NSMutableArray array];
                        }
                            for(NSDictionary *dics in responseObject[@"data"])
                            {
                                [projectHelp.dataList addObject:dics];
                            }
                            [projectHelp setHidesBottomBarWhenPushed:YES];
                            
                            [self.navigationController pushViewController:projectHelp animated:YES];
                        
                        
                    }
                 
              
                }
         
        }
                                                          fail:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if ([wself.setupHelpFm fileExistsAtPath:wself.setupHelpPath] == NO) {
                                                                      [[MBProgressController sharedInstance] showTipsOnlyText:@"帮助信息为空"
                                                                                                                     AndDelay:1.5];
                                                                  }
                                                              });
                                                          }];
    });
}

- (void)addAlertTitle:(NSString*)title withMessage:(NSString*)message withConfirmbtn:(NSString*)confirmBtn withCancelBtn:(NSString*)cancaleBtn withAlertTag:(NSInteger)alertTag withDelegate:(id)del{
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:title message:message delegate:del cancelButtonTitle:cancaleBtn otherButtonTitles:confirmBtn, nil];
    alert.tag=alertTag;
    [alert show];
}

@end
