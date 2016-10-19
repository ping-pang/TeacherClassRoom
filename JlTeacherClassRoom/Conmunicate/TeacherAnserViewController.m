//
//  TeacherAnserViewController.m
//  JlTeacherClassRoom
//
//  Created by myl on 15/12/24.
//  Copyright © 2015年 app. All rights reserved.
//

#import "TeacherAnserViewController.h"
#import "TeacherReplyViewController.h"
#import "ImagePickerViewController.h"
#import "WebViewJavascriptBridge.h"
#import <AVFoundation/AVFoundation.h>

@interface TeacherAnserViewController ()<UIWebViewDelegate,UIActionSheetDelegate,getPhotoDelegate,UITextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property(nonatomic,strong)WebViewJavascriptBridge *bridge;
@property(nonatomic,strong)UIWebView *anserWeb;
@property(nonatomic,strong)UIView *answerV;
@property(nonatomic,strong)UITextView *textV;
@property(nonatomic,strong)UILabel *markTextLab;
@property(nonatomic,strong)UIButton *picBtn;
@property(nonatomic,strong)NSString *BaseOutLineDetailId;
@property(nonatomic,strong)NSString *baseOutlineId;
@property(nonatomic,strong)NSString *classId;
@property(nonatomic,strong)NSString *courseId;
@property(nonatomic,strong)NSString *userId; //老师回复的学生的ID
@property (nonatomic,strong)UIButton *soundBtn;
@property (nonatomic,strong)UIView *bigSoundView;
@property(nonatomic,strong)AVAudioRecorder *audioRecoder;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (nonatomic , strong) NSURL *recordedFile;
@property (nonatomic ,strong)NSMutableArray *soundArr;
@property (nonatomic, strong)UIImageView *micBackImg;
@property (nonatomic,strong)NSMutableDictionary * imgDic;

@end



@implementation TeacherAnserViewController

{
    NSInteger addCount;
    NSMutableArray *buttonArray;
    NSMutableArray *imageArray;
    UIButton *firstBtn;
    UIButton *secondBtn;
    UIButton *thirdBtn;
    
    UILabel *soundLabel1;
    UILabel *soundLabel2;
    UILabel *soundLabel3;
    
    UIButton *soundImg1;
    UIButton *soundImg2;
    UIButton *soundImg3;
    
    UILabel *title;
    
    NSInteger currentBtnNum;
    UIView *garyView;
    UIView *recoderView;
    
    NSString *startTime;
    NSString *overTime;
    
    UIButton *cancelImg1;
    UIButton *cancelImg2;
    UIButton *cancelImg3;
    NSString *currentImg;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addNavigationViewWithLeftImg:nil title:@"老师解答" rightImg:nil];
 
    _soundArr = [NSMutableArray array];
    _imgDic=[NSMutableDictionary dictionaryWithCapacity:0];
   // [self createLeft];
    self.anserWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height -64)];
    self.anserWeb.delegate = self;
    [self.view addSubview:self.anserWeb];
    [self setAudioSession];
    
    //     NSString *strurl = [NSString stringWithFormat:@"%@mWeb/courseExplain.html?t=%@&s=%@",HTTP_UTL,[[UserModel sharedUser] uid],[[UserModel sharedUser]my_cookie]];
    
    //    NSLog(@"%@",strurl);
    
    
    // 253    
    NSString *strurl = [NSString stringWithFormat:@"%@ssk-fzkt/mWeb/courseExplain.html",HTTP_UTL];
    
    
    //李田园
    //    NSString * strurl=[NSString stringWithFormat:@"http://128.0.4.242:8080/ssk-fzkt/mWeb/courseExplain.html"];
    
    
    [_anserWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]]];
    [WebViewJavascriptBridge enableLogging];
    _bridge =[[WebViewJavascriptBridge alloc]init];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.anserWeb webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"~%@",dic);
        
        if ([[NSString stringWithFormat:@"%@",dic[@"repliyFlag"]] isEqualToString:@"0"]) {
            
            self.anserWeb.frame = CGRectMake(0, 64, Screen_Width, (Screen_Height -64)-240);
            
            _BaseOutLineDetailId = [NSString stringWithFormat:@"%@",dic[@"baseOutLineDetailId"]];
            
            _baseOutlineId = [NSString stringWithFormat:@"%@",dic[@"baseOutlineId"]];
            _classId = [NSString stringWithFormat:@"%@",dic[@"classId"]];
            _courseId = [NSString stringWithFormat:@"%@",dic[@"courseId"]];
            
            _userId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
            [self initAnswerV];
            
        }
        
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{@"userId":[[UserModel sharedUser]uid],@"S":[[UserModel sharedUser]my_cookie]}];//传值
    
}

