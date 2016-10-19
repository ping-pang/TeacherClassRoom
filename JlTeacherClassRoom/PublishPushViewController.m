//
//  PublishPushViewController.m
//  JlTeacherClassRoom
//
//  Created by myl on 16/1/5.
//  Copyright © 2016年 app. All rights reserved.
//

#import "PublishPushViewController.h"
#import "WebViewJavascriptBridge.h"
#import "UserModel.h"
#import "UIPlaceHolderTextView.h"
#import "ImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

//#define TAG_BUTTON 12345

@interface PublishPushViewController ()<UIWebViewDelegate,UITextViewDelegate,getPhotoDelegate,UIActionSheetDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property(nonatomic,strong)UIWebView *pushWeb;
@property(nonatomic,strong)WebViewJavascriptBridge *bridge;

@property(nonatomic,strong) UIView *lowView;
@property(nonatomic,strong)UITextView *field;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)UIButton *picBtn;

/* web 返回值*/
@property(nonatomic,strong)NSString *classId;
@property(nonatomic,strong)NSString *courseId;
@property(nonatomic,strong)NSString *baseOutLineDetailId;
@property(nonatomic,strong)NSString *baseOutLineId;
@property(nonatomic,strong)NSString *goodsId;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *userId;  //学生ID

//录音

@property (nonatomic , strong) NSURL *recordedFile;
@property(nonatomic ,strong )NSString *recordedpath;
@property(nonatomic,strong)AVAudioRecorder *audioRecoder;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;

@property (nonatomic,strong)NSMutableDictionary * imgDic;


@end

