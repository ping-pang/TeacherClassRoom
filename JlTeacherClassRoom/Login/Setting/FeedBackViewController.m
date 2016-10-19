//
//  FeedBackViewController.m
//  JLClassroom
//
//  Created by JingLun on 15/6/30.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "FeedBackViewController.h"
#import "JLFeedDetilViewController.h"
#import "CustomInputView.h"
@interface FeedBackViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,CustomInputViewDelegate>

@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)NSArray     * dataArr;///<所有的数据
@property(nonatomic,strong)UIView      * feedIntextView;
@property(nonatomic,strong)UITextField * intextTF;///<输入框
@property(nonatomic,strong)UIView      * feedDisplayView;
@property(nonatomic,strong)CustomInputView      * inoptView;///<输入框

@property(nonatomic,assign)BOOL isNotMoreClick;///<避免多次点击某一行
@property(nonatomic,assign)BOOL isFeedBackEditStatus;///<是否处于编辑状态
@property(nonatomic,assign)BOOL doneFeedbackOrCancelFlag;///<加“确定”“取消”锁，避免多次点击
@end

@implementation FeedBackViewController
- (void)viewWillAppear:(BOOL)animated{
    [RequestManage requestToFeddBackListFromSet:self.isFromSetvc complete:^(NSArray *array) {
        self.dataArr=array;
        [_table reloadData];

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.输入意见框
    [self addNavigationViewWithLeftImg:nil title:@"意见反馈" rightImg:nil];
    _feedIntextView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, 125)];
    [self.view addSubview:_feedIntextView];
    UILabel * headFeed=[[UILabel alloc]initWithFrame:CGRectMake(15, 32, 40, 70)];
    headFeed.numberOfLines=0;
    headFeed.font=[UIFont systemFontOfSize:16];
    headFeed.text=@"意见内容";
    CGFloat LINESPACE =8.0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:headFeed.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [headFeed.text length])];
    headFeed.attributedText = attributedString;
    [headFeed sizeToFit];
    [_feedIntextView addSubview:headFeed];
    
    UIImageView * headBg=[[UIImageView alloc]initWithFrame:CGRectMake(55, 27, Screen_Width-55-15, 65)];
    headBg.image=[UIImage imageNamed:@"feedbackbg.png"];
    [_feedIntextView addSubview:headBg];
    
    _intextTF=[[UITextField alloc]initWithFrame:CGRectMake(55, 27, Screen_Width-55-15, 35)];
    _intextTF.borderStyle=UITextBorderStyleNone;
    _intextTF.delegate=self;
    [_feedIntextView addSubview:_intextTF];
    
    UILabel *  placeholder = [[UILabel alloc] initWithFrame:CGRectMake(58.0, 30.0, 100, 30)];
    placeholder.text = @"最多200字...";
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = [UIFont systemFontOfSize:14.0];
    placeholder.backgroundColor = [UIColor clearColor];
    [_feedIntextView insertSubview:placeholder belowSubview:_intextTF];
    
    UIView * linebg=[[UIView alloc]initWithFrame:CGRectMake(15, _feedIntextView.frame.size.height-5,Screen_Width-15, 1)];
    linebg.backgroundColor=HEXCOLOR(0xefefef);
    [_feedIntextView addSubview:linebg];
    //2.展示意见列表
    _feedDisplayView=[[UIView alloc]initWithFrame:CGRectMake(0, 125+64, Screen_Width, Screen_Height-125-64)];
    [self.view addSubview:_feedDisplayView];
    _table=[[UITableView alloc]initWithFrame:_feedDisplayView.bounds style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [_feedDisplayView addSubview:_table];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.textLabel.text=self.dataArr[indexPath.row][@"adviceContent"];
    cell.textLabel.font=[UIFont systemFontOfSize:18];
    return cell;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self hiddeKeyBoard];
    [self.view endEditing:YES];
}
-(void)hiddeKeyBoard{
    if ( _isFeedBackEditStatus == YES) {
        _isFeedBackEditStatus = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.inoptView.hidden=YES;
            
        } completion:^(BOOL finished) {
            self.feedIntextView.hidden=NO;
            
            [_feedDisplayView setFrame:CGRectMake(_feedDisplayView.frame.origin.x,_feedDisplayView.frame.origin.y-_inoptView.frame.size.height+_feedIntextView.frame.size.height, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height+_inoptView.frame.size.height-_feedIntextView.frame.size.height)];
            [_table setFrame:CGRectMake(0, 0, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height)];
            _doneFeedbackOrCancelFlag = NO;
            
        }];
        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isNotMoreClick==YES) {
        return;
    }else{
        NSString * advieid=self.dataArr[indexPath.row][@"adviceId"];
        [self selectFeedDetilByadviceId:advieid];
        [self hiddeKeyBoard];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag=indexPath.row;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString *string=self.dataArr[alertView.tag][@"adviceId"];
        [RequestManage delHasCommitFeedByAdvice:string complete:^(NSDictionary *dic) {
            NSString *success=[dic objectForKey:@"success"];
            if ([success isEqualToString:@"false"]) {
                NSString *str=[dic objectForKey:@"message"];
                [self addAlertTitle:ALERT_TITLE withMessage:str withConfirmbtn:ALERT_CONFIRM withCancelBtn:nil withAlertTag:0 withDelegate:nil];
                return;
            }else{
                [RequestManage requestToFeddBackListFromSet:self.isFromSetvc complete:^(NSArray *array) {
                    self.dataArr=array;
                    [_table reloadData];
                }];

            }

        }];
        
    }
}
#pragma mark--------
#pragma mark--------UITexfiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isFeedBackEditStatus = YES;

    [UIView animateWithDuration:0.5 animations:^{
        self.feedIntextView.hidden=YES;
    } completion:^(BOOL finished) {
        _inoptView = [[CustomInputView alloc] initWithconfimNameBtn:@"提交" WithCancleNameBtn:@"取消" WithDeleagate:self];
        _inoptView.frame = CGRectMake(0, 64, Screen_Width, 205);
            _inoptView.backgroundColor = RGB(240, 240, 240, 1);
        _inoptView.layer.borderWidth = 1.0;
        _inoptView.layer.borderColor = RGB(240, 240, 240, 1).CGColor;
        _inoptView.layer.cornerRadius = 5.0;
        _inoptView.hidden=NO;
        [self.view addSubview:_inoptView];
        
        [self.intextTF endEditing:YES];
        [_feedDisplayView setFrame:CGRectMake(_feedDisplayView.frame.origin.x, _feedDisplayView.frame.origin.y+_inoptView.frame.size.height -_feedIntextView.frame.size.height, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height-_inoptView.frame.size.height+_feedIntextView.frame.size.height)];
        [_table setFrame:CGRectMake(0, 0, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height)];
    }];
    

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self hiddeKeyBoard];
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark------CustomInputViewDelegate
-(void)commitFeedMeeage:(UIButton *)sender{
    [self.inoptView.textView endEditing:YES];
    if (sender.tag==101) {
        CLog(@"提交");
        if (_doneFeedbackOrCancelFlag == NO) {
            _doneFeedbackOrCancelFlag = YES;
        }
        else
        {
            return;
        }
        [_inoptView.textView endEditing:YES];
        //除去字符串中的空格
        NSString *str=[_inoptView.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([str isEqualToString:@""]) {
            [self addAlertTitle:@"提示" withMessage:@"请对问题进行必要的描述" withConfirmbtn:@"确定" withCancelBtn:nil withAlertTag:0 withDelegate:nil];
            _doneFeedbackOrCancelFlag = NO;
            return;
        }
        
        /**
         *  S sessinid  userid 用户ID adviceContent 意见内容 telNo 电话号码
         */
        [self commitUserFeedToServer:str];
        
        
    }if (sender.tag==102) {
        CLog(@"取消");
        if (_doneFeedbackOrCancelFlag == NO) {
            _doneFeedbackOrCancelFlag = YES;
        }
        else
        {
            return;
        }
        _isFeedBackEditStatus = NO;

        [UIView animateWithDuration:0.5 animations:^{
            self.inoptView.hidden=YES;

        } completion:^(BOOL finished) {
            self.feedIntextView.hidden=NO;

            [_feedDisplayView setFrame:CGRectMake(_feedDisplayView.frame.origin.x,_feedDisplayView.frame.origin.y-_inoptView.frame.size.height+_feedIntextView.frame.size.height, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height+_inoptView.frame.size.height-_feedIntextView.frame.size.height)];
            [_table setFrame:CGRectMake(0, 0, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height)];
            _doneFeedbackOrCancelFlag = NO;

        }];
    }
}
#pragma mark----需要重写父类方法
- (void)back:(UIButton *)sender{
    if (_isFeedBackEditStatus == YES)
    {
        if (_doneFeedbackOrCancelFlag == NO) {
            _doneFeedbackOrCancelFlag = YES;
        }
        else
        {
            return;
        }
        _isFeedBackEditStatus = NO;
        [self.inoptView.textView endEditing:YES];

        [UIView animateWithDuration:0.5 animations:^{
            _inoptView.hidden=YES;
        } completion:^(BOOL finished) {
            _feedIntextView.hidden=NO;
            
            [_feedDisplayView setFrame:CGRectMake(_feedDisplayView.frame.origin.x,_feedDisplayView.frame.origin.y-_inoptView.frame.size.height+_feedIntextView.frame.size.height, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height+_inoptView.frame.size.height-_feedIntextView.frame.size.height)];
            [_table setFrame:CGRectMake(0, 0, _feedDisplayView.frame.size.width, _feedDisplayView.frame.size.height)];
            _doneFeedbackOrCancelFlag = NO;
            
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
#pragma mark-----提交反馈信息
-(void)commitUserFeedToServer:(NSString*)content{
    self.isFromSetvc=NO;
    WeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestManage requestToCommitFeedContent:content complete:^(BOOL succeed) {
            if (succeed) {
                CLog(@"提交意见成功");
                wself.isFeedBackEditStatus = NO;
                [UIView animateWithDuration:0.5f animations:^{
                    wself.inoptView.hidden=YES;
                } completion:^(BOOL finished) {
                    wself.feedIntextView.hidden=NO;

                    [wself.feedDisplayView setFrame:CGRectMake(wself.feedDisplayView.frame.origin.x,wself.feedDisplayView.frame.origin.y-wself.inoptView.frame.size.height+wself.feedIntextView.frame.size.height, wself.feedDisplayView.frame.size.width, wself.feedDisplayView.frame.size.height+wself.inoptView.frame.size.height-wself.feedIntextView.frame.size.height)];
                    [wself.table setFrame:CGRectMake(0, 0, wself.feedDisplayView.frame.size.width, wself.feedDisplayView.frame.size.height)];
                }];
//                [[MBProgressController sharedInstance] showTipsOnlyText:@"我们已经收到您的意见反馈" AndDelay:1.5];

                wself.doneFeedbackOrCancelFlag = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [RequestManage requestToFeddBackListFromSet:self.isFromSetvc complete:^(NSArray *array) {
                        self.dataArr=array;
                        [_table reloadData];
                        if (self.dataArr.count==0) {
                            [self addAlertTitle:ALERT_TITLE withMessage:@"获取意见列表失败" withConfirmbtn:@"确定" withCancelBtn:nil withAlertTag:0 withDelegate:nil];
                        }
                    }];

                });
            }else{
                //是否处在编辑状态
                wself.isFeedBackEditStatus = NO;
            }
        }];
    
        
    });
    
    
}
#pragma mark----查询反馈信息详情
-(void)selectFeedDetilByadviceId:(NSString*)adviceId{
    
    [RequestManage requestSelectFeedDetilByAdvice:adviceId complete:^(NSDictionary *dic) {
        JLFeedDetilViewController * dVC=[[JLFeedDetilViewController alloc]init];
        
        dVC.contentDic=dic;
        self.isFromSetvc=NO;
        [self.navigationController pushViewController:dVC animated:YES];
    }];
    
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