- (void)back:(UIButton *)sender
{
    if ([self.anserWeb canGoBack]) {
        
        //[self.anserWeb goBack];
        
        [_anserWeb removeFromSuperview];
        
        [_answerV removeFromSuperview];
        
        [self viewDidLoad];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}


-(void)createLeft{
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 10, 15)];
    
    imageV.image = [UIImage imageNamed:@"pic_back"];
    [leftBtn addSubview:imageV];
    
    //    [leftBtn setBackgroundImage:[UIImage imageNamed:@"pic_back"] forState:UIControlStateNormal];
    
//    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [leftBtn setTitle:@" 返回" forState:UIControlStateNormal];
    
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem :back];
    
}


-(void)initAnswerV{
    
    _answerV = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-240
                                                       , Screen_Width, 240)];
    _answerV.backgroundColor =RGB(241, 241, 241, 1);
    
   
    _textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, Screen_Width, 100)];
    _textV.backgroundColor = [UIColor whiteColor];
    _textV.font = [UIFont systemFontOfSize:16];
 
    //录音那一排
    
    UIView *soundView = [[UIView alloc]initWithFrame:CGRectMake(0, 110, Screen_Width, 30)];
    
    soundView.backgroundColor = [UIColor whiteColor];
    
    [_answerV addSubview:soundView];
    
    
    soundImg1 = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width - 30 - 60, 0, 50, 25)];
    
    soundImg1.tag = 111;
    
    soundLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 15)];
    
    [soundImg1 addSubview:soundLabel1];
    
    [soundImg1 addTarget:self action:@selector(clickVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [soundImg1 setBackgroundImage:[UIImage imageNamed:@"soundLabel"] forState:UIControlStateNormal];
    [soundView addSubview:soundImg1];
    soundImg2 = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width - 30 - 60*2, 0, 50, 25)];
    soundImg2.tag = 222;
    soundLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 15)];
    [soundImg2 addSubview:soundLabel2];
    [soundImg2 addTarget:self action:@selector(clickVoice:) forControlEvents:UIControlEventTouchUpInside];
    [soundImg2 setBackgroundImage:[UIImage imageNamed:@"soundLabel"] forState:UIControlStateNormal];
    
    [soundView addSubview:soundImg2];
    
    soundImg3 = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width - 30 - 60*3, 0, 50, 25)];
    
    soundImg3.tag = 333;
    
    soundLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 15)];
    
    [soundImg3 addSubview:soundLabel3];
    
    [soundImg3 addTarget:self action:@selector(clickVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [soundImg3 setBackgroundImage:[UIImage imageNamed:@"soundLabel"] forState:UIControlStateNormal];
    
    [soundView addSubview:soundImg3];
    
    soundLabel1.textColor = soundLabel2.textColor = soundLabel3.textColor = [UIColor whiteColor];
    
    soundImg1.hidden = YES;
    soundImg2.hidden = YES;
    soundImg3.hidden = YES;
    
    _soundBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width - 30 , 0, 30, 30)];
    
    _micBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 25)];
    _micBackImg.image = [UIImage imageNamed:@"soundMic"];
    [_soundBtn addSubview:_micBackImg];
    
    [_soundBtn addTarget:self action:@selector(soundBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [soundView addSubview:_soundBtn];
    
    //textview
    
    _markTextLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 200, 30)];
    _markTextLab.text = @"内容";
    _markTextLab.textColor = [UIColor grayColor];
    _markTextLab.font = [UIFont systemFontOfSize:16];
    
    firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,150, 40, 40)];
    firstBtn.tag=101;
    [firstBtn addTarget:self action:@selector(addPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [firstBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [firstBtn setBackgroundImage:[UIImage imageNamed:@"soundPic1"] forState:UIControlStateNormal];
    
    [_answerV addSubview:firstBtn];
    
    secondBtn = [[UIButton alloc]initWithFrame:CGRectMake(65,150, 40, 40)];
    secondBtn.tag=102;
    [secondBtn addTarget:self action:@selector(addPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
    
    
    [secondBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    [self.answerV addSubview:secondBtn];
    
    
    
    thirdBtn = [[UIButton alloc]initWithFrame:CGRectMake(115,150, 40, 40)];
    thirdBtn.tag=103;
    [thirdBtn addTarget:self action:@selector(addPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [thirdBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
    
    [thirdBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    [self.answerV addSubview:thirdBtn];

    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 202, Screen_Width-60, 30)];
    
    submitBtn.backgroundColor = RGB(85, 184, 130, 1);
    
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    _textV.delegate = self;
 
    [_answerV addSubview:_textV];
    
    [_answerV addSubview:_markTextLab];
    
    //    [_answerV addSubview:_picBtn];
    
    [_answerV addSubview:submitBtn];
    
 
    [self.view addSubview:_answerV];

    _bigSoundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];

    UIButton *grayCover = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 100)];
    
    grayCover.backgroundColor = [UIColor grayColor];
    
    grayCover.alpha = 0.5;
    
    [grayCover addTarget:self action:@selector(bigCoverClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_bigSoundView addSubview:grayCover];
    
    _bigSoundView.hidden = YES;
    
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(0,Screen_Height -100, Screen_Width, 100)];
    
    smallView.backgroundColor = [UIColor whiteColor];
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2-30, 5, 60, 20)];
    
    title.text = @"按住说话";
    
    title.textAlignment = 1;
    
    title.font = [UIFont systemFontOfSize:15];
    
    title.textColor = [UIColor grayColor];

    [smallView addSubview:title];
    
    //大的录音按钮
    
    UIButton *bigSoundBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2-30, 30, 60, 60)];
    
    [bigSoundBtn setBackgroundImage:[UIImage imageNamed:@"bigSoundBtn"] forState:UIControlStateNormal];
    
    [bigSoundBtn addTarget:self action:@selector(pressBtn:)  forControlEvents:UIControlEventTouchDown];
    
    [bigSoundBtn addTarget:self action:@selector(addVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [smallView addSubview:bigSoundBtn];
    
    [_bigSoundView addSubview:smallView];
    [self.view addSubview:_bigSoundView];
    
    
    
    cancelImg1 = [[UIButton alloc]initWithFrame:CGRectMake(45, 140  ,20, 20)];
    [cancelImg1 setBackgroundImage:[UIImage imageNamed:@"cancelImg"] forState:UIControlStateNormal];
    [_answerV addSubview:cancelImg1];
    
    cancelImg2 = [[UIButton alloc]initWithFrame:CGRectMake(95, 140  ,20, 20)];
    [cancelImg2 setBackgroundImage:[UIImage imageNamed:@"cancelImg"] forState:UIControlStateNormal];
    [_answerV addSubview:cancelImg2];
    
    cancelImg3 = [[UIButton alloc]initWithFrame:CGRectMake(145, 140  ,20, 20)];
    [cancelImg3 setBackgroundImage:[UIImage imageNamed:@"cancelImg"] forState:UIControlStateNormal];
    [_answerV addSubview:cancelImg3];
    
    [cancelImg1 addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelImg2 addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelImg3 addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelImg1.tag = 2010;
    cancelImg2.tag = 2011;
    cancelImg3.tag = 2012;
    
    cancelImg1.hidden = YES;
    cancelImg2.hidden = YES;
    cancelImg3.hidden = YES;
}

- (void)cancelClick:(UIButton *)sender
{
    NSArray *imgArr = [_imgDic allKeys];
    
    switch (sender.tag) {
        case 2010:
            [firstBtn setImage:nil forState:UIControlStateNormal];
            cancelImg1.hidden = YES;
            if ([imgArr containsObject:@"101"]) {
                [_imgDic removeObjectForKey:@"101"];
            }
            break;
        case 2011:
            [secondBtn setImage:nil forState:UIControlStateNormal];
            cancelImg2.hidden = YES;
            if ([imgArr containsObject:@"102"]) {
                [_imgDic removeObjectForKey:@"102"];
            }
            break;
        case 2012:
            [thirdBtn setImage:nil forState:UIControlStateNormal];
            cancelImg3.hidden = YES;
            if ([imgArr containsObject:@"103"]) {
                [_imgDic removeObjectForKey:@"103"];
            }
            break;
            
        default:
            break;
    }
}

//点击语音播或者删除

-(void)clickVoice:(UIButton *)btn{
    
    UIAlertView *alter  =[[UIAlertView alloc]initWithTitle:@"您的选择是" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"播放", @"删除",nil];
    alter.tag =11110;
    
    if (btn.tag == 111) {
        currentBtnNum = 0;
    }else if(btn.tag == 222){
        currentBtnNum = 1;
    }else if(btn.tag == 333){
        currentBtnNum = 2;
    }
    
    [alter show];
}


-(void)pressBtn:(UIButton *)btn{
    
    NSLog(@"按下开始录音");
    
    if (_soundArr.count == 3) {
        
        [[MBProgressController sharedInstance]showTipsOnlyText:@"录音不能超过三条" AndDelay:1.5];
        
    }else{
        
        title.text = @"正在录音";
        
        [self setAudioPath];
        
        //开始录制
        
        self.audioRecoder = [[AVAudioRecorder alloc]initWithURL:self.recordedFile settings:[self audioRecoderSetting] error:nil];
        
        self.audioRecoder.delegate = self;
        self.audioRecoder.meteringEnabled = YES;
        [self.audioRecoder prepareToRecord];
        
        [self.audioRecoder record];
        
    }
    
}

//设置录音文件位置

-(void)setAudioPath{
    
    startTime=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    startTime=[NSString stringWithFormat:@"%0.f",[startTime doubleValue]*1000];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *name = [NSString stringWithFormat:@"Documents/%@.wav",str];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:name];
    
    NSLog(@"%@",path);
    
    self.recordedFile = [[NSURL alloc]initFileURLWithPath:path];
    
    [_soundArr addObject:self.recordedFile];
    
    NSLog(@"~~~%@",_recordedFile);
}

-(void)setAudioSession{

    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    
    //设置为录音状态
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [audioSession setActive:YES error:nil];
    
}

-(void)clickSpeaker:(UIButton *)btn{
    NSLog(@"点击录音按钮弹出录音视图");
    garyView.hidden = NO;
    recoderView.hidden = NO;
}


//录音按钮

-(void)addVoice:(UIButton *)btn{
    
    NSLog(@"松开结束录音");
    
    title.text = @"按住说话";
    
    [self.audioRecoder stop];
    
}


//delegate

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag

{
    
    //如果flag为真，代表录音正常结束
    
    if (flag == YES) {
        
        NSLog(@"录音录制正常完成");
        
        //录音结束时间
        
        overTime=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        overTime=[NSString stringWithFormat:@"%0.f",[overTime doubleValue]*1000];
        
        double time =  ([overTime doubleValue]/1000 - [startTime doubleValue]/1000);
        
        NSString *finleTime =[NSString stringWithFormat:@"%0.f",time] ;
        
        NSLog(@"finleTime is %@",finleTime);
        
        
        if (_soundArr.count == 1) {
            soundImg1.hidden = NO;
            soundLabel1.text = [NSString stringWithFormat:@"%@''",finleTime];
        }else if(_soundArr.count == 2)
        {
            soundImg1.hidden = NO;
            soundImg2.hidden = NO;
            soundLabel2.text = [NSString stringWithFormat:@"%@''",finleTime];
            
        }else if(_soundArr.count == 3)
            
        {
            soundImg1.hidden = NO;
            soundImg2.hidden = NO;
            soundImg3.hidden = NO;
            soundLabel3.text = [NSString stringWithFormat:@"%@''",finleTime];
        }
    }
    
    
}





- (void)bigCoverClick

{
    _bigSoundView.hidden = YES;
    _micBackImg.image = [UIImage imageNamed:@"soundMic"];
    
}



- (void)soundBtnClick

{
    
    _bigSoundView.hidden = NO;
    _micBackImg.image = [UIImage imageNamed:@"soundMic1"];
    
}



- (void)addPicBtn:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 101:
            currentImg = @"1";
            break;
        case 102:
            currentImg = @"2";
            break;
        case 103:
            currentImg = @"3";
            break;
            
        default:
            break;
    }
    
    if (!buttonArray) {
        
        buttonArray = [NSMutableArray array];
        
    }
    
    [buttonArray addObject:sender];
    
    _picBtn = sender;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从手机相册选取" otherButtonTitles:@"拍照", nil];
    
    [sheet showInView:self.view];

}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            
        case 0:
            [self getAlbum];
            break;
            
        case 1:
            [self getCamare];
            break;
            
        case 2:
            break;
        default:
            
            break;
            
    }
    
}