@implementation PublishPushViewController
{
    NSString *startTime;
    NSString *overTime;
    
    UIButton *voice1;
    UIButton *voice2;
    UIButton *voice3;
    
      UIButton *speakerBtn;
    UIView *line;

    UIButton *firstBtn;
    UIButton *secondBtn;
    UIButton *thirdBtn;
    NSMutableArray *imageArray;
    NSMutableArray *voiceArray;
    UILabel *stateLab;
    UIView *recoderView;
    UIView *garyView;

    UIView *allScreenView;
    
    UIButton *cancelImg1;
    UIButton *cancelImg2;
    UIButton *cancelImg3;
    NSString *currentImg;
    
    

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}
-(void)creatPushWeb{

    _pushWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64-130 )];
    _pushWeb.delegate = self;
    [self.view addSubview:_pushWeb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addVolume];
    
    _imgDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self addNavigationViewWithLeftImg:nil title:@"我要推送" rightImg:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navView.rightButton setTitle:@"推送" forState:UIControlStateNormal];
    
    [self creatPushWeb];
    [self loadPushWebView];
    [self creatTextAndPic];
    
    [self setAudioSession];
}
- (void)addVolume{
    NSError *error;
    // Active audio session before you listen to the volume change event.
    // It must be called first.
    // The old style code equivalent to the line below is:
    //
    // AudioSessionInitialize(NULL, NULL, NULL, NULL);
    // AudioSessionSetActive(YES);
    //
    // Now the code above is deprecated in iOS 7.0, you should use the new
    // code here.
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    // add event handler, for this example, it is `volumeChange:` method
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

}
- (void)volumeChanged:(NSNotification *)notification
{
    // service logic here.
}
-(void)setVoice{
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    volumeView.frame = CGRectMake(-1000, -100, 100, 100);
    volumeView.hidden=NO;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    // retrieve system volume
//    float systemVolume = volumeViewSlider.value;
    
    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:1.0f animated:NO];
    
    // send UI control event to make the change effect right now.
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void)loadPushWebView{
    
    //
//    NSString *strurl = [NSString stringWithFormat:@"http://128.0.4.183:8080/ssk-fzkt/mWeb/push.html?t=%@&s=%@",[[UserModel sharedUser] uid],[[UserModel sharedUser]my_cookie]];
    
    NSString *strurl = [NSString stringWithFormat:@"%@ssk-fzkt/mWeb/push.html?t=%@&s=%@",HTTP_UTL,[[UserModel sharedUser] uid],[[UserModel sharedUser]my_cookie]];

//    NSLog(@"%@",strurl);
    
    [WebViewJavascriptBridge enableLogging];
    
    [self.pushWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]]];
    
    _bridge = [[WebViewJavascriptBridge alloc]init];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.pushWeb webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"dic===%@",dic);
        
        NSString *value = @"";

        NSString *type = dic[@"type"];
        
        if ([type isEqualToString:@"course"]) {
            for (NSString *str in dic[@"data"]) {
                value = str;
                NSLog(@"~~%@",_courseId);
            }
            if (![value isEqualToString: _courseId]) {    //判断 当查看的时候是否重新选择
                _courseId = value;

                _classId = _userId = _goodsId = _goodsName = nil;

                 NSLog(@"~~%@",_courseId);
            }
                    }
        if([type isEqualToString:@"class"]){
            for (NSString *str in dic[@"data"]) {
                value = str;
                NSLog(@"classId: %@",_classId);
            }
            
            if (![value isEqualToString: _classId]) {
                _classId = value;
                _userId = _goodsId = _goodsName = nil;
                NSLog(@"~~%@",_classId);
            }
        }
        
        if([type isEqualToString:@"user"]){
            for (NSString *str in dic[@"data"]) {
                NSString *  userIII = str ;
                if (value.length < 1) {
                    value = userIII;
                }else{
                    value = [value stringByAppendingString:[NSString stringWithFormat:@",%@",userIII]];
                }
            }
            if (![value isEqualToString:_userId]) {
                _userId = value;
                _goodsId = _goodsName = nil;
            }
            
            NSLog(@"goodsid: %@",_userId);
        }
        

        if ([type isEqualToString:@"show"] ) {
            _lowView.hidden = YES;
            self.pushWeb.frame = CGRectMake(0, 64, Screen_Width, Screen_Height-64);
        }
        
        
        if([type isEqualToString:@"goods"]){
            _lowView.hidden = NO;
            self.pushWeb.frame = CGRectMake(0, 64, Screen_Width, Screen_Height-64-130 );
            _goodsId = _goodsName = nil;
            for (NSDictionary *dics in dic[@"data"]) {
                NSString *goodid = dics[@"goodsId"];
                NSString *goodname = dics[@"goodsName"];
                if (_goodsId.length<1) {
                    _goodsId = goodid;
                    _goodsName = goodname;
                }else{
                    _goodsId = [_goodsId stringByAppendingString:[NSString stringWithFormat:@",%@",goodid]];
                    _goodsName = [_goodsName stringByAppendingString:[NSString stringWithFormat:@",%@",goodname]];
                }
            }
            NSLog(@"~~!!%@~~%@",_goodsId,_goodsName);
        }
     
    }];
    
//    [_bridge callHandler:@"testJavascriptHandler" data:@{@"userId":[[UserModel sharedUser] uid],@"S":[[UserModel sharedUser] my_cookie],}];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    CLog(@"error===%@",error);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    CLog(@"请求新内容====%@",request);
    return YES;
}
- (void)rightBtnClick:(UIButton *)sender
{
    [self publishPush];
}

