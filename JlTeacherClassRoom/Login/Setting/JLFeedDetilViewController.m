//
//  JLFeedDetilViewController.m
//  JLClassroom
//
//  Created by JingLun on 15/7/1.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "JLFeedDetilViewController.h"
#import "JLFactory.h"

@interface JLFeedDetilViewController ()

@property(nonatomic,strong)UIScrollView * feedScrollview;
@property(nonatomic,strong)UIView  * kehuFeedView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIImageView * handleBg;

@property(nonatomic,strong)UIView  * answerView;///<回复view
@property(nonatomic,strong)UILabel * answerLabel;
@property(nonatomic,strong)UILabel * answerDetilLabel;///<回复内容label
#define LABLE_DISTANCE_X     30
#define LABEL_DITANCE_Y      10
#define TITLE_LAB_WIDTH      70
#define TITLE_LAB_HEIGHT     30
#define CONTENT_LAB_WIDTH
#define CONTENT_LAB_HEIGHT   30
#define TIME_LAB_WIDTH       70
#define TIME_LAB_HEIGHT      30
@end

@implementation JLFeedDetilViewController
- (void)viewWillAppear:(BOOL)animated{
    //加载数据
    [self  laodFeedDetil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _feedScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64)];
    _feedScrollview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_feedScrollview];
    
    _kehuFeedView=[[UIView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, 120)];
    [_feedScrollview addSubview:_kehuFeedView];
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(LABLE_DISTANCE_X, LABEL_DITANCE_Y, TITLE_LAB_WIDTH, TITLE_LAB_HEIGHT)];
    [self addNavigationViewWithLeftImg:nil title:@"意见反馈" rightImg:nil];
    _titleLabel.textColor=RGB(17, 133, 190, 1);
    [_kehuFeedView addSubview:_titleLabel];
    
    _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(LABLE_DISTANCE_X, _titleLabel.frame.size.height+_titleLabel.frame.origin.y+5, Screen_Width-LABLE_DISTANCE_X*2, CONTENT_LAB_HEIGHT)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:15];
    [_kehuFeedView addSubview:_contentLabel];
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-30-200, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+15, 200, 30)];
    _timeLabel.textAlignment=NSTextAlignmentRight;
    _timeLabel.textColor=RGB(17, 133, 190, 1);
    [_kehuFeedView addSubview:_timeLabel];
    
    _handleBg=[[UIImageView alloc]initWithFrame:CGRectMake(14, _kehuFeedView.frame.size.height, Screen_Width-14*2, 15)];
    _handleBg.image=[UIImage imageNamed:@"feedbackhandlebg.png"];
    [_feedScrollview addSubview:_handleBg];
    
    _answerView=[[UIView alloc]initWithFrame:CGRectMake(0, _handleBg.frame.size.height+_handleBg.frame.origin.y, Screen_Width, 80)];
    _answerView.backgroundColor=[UIColor yellowColor];
    [_feedScrollview addSubview:_answerView];
    
    _answerLabel=[[UILabel alloc]initWithFrame:CGRectMake(LABLE_DISTANCE_X, LABEL_DITANCE_Y, TITLE_LAB_WIDTH, TITLE_LAB_HEIGHT)];
    _answerLabel.text=@"回复意见";
    _answerLabel.textColor=RGB(17, 133, 190, 1);
    [_answerView addSubview:_answerLabel];
    
    _answerDetilLabel=[[UILabel alloc]initWithFrame:CGRectMake(LABLE_DISTANCE_X, _answerLabel.frame.size.height+_answerLabel.frame.origin.y+5, Screen_Width-LABLE_DISTANCE_X*2, CONTENT_LAB_HEIGHT)];
    _answerDetilLabel.backgroundColor=[UIColor greenColor];
    [_answerView addSubview:_answerDetilLabel];
    
    
}
- (void)laodFeedDetil{
    _contentLabel.text=self.contentDic[@"adviceContent"];
    NSString * time=self.contentDic[@"createTime"];
    NSArray *arrayC = [time componentsSeparatedByString:@" "];
    NSString    *tmpTimeStr = [arrayC[0] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    _timeLabel.text = tmpTimeStr;
    
    _answerDetilLabel.text=self.contentDic[@"handleResult"];
    if ([_answerDetilLabel.text isEqualToString:@""]) {
        _handleBg.hidden=YES;
        _answerView.hidden=YES;
    }
    NSString * tmpString = _contentLabel.text;
    NSString * handleString = _answerDetilLabel.text;
    CGFloat tmpContent = 0.0;
    UIFont * font=[UIFont systemFontOfSize:16];
    
    CGSize s = [JLFactory sizeForText:tmpString withFont:font contraint:Size(260.0, MAXFLOAT)];
    if (s.height > self.contentLabel.frame.size.height) {
        double dHeight = s.height - self.contentLabel.frame.size.height;
        
        tmpContent += dHeight;
        
        CGRect f = self.kehuFeedView.frame;
        f.size.height += dHeight;
        self.kehuFeedView.frame = f;
        
        f = self.contentLabel.frame;
        f.size.height += dHeight;
        self.contentLabel.frame = f;
        
        f = self.timeLabel.frame;
        f.origin.y += dHeight;
        self.timeLabel.frame = f;
        
        f = self.handleBg.frame;
        f.origin.y += dHeight;
        self.handleBg.frame = f;
        
        f = self.answerView.frame;
        f.origin.y += dHeight;
        self.answerView.frame = f;
        
        if(![handleString isEqualToString:@""]){
            CGSize s = [JLFactory sizeForText:handleString withFont:font contraint:Size(260.0, MAXFLOAT)];
            if (s.height > self.answerLabel.frame.size.height) {
                double dHeight = s.height - self.answerLabel.frame.size.height;
                
                tmpContent += dHeight;
                
                f = self.answerView.frame;
                f.size.height += dHeight;
                self.answerView.frame = f;
                
                f = self.answerLabel.frame;
                f.size.height += dHeight;
                self.answerLabel.frame = f;
            }
            self.answerLabel.text = handleString;
        }
        
    }
    else
    {
        if(![handleString isEqualToString:@""]){
            
            CGSize s = [JLFactory sizeForText:handleString withFont:font contraint:Size(260.0, MAXFLOAT)];
            if (s.height > self.answerLabel.frame.size.height) {
                double dHeight = s.height - self.answerLabel.frame.size.height;
                
                tmpContent += dHeight;
                
                CGRect f = self.answerView.frame;
                f.size.height += dHeight;
                self.answerView.frame = f;
                
                f = self.answerLabel.frame;
                f.size.height += dHeight;
                self.answerLabel.frame = f;
            }
            self.answerLabel.text = handleString;
        }
    }
    self.contentLabel.text = tmpString;
    
    self.feedScrollview.contentSize = CGSizeMake(self.feedScrollview.contentSize.width, self.feedScrollview.contentSize.height+221.0+tmpContent);
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