#pragma mark ---getPhotoDelegate



-(void)OnGetPhoto:(UIImage *)img{
    
    [_picBtn setImage:img forState:UIControlStateNormal];
    
    if ([currentImg isEqualToString:@"1"]) {
        cancelImg1.hidden = NO;
    }else if([currentImg isEqualToString:@"2"]){
        cancelImg2.hidden = NO;
    }else if([currentImg isEqualToString:@"3"]){
        cancelImg3.hidden = NO;
    }
    
    if (!imageArray) {
        
        imageArray = [NSMutableArray array];
        
    }
    
  // UIImage * selectImg= [self fixOrientation:img];
    NSString * kry=[NSString stringWithFormat:@"%ld",(long)_picBtn.tag];
    [_imgDic setObject:img forKey:kry];
    CLog(@"图片字典===%@",_imgDic);
}


-(void)getCamare{
    
    ImagePickerViewController *pic = [[ImagePickerViewController alloc]init];
    
    [self presentViewController:pic animated:YES completion:nil];
    [pic takePhone:self];
    
}

-(void)getAlbum{
    
    ImagePickerViewController *pic = [[ImagePickerViewController alloc]init];
    [self presentViewController:pic animated:YES completion:nil];
    [pic localPhone:self];
    
}

- (void)submit:(id)sender {
    
    if (!_textV.text.length && !imageArray && _soundArr.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入解答的内容，图片或语音" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
    }else{
        
        for (int i=0; i<_imgDic.allKeys.count; i++) {
            NSString * key=_imgDic.allKeys[i];
            UIImage * selectImg=_imgDic[key];
            [imageArray addObject:selectImg];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ssk-fzkt/mobile/exec?m=getCourseTeacherRepliedDetail",HTTP_UTL];
        
        //    JL_HTTP_URL
        
        NSDictionary *dic = @{@"teacherId":[[UserModel sharedUser]uid],
                              @"userId":_userId,
                              @"classId":_classId,
                              @"courseId":_courseId,
                              @"content":_textV.text,
                              @"baseOutlineId":_baseOutlineId,
                              @"baseOutLineDetailId":_BaseOutLineDetailId};
        
        [[HTTPManage shareInstance]afpostrequestWithUrl:str withPram:dic withDate:imageArray withVideoPath:_soundArr success:^(id responseObject) {
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            
            [self.anserWeb reload];
            
            _textV.text = @"";
            
            _markTextLab.text = @"内容";
            
            imageArray = nil;
            
            [firstBtn setImage:nil forState:UIControlStateNormal];
            [secondBtn setImage:nil forState:UIControlStateNormal];
            [thirdBtn setImage:nil forState:UIControlStateNormal];
            
            [_imgDic removeAllObjects];
            cancelImg1.hidden = YES;
            cancelImg2.hidden = YES;
            cancelImg3.hidden = YES;
            
            
            //删除录音文件
            
            for (int i = 0; i < _soundArr.count ;i ++) {
                
                NSFileManager* fileManager=[NSFileManager defaultManager];
                
                if([fileManager removeItemAtPath:_soundArr[i] error:nil])
                {
                    NSLog(@"删除成功");
                }
                
            }
            soundImg1.hidden = YES;
            soundImg2.hidden = YES;
            soundImg3.hidden = YES;
            
            [_soundArr removeAllObjects];
          
            [alert show];
            NSLog(@"success::%@",dic);
            
        } fail:^{
 
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"提交失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }];
    }
}


#pragma mark

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}



-(void)textViewDidChange:(UITextView *)textView{
    
    if (!_textV.text.length) {
        _markTextLab.text = @"内容";
    }else{
        _markTextLab.text = @"";
    }
    
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    _answerV.frame =CGRectMake(0, Screen_Height-240-130, Screen_Width, 240);

}



-(void)textViewDidEndEditing:(UITextView *)textView{
    
    _answerV.frame =CGRectMake(0, Screen_Height-240, Screen_Width, 240);
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textV resignFirstResponder];
    
}





-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"request = %@",[NSString stringWithFormat:@"%@",request]);
    return YES;
    
}