//发送推送
-(void)publishPush{
    NSLog(@"请求接口，发送推送");
    
    [self submit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatTextAndPic{
    
   _lowView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-130 , Screen_Width, 130)];
    _lowView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    _field = [[UITextView alloc]initWithFrame:CGRectMake(0, 5, Screen_Width, 60)];
    _field.delegate = self;
    [_field setFont:[UIFont systemFontOfSize:15]];
    NSUInteger length = _field.text.length;
    _field.selectedRange = NSMakeRange(length, 0);
    [self.view addSubview:_field];
    
    _lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 15)];
    [_field addSubview:_lab];
    _lab.text = @"请输入要推送的信息";
    _lab.textColor = [UIColor grayColor];
    _field.text = @"";
    
   
    
    firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 ,_field.frame.origin.y+70, 40, 40)];
     firstBtn.tag=201;
    [firstBtn addTarget:self action:@selector(addImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [firstBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [firstBtn setBackgroundImage:[UIImage imageNamed:@"soundPic1"] forState:UIControlStateNormal];

    
    secondBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 + 50*1,_field.frame.origin.y+70, 40, 40)];
    secondBtn.tag = 202;
    [secondBtn addTarget:self action:@selector(addImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
    [secondBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    
    thirdBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 + 50*2,_field.frame.origin.y+70, 40, 40)];
    thirdBtn.tag = 203;
    [thirdBtn addTarget:self action:@selector(addImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [button setTag:401+i];
    [thirdBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
    [thirdBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];


    
    [_lowView addSubview:_field];
    [_lowView addSubview:firstBtn];
    [_lowView addSubview:secondBtn];
    [_lowView addSubview:thirdBtn];
//    [lowView addSubview:submit];
//    [allScreenView addSubview:_lowView];
     [self.view addSubview:_lowView];
 
    //录音        _field = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, Screen_Width-20, 120)];
    speakerBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width -20-30, 70 , 50, 50)];
    [speakerBtn setImage:[UIImage imageNamed:@"recoder"] forState:UIControlStateNormal];//soundMic
    [speakerBtn addTarget:self action:@selector(clickSpeaker:) forControlEvents:UIControlEventTouchUpInside];
    [_lowView addSubview:speakerBtn];
    
    for (int i = 0; i<3; i++) {
        UIButton *voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width -20-30-35 -(10+35)*i, speakerBtn.frame.origin.y+5, 35, 35)];
        voiceBtn.tag = 4000 + i;
//        voiceBtn.backgroundColor = [UIColor yellowColor];
        [voiceBtn setBackgroundImage:[UIImage imageNamed:@"soundLabel"] forState:UIControlStateNormal];
        [voiceBtn addTarget:self action:@selector(clickVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_lowView addSubview:voiceBtn];
        if (i == 0) {
            voice1 = voiceBtn;
            voice1.hidden = YES;
            
            
        }else if (i == 1){
            voice2 = voiceBtn;
            voice2.hidden = YES;
        }else if (i == 2){
            voice3 = voiceBtn;
            voice3.hidden = YES;
        }
    }
    
    line = [[UIView alloc]initWithFrame:CGRectMake(0,voice3.frame.origin.y + voice3.frame.size.height +10, Screen_Width, 1)];
    line.backgroundColor = HEXCOLOR(0x989898);

    garyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    garyView.backgroundColor = [UIColor blackColor];
    garyView.alpha = 0.5;
    garyView.hidden = YES;
    [self.view addSubview:garyView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGaryView)];
    [garyView addGestureRecognizer:tap];

    recoderView  =[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-90, Screen_Width, 90)];
    recoderView.backgroundColor = [UIColor whiteColor];
    
    recoderView.hidden  = YES;
    [self.view addSubview:recoderView];
    
    stateLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, Screen_Width, 15)];
    stateLab.font = [UIFont systemFontOfSize:18];
    stateLab.textAlignment = NSTextAlignmentCenter;
    stateLab.textColor = HEXCOLOR(0x989898);
    stateLab.text = @"按住说话";
    [recoderView addSubview:stateLab];
    
    UIButton *recoderBtn = [[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-45)/2, recoderView.frame.size.height - 50, 40, 40)];
    [recoderBtn setImage:[UIImage imageNamed:@"bigSoundBtn"] forState:UIControlStateNormal];
    [recoderBtn addTarget:self action:@selector(begainRecoderBtn:)  forControlEvents:UIControlEventTouchDown];
    [recoderBtn addTarget:self action:@selector(overRecoder:) forControlEvents:UIControlEventTouchUpInside];
    [recoderView addSubview:recoderBtn];
    
    cancelImg1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 65  ,20, 20)];
    [cancelImg1 setBackgroundImage:[UIImage imageNamed:@"cancelImg"] forState:UIControlStateNormal];
    [_lowView addSubview:cancelImg1];
    
    cancelImg2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 65  ,20, 20)];
    [cancelImg2 setBackgroundImage:[UIImage imageNamed:@"cancelImg"] forState:UIControlStateNormal];
    [_lowView addSubview:cancelImg2];
    
    cancelImg3 = [[UIButton alloc]initWithFrame:CGRectMake(150, 65  ,20, 20)];
    [cancelImg3 setBackgroundImage:[UIImage imageNamed:@"cancelImg"] forState:UIControlStateNormal];
    [_lowView addSubview:cancelImg3];
    
    [cancelImg1 addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelImg2 addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelImg3 addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelImg1.tag = 1010;
    cancelImg2.tag = 1011;
    cancelImg3.tag = 1012;

    cancelImg1.hidden = YES;
    cancelImg2.hidden = YES;
    cancelImg3.hidden = YES;

}

