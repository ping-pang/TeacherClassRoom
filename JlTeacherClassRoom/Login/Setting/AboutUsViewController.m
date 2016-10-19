//
//  AboutUsViewController.m
//  JLClassroom
//
//  Created by JingLun on 15/6/30.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "AboutUsViewController.h"


@interface AboutUsViewController ()

@property(nonatomic,strong)UIImageView * bgView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationViewWithLeftImg:nil title:@"关于我们" rightImg:nil];
    _bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64)];
    _bgView.image=[UIImage imageNamed:@"aboutus"];
    [self.view addSubview:_bgView];
    
    NSDictionary   *JLPlatformInfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * appCurrentVersionStr = [JLPlatformInfoDic objectForKey:@"CFBundleShortVersionString"];
    UILabel * labe=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-100)/2, Screen_Height-64-45, 100, 30)];
    [self.view addSubview:labe];
    labe.text=[NSString stringWithFormat:@"版本：%@",appCurrentVersionStr];
    labe.textAlignment=NSTextAlignmentCenter;
    labe.textColor=HEXCOLOR(0x676767);
    labe.font=[UIFont systemFontOfSize:15];
//    labe.backgroundColor=[UIColor redColor];
    
    NSString *app_Version = [JLPlatformInfoDic objectForKey:@"CFBundleShortVersionString"];
    CLog(@"版本号===%@",app_Version);
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