//在初始化AVAudioRecord实例之前，需要进行基本的录音设置

-(NSDictionary *)audioRecoderSetting{
    
    NSDictionary *result = nil;
    
    //录音时所必需的参数设置
    
    NSMutableDictionary *settings = [[NSMutableDictionary alloc]init];
    
    [settings setValue:[NSNumber numberWithInteger:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0f] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInteger:8] forKey:AVLinearPCMBitDepthKey];
    
    
    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityForVBRKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsNonInterleaved];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    
    result = [NSDictionary dictionaryWithDictionary:settings];
    
    return result;
    
}





#pragma UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 11110) {
        
        if (buttonIndex == 0) {
            
            NSLog(@"取消");
            
        }else if(buttonIndex == 1){
            NSLog(@"播放录音");
            NSError *readingError = nil;
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:_soundArr[currentBtnNum] error:&readingError];
            
            if (self.audioPlayer !=nil) {
                
                self.audioPlayer.delegate = self;
                
                if ([self.audioPlayer prepareToPlay] == YES && [self.audioPlayer play] == YES) {
                    
                    NSLog(@"开始播放录制音频！");
                    
                }else{
                    
                    NSLog(@"不能播放录制音频！");
                    
                }
                
            }else{
                
                NSLog(@"音频播放失败！");
                
            }
            
            
            
        }else{
            
            NSLog(@"删除录音");
            
            if (currentBtnNum == 0) {  //点了第一个按钮
       
                
                if (_soundArr.count == 1) {
                    
                    soundImg1.hidden = YES;
                 
                }else if (_soundArr.count == 2){
     
                    soundImg2.hidden = YES;
                    soundLabel1.text = soundLabel2.text;
                    
                }else if (_soundArr.count == 3)
                {
                    soundImg3.hidden = YES;
                    soundLabel1.text = soundLabel2.text;
                    soundLabel2.text = soundLabel3.text;
                
                }

                //删除操作
                
                NSFileManager* fileManager=[NSFileManager defaultManager];
                
                if([fileManager removeItemAtPath:_soundArr[0] error:nil])
                    
                {
                    
                    NSLog(@"删除成功");
                    
                }
                
                [_soundArr removeObjectAtIndex:0];
    
            }
            
            else if(currentBtnNum == 1) //点了第二个按钮
                
            {
                if (_soundArr.count == 2) {
                    soundImg2.hidden = YES;
                }
                
                else if (_soundArr.count == 3)
                {
                    soundImg3.hidden = YES;
                    soundLabel2.text = soundLabel3.text;
                }
                
                //删除操作
                
                NSFileManager* fileManager=[NSFileManager defaultManager];
                
                if([fileManager removeItemAtPath:_soundArr[1] error:nil])
                {
                    NSLog(@"删除成功");
                }
                
                [_soundArr removeObjectAtIndex:1];
                
            }
            else if(currentBtnNum == 2) //点了第三个按钮
            {
                soundImg3.hidden = YES;
                
                //删除操作
                
                NSFileManager* fileManager=[NSFileManager defaultManager];
                
                if([fileManager removeItemAtPath:_soundArr[2] error:nil])
                    
                {
                    
                    NSLog(@"删除成功");
                    
                }
                
                [_soundArr removeObjectAtIndex:2];
                
            }
        }
    }
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct

    if (aImage.imageOrientation == UIImageOrientationUp){
        
//        [imageArray addObject:aImage];
        
        return aImage;
    }else{

//    if (aImage.imageOrientation == UIImageOrientationUp)
//        
//        [imageArray addObject:aImage];
//        
//        return aImage;
//    

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    
//    [imageArray addObject:img];
    
    
    return img;
}
}


@end