- (void)cancelClick:(UIButton *)sender
{
    NSArray *imgArr = [_imgDic allKeys];
    
    switch (sender.tag) {
        case 1010:
            [firstBtn setBackgroundImage:[UIImage imageNamed:@"soundPic1"] forState:UIControlStateNormal];
            cancelImg1.hidden = YES;
            if ([imgArr containsObject:@"201"]) {
                [_imgDic removeObjectForKey:@"201"];
            }
            break;
        case 1011:
            [secondBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
            cancelImg2.hidden = YES;
            if ([imgArr containsObject:@"202"]) {
                [_imgDic removeObjectForKey:@"202"];
            }
            break;
        case 1012:
            [thirdBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
            cancelImg3.hidden = YES;
            if ([imgArr containsObject:@"203"]) {
                [_imgDic removeObjectForKey:@"203"];
            }
            break;
            
        default:
            break;
    }
    

//    if ((sender.tag = 1010)) {
//        [firstBtn setBackgroundImage:[UIImage imageNamed:@"soundPic1"] forState:UIControlStateNormal];
//        cancelImg1.hidden = YES;
//        if ([imgArr containsObject:@"201"]) {
//            [_imgDic removeObjectForKey:@"201"];
//        }
//        
//    }else if ((sender.tag = 1011)){
//        [secondBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
//        cancelImg2.hidden = YES;
//        if ([imgArr containsObject:@"202"]) {
//            [_imgDic removeObjectForKey:@"202"];
//        }
//        
//    }else if ((sender.tag = 1012)){
//        [thirdBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
//        cancelImg3.hidden = YES;
//        if ([imgArr containsObject:@"203"]) {
//            [_imgDic removeObjectForKey:@"203"];
//        }
//    }
}

-(void)addImgClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 201:
            currentImg = @"1";
            break;
        case 202:
            currentImg = @"2";
            break;
        case 203:
            currentImg = @"3";
            break;
            
        default:
            break;
    }
    
    [_field resignFirstResponder];
    _picBtn = sender;


    
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles: @"从手机相册选择",nil];
    
        [myActionSheet showInView:self.view];
//    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //拍照
            [self takePhoto];
            break;
        case 1:
            //相册选
            [self localPhoto];
            break;
        default:
            break;
    }
}

-(void)takePhoto{
    ImagePickerViewController *pic = [[ImagePickerViewController alloc]init];
    [self presentViewController:pic animated:YES completion:nil];
    [pic takePhone:self];
}

-(void)localPhoto{
    ImagePickerViewController *pic = [[ImagePickerViewController alloc]init];
    [self presentViewController:pic animated:YES completion:nil];
    [pic localPhone:self];
}
#pragma mark------getPhotoDelegate
-(void)OnGetPhoto:(UIImage *)img{
   
    [_picBtn setBackgroundImage:img forState:UIControlStateNormal];
    
   
    
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

  //  UIImage * selectImg= [self fixOrientation:img];
    NSString * kry=[NSString stringWithFormat:@"%ld",(long)_picBtn.tag];
    [_imgDic setObject:img forKey:kry];
    CLog(@"图片字典===%@",_imgDic);
}



