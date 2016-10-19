//
//  JLBaseViewController.m
//  JLClassroom
//
//  Created by Mac Os on 15/6/23.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "JLBaseViewController.h"

@interface JLBaseViewController ()<UIAlertViewDelegate>

@end

@implementation JLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgimgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroungImage.png"]];
    bgimgView.frame=CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self.view addSubview:bgimgView];
}


- (void)addNavigationViewWithLeftImg:(NSString *)leftImg title:(NSString *)title rightImg:(NSString *)rightImg
{
    self.navView= [[NavagitionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.navView.backgroundColor = HEXCOLOR(0x51c095);
    _navView.leftImgView.image = [UIImage imageNamed:@"back.png"];
    _navView.titleLabel.text = title;
    _navView.rightImgView.image = [UIImage imageNamed:rightImg];
    [self.view addSubview:_navView];
    [_navView.rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView.leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)addNavigationViewtitle:(NSString *)title{
    self.navView= [[NavagitionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _navView.titleLabel.text = title;
    [self.view addSubview:_navView];
}
- (void)setRightTitle:(NSString*)title{
    if (_navView) {
        [_navView.rightButton setTitle:title forState:UIControlStateNormal];
    }
}
#pragma mark----添加系统提示框
- (void)showAlert:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)addAlertTitle:(NSString*)title withMessage:(NSString*)message withConfirmbtn:(NSString*)confirmBtn withCancelBtn:(NSString*)cancaleBtn withAlertTag:(NSInteger)alertTag withDelegate:(id)del{
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:title message:message delegate:del cancelButtonTitle:cancaleBtn otherButtonTitles:confirmBtn, nil];
    alert.tag=alertTag;
    [alert show];
}
- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton *)sender
{
    //在自己的类里面重写此方法;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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


@implementation NavagitionView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        float width = Screen_Width;
        float height = 64;
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.bgImgView.image=[UIImage imageNamed:@"taitou.png"];
        [self addSubview:self.bgImgView];
        
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 33, 10, 18)];
        [self addSubview:self.leftImgView];
        
        self.rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 35, 30, 25, 25)];
        
        [self addSubview:self.rightImgView];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.leftButton.frame = CGRectMake(0, 20, (width-100)/2, 44);
        [self addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake((width-100)/2+130, 20, (width-100)/2, 44);
        [self addSubview:self.rightButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((width-150)/2, 20, 150, 44)];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.titleLabel setTextAlignment:1];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

@end