-(void)submit{
    for (NSString *str in voiceArray) {
        NSLog(@"%@",str);
    }
    
    if (!_userId||!_courseId ||!_classId ||(!voiceArray.count &&!_field.text.length && !_imgDic.count&&!_goodsId.length &&!_goodsName.length)) {
        NSLog(@"%lu",(unsigned long)imageArray.count);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"信息不全" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 33330;
        [alert show];
    }else{
        
        for (int i=0; i<_imgDic.allKeys.count; i++) {
            NSString * key=_imgDic.allKeys[i];
            UIImage * selectImg=_imgDic[key];
            [imageArray addObject:selectImg];
        }
        
        if (!_goodsName){
            
        _goodsName = @"";
            _goodsId = @"";
             }
        
    NSDictionary *dic = @{@"userId":_userId,
                          @"classId":_classId,
                          @"teacherId":[[UserModel sharedUser] uid],
                          @"courseId":_courseId,
                          @"pushContent":_field.text,
//                          @"baseOutlineId":@"207",
//                          @"baseOutLineDetailId":@"430",
                          @"goodsId":_goodsId,
                          @"goodsName":_goodsName};
//    JL_HTTP_URL
    NSLog(@"~!~%@",dic);
        //朱  http://128.0.3.32:8080/                                                  getCourseTeacherPushCommit
       //王  @"http://128.0.4.183/
        
//        NSString *urlStr =[NSString stringWithFormat:@"http://128.0.4.183:8080/ssk-fzkt/mobile/exec?m=getCourseTeacherPushCommit"];
        
    NSString *urlStr =[NSString stringWithFormat:@"%@ssk-fzkt/mobile/exec?m=getCourseTeacherPushCommit",HTTP_UTL];

        [[HTTPManage shareInstance]afpostPushRequestWithUrl:urlStr withPram:dic withDate:imageArray withVideoPath:voiceArray success:^(id responseObject) {
            NSLog(@"success::%@",responseObject);
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"200"]) {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"推送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                if (self.reloadBlock!=nil) {
                    self.reloadBlock(@"第一页面刷新");
                }
                
                [alertView show];
                [self initBegin];
                
                
            }else{
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"推送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
           

        } fail:^{
            CLog(@"~~~~~error");
        }];
        
    }
}

-(void)returnReload:(reloadWeb)block{
    self.reloadBlock= block;
}

- (void)back:(UIButton *)sender
{
    [self initBegin];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initBegin{
    
    [self.pushWeb reload];

    if (imageArray) {
        imageArray = nil;
        
    }
    [firstBtn setBackgroundImage:[UIImage imageNamed:@"soundPic1"] forState:UIControlStateNormal];
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
    [thirdBtn setBackgroundImage:[UIImage imageNamed:@"soundPic2"] forState:UIControlStateNormal];
    
//     NSFileManager* fileManager=[NSFileManager defaultManager];
//    if (!voice1.hidden) {
//       
//        [fileManager removeItemAtPath:voice1.titleLabel.text error:nil];
//        voice1.hidden = YES;
//        
//    }
//    if (!voice2.hidden){
//        [fileManager removeItemAtPath:voice2.titleLabel.text error:nil];
//
//        voice2.hidden = YES;
//    }
//    if (voice3.hidden){
//        [fileManager removeItemAtPath:voice3.titleLabel.text error:nil];
//
//        voice3.hidden = YES;
//    }
//
    cancelImg1.hidden = YES;
    cancelImg2.hidden = YES;
    cancelImg3.hidden = YES;
    [_imgDic removeAllObjects];
    
    if (voiceArray.count>0) {
        for (NSString *str in voiceArray) {
            NSFileManager* fileManager=[NSFileManager defaultManager];
            if([fileManager removeItemAtPath:str error:nil])
            {
                NSLog(@"删除成功");
            }
        }
    }
    voice1.hidden = YES;
    voice2.hidden = YES;
    voice3.hidden = YES;
    
    [voiceArray removeAllObjects];

    [self setAudioSession];

    _field.text = nil;
    _userId = nil;
    _classId = nil;
    _courseId = nil;
}

#pragma UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
////    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功，是否继续提问" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
////    [alert show];
////    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功，是否继续提问" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
////    [alert show];
////    
//    
//    
//    if (buttonIndex == 0) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        _field.text = nil;
//        [firstBtn setImage:nil forState:UIControlStateNormal];
//        [secondBtn setImage:nil forState:UIControlStateNormal];
//        [thirdBtn setImage:nil forState:UIControlStateNormal];
//        _lab.text = @"请输入要推送的信息";
//        
//        imageArray = nil;
//    }
//}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_field resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView{
    _field = textView;
    if (!_field.text.length) {
        _lab.text = @"请输入要推送的信息";
        
    }else{
        _lab.text = @"";
    }
    
   
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -webViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat h = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    NSLog(@"_webViewHeight :%f", h);
//    webView.frame = CGRectMake(0, 64, Screen_Width, h) ;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
      _lowView.frame =CGRectMake(0, Screen_Height-320 , Screen_Width, 130);
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    _lowView.frame =CGRectMake(0, Screen_Height-130 , Screen_Width, 130);
;
}

//录音

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

-(void)setAudioSession{
    
    voiceArray = [NSMutableArray array];
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为录音状态
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
//设置录音文件位置
-(void)setAudioPath{
    //录音开始时间
    
    startTime=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    startTime=[NSString stringWithFormat:@"%0.f",[startTime doubleValue]*1000];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *name = [NSString stringWithFormat:@"Documents/%@.wav",str];
    
    _recordedpath = [NSHomeDirectory() stringByAppendingPathComponent:name];
    NSLog(@" _recordedpath  is %@",_recordedpath);
    self.recordedFile = [[NSURL alloc]initFileURLWithPath:_recordedpath];
    NSLog(@"%@",_recordedFile);
}

-(void)begainRecoderBtn:(UIButton *)btn{
    
    if (!voice1.hidden && !voice2.hidden && !voice3.hidden) {
        NSLog(@"最多录制三条语音");
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"最多录制三条语音,请先删除后再录制" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    
    [self setAudioPath];
    //开始录制
    self.audioRecoder = [[AVAudioRecorder alloc]initWithURL:self.recordedFile settings:[self audioRecoderSetting] error:nil];
    self.audioRecoder.delegate = self;
    self.audioRecoder.meteringEnabled = YES;
    [self.audioRecoder prepareToRecord];
    [self.audioRecoder record];
    stateLab.text = @"正在录音";
}

//录音按钮
-(void)overRecoder:(UIButton *)btn{
    NSLog(@"松开结束录音");
    [self.audioRecoder stop];
    stateLab.text = @"按下录音";
}

//delegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //如果flag为真，代表录音正常结束
    
    if (flag == YES) {
        NSLog(@"录音录制正常完成");
        //        [self audio_PCMtoMP3];//录制完成，开始转码;
        
        //录音结束时间
        overTime=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        overTime=[NSString stringWithFormat:@"%0.f",[overTime doubleValue]*1000];
        
        double time =  ([overTime doubleValue]/1000 - [startTime doubleValue]/1000);
        NSString *finleTime =[NSString stringWithFormat:@"%0.f",time] ;
        NSLog(@"finleTime is %@",finleTime);
        if (voice1.hidden && voice2.hidden && voice3.hidden) {
            voice1.hidden = NO;
            [voice1 setTitle:[NSString stringWithFormat:@"%@''",finleTime] forState:UIControlStateNormal];
            
            [voiceArray addObject:self.recordedpath];
            NSLog(@"self.recordedpath is  voiceArray[0] is  %@",voiceArray[0]);
            
            NSLog(@"展示第一个声音按钮，把录音给第一个");
        }else if(!voice1.hidden && voice2.hidden && voice3.hidden){
            voice2.hidden = NO;
            [voice2 setTitle:[NSString stringWithFormat:@"%@''",finleTime] forState:UIControlStateNormal];
            [voiceArray addObject:self.recordedpath];
            
            NSLog(@"展示第二个声音按钮，把录音给第二个");
        }else if (!voice1.hidden && !voice2.hidden && voice3.hidden){
            voice3.hidden = NO;
            [voice3 setTitle:[NSString stringWithFormat:@"%@''",finleTime] forState:UIControlStateNormal];
            [voiceArray addObject:self.recordedpath];
            
            NSLog(@"展示第三个声音按钮，把录音给第三个");
        }
    }
}


//点击录音按钮
-(void)clickSpeaker:(UIButton *)btn{
    NSLog(@"点击录音按钮弹出录音视图");
    garyView.hidden = NO;
    recoderView.hidden = NO;
}
//手势收起录音视图
-(void)clickGaryView{
    garyView.hidden = YES;
    recoderView.hidden = YES;
}
//点击语音播或者删除
-(void)clickVoice:(UIButton *)btn{
    
    if (btn.tag == 4000) {
        voice1.selected = YES;
        voice2.selected = NO;
        voice3.selected = NO;
    }else if (btn.tag == 4001){
        voice1.selected = NO;
        voice2.selected = YES;
        voice3.selected = NO;
        
    }else if (btn.tag == 4002){
        voice1.selected = NO;
        voice2.selected = NO;
        voice3.selected = YES;
    }
    
    UIAlertView *alter  =[[UIAlertView alloc]initWithTitle:@"您的选择是" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"播放", @"删除",nil];
    alter.tag =11110;
    [alter show];
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 11110) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        }else if(buttonIndex == 1){
            
            if (voice1.selected == YES) {
                NSLog(@"播放第一段录音");
                NSLog(@"voice1.titleLabel.text is %@",voiceArray[0]);
                self.recordedFile = [[NSURL alloc]initFileURLWithPath:voiceArray[0]];
            }else if (voice2.selected){
                NSLog(@"播放第二段录音");
                self.recordedFile = [[NSURL alloc]initFileURLWithPath:voiceArray[1]];
            }else if (voice3.selected){
                NSLog(@"播放第三段录音");
                self.recordedFile = [[NSURL alloc]initFileURLWithPath:voiceArray[2]];
            }
            
            NSError *readingError = nil;
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.recordedFile error:&readingError];
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
            
            if (voice1.selected) {
                NSLog(@"删除第一段录音");
                //删除操作
                NSFileManager* fileManager=[NSFileManager defaultManager];
                if([fileManager removeItemAtPath:voice1.titleLabel.text error:nil])
                {
                    NSLog(@"删除成功");
                }
                [voiceArray removeObjectAtIndex:0];
                if (!voice1.hidden && !voice2.hidden && !voice3.hidden) {
                    voice3.hidden = YES;
                }else if (!voice1.hidden && !voice2.hidden && voice3.hidden){
                    voice2.hidden = YES;
                }else if (!voice1.hidden && voice2.hidden && voice3.hidden){
                    voice1.hidden = YES;
                }
                
            }else if (voice2.selected){
                NSLog(@"删除第二段录音");
                //删除操作
                NSFileManager* fileManager=[NSFileManager defaultManager];
                if([fileManager removeItemAtPath:voice2.titleLabel.text error:nil])
                {
                    NSLog(@"删除");
                }
                [voiceArray removeObjectAtIndex:1];
                if (!voice1.hidden && !voice2.hidden && !voice3.hidden) {
                    //                    voice2.titleLabel.text = voice3.titleLabel.text;
                    voice3.hidden = YES;
                }else if (!voice1.hidden && !voice2.hidden && voice3.hidden){
                    //                    voice1.titleLabel.text = voice2.titleLabel.text;
                    voice2.hidden = YES;
                }
                
            }else if (voice3.selected){
                NSLog(@"删除第三段录音");
                //删除操作
                NSFileManager* fileManager=[NSFileManager defaultManager];
                if([fileManager removeItemAtPath:voice3.titleLabel.text error:nil])
                {
                    NSLog(@"删除");
                }
                [voiceArray removeObjectAtIndex:1];
                if (!voice1.hidden && !voice2.hidden && !voice3.hidden) {
                    voice3.hidden = YES;
                }
                
            }
        }
        
    }
    else if (alertView.tag ==33330){
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            _field.text = nil;
            [firstBtn setImage:nil forState:UIControlStateNormal];
            [secondBtn setImage:nil forState:UIControlStateNormal];
            [thirdBtn setImage:nil forState:UIControlStateNormal];
            _lab.text = @"请输入要推送的信息";
            
            imageArray = nil;
        }

    }
    
}

//success and clear voice
-(void)finaleDeleteVoice{
   }

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp){

//         [imageArray addObject:aImage];
        return aImage;
    }else{
    
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
    
    
    
    
//   [imageArray addObject:img];

    
    return img;
    }
}


@end
