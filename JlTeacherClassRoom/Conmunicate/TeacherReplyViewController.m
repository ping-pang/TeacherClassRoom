//
//  TeacherReplyViewController.m
//  JlTeacherClassRoom
//
//  Created by myl on 15/12/24.
//  Copyright © 2015年 app. All rights reserved.
//

#import "TeacherReplyViewController.h"
#import "ImagePickerViewController.h"
#import "TeacherChangeReplyView.h"
@interface TeacherReplyViewController ()<getPhotoDelegate,UIActionSheetDelegate,DidReplyView>
//@property(nonatomic,strong)UITextView *askLab;

//@property(nonatomic,strong)UILabel *askTime;
//
//@property(nonatomic,strong)UITextView *replyText;
//@property(nonatomic,strong)UIButton *replyImgBtn;
//
//@property(nonatomic,strong)UIButton *submit;
//@property(nonatomic,strong)UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UIButton *addReplyImg;
@property (weak, nonatomic) IBOutlet UITextView *replyTextView;

@property (weak, nonatomic) IBOutlet UIButton *subit;
@property(nonatomic,strong)TeacherChangeReplyView *changeView;

@property(nonatomic,assign)BOOL isChange;

@end

@implementation TeacherReplyViewController
{
    NSInteger addCount;
    NSMutableArray *buttonArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUI];
    self.title = @"我的解答";
            _replyView.hidden = YES;
            _changeView = [[TeacherChangeReplyView alloc]initWithFrame:CGRectMake(0, Screen_Height/2+20, Screen_Width, Screen_Height-10)];
            _changeView.vc =self;
            [self.view addSubview:_changeView];
  
}

//-(void)changeView{
//    if (_isChange) {
//        _replyView.hidden = YES;
//        TeacherChangeReplyView *view = [[TeacherChangeReplyView alloc]initWithFrame:CGRectMake(0, Screen_Height/2+20, Screen_Width, Screen_Height-10)];
//        view.vc =self;
//        [self.view addSubview:view];
//    }else{
//        
//    }
// 
//}

- (IBAction)addReplyImg:(UIButton *)sender {
    CLog(@"button");
    if (!buttonArray) {
        buttonArray = [NSMutableArray array];
    }
    [buttonArray addObject:sender];
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从手机相册选区" otherButtonTitles:@"拍照", nil];
    [sheet showInView:self.view];
    
    if (addCount<2) {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(sender.frame.origin.x+sender.frame.size.width+10, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height)];
//    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addReplyImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.replyView addSubview:button];
        NSLog(@"%ld",addCount);

    ++addCount;
        NSLog(@"%ld",addCount);
    }
}

-(void)OnGetPhoto:(UIImage *)img{
   
    if (buttonArray.count ==1) {
        [_addReplyImg setImage:img forState:UIControlStateNormal];
    }else{
    UIButton *btn = [buttonArray lastObject];
    [btn setImage:img forState:UIControlStateNormal];

    }
}

-(void)setImage:(UIButton *)button{
    
//   button setImage: forState:on
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
            ///
        default:
            break;
    }
}
#pragma mark ---getPhotoDelegate
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


#pragma mark ----DidReplyView   修改答案
-(void)onClick:(UIButton *)sender{
    self.replyTextView.text = self.changeView.infoLab.text;
    _changeView.hidden = YES;
    
    _replyView.hidden = NO;
}

- (IBAction)cancel:(id)sender {
    
}


- (IBAction)submit:(id)sender {
    
}









    //
//-(void)setUI{
//    
//        _askLab = [[UITextView alloc]initWithFrame: CGRectMake(25, 94, Screen_Width-50, 50)];
//        _askLab.text = @"helloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBdayhelloEveryBday";
////    _askLab.numberOfLines = 0;
////        CGSize size = CGSizeMake(Screen_Width-50, 1000);
////        CGSize labelSize = [_askLab.text sizeWithFont:_askLab.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//    
////        _askLab.frame = CGRectMake(25, 94, Screen_Width-50, 200);
//    [self.view addSubview:_askLab];
//    
//    
//    _askIV = [[UIImageView alloc]initWithFrame:CGRectMake(25, _askLab.frame.origin.y+_askLab.frame.size.height+10, Screen_Width-50, 100)];
//    _askIV.image = [UIImage imageNamed:@"yuxi@2x"];
//    [self.view addSubview:_askIV];
//    
//    _askTime = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-150, _askIV.frame.origin.y+100+10, 125, 30)];
//    _askTime.text = @"2015/12/25";
//    [self.view addSubview:_askTime];
//    
//    UIImageView *imgIV = [[UIImageView alloc]initWithFrame:CGRectMake(25, _askTime.frame.origin.y+10, 200, 80)];
//    imgIV.image = [UIImage imageNamed:@"yuxi@2x"];
//    [self.view addSubview:imgIV];
//    
//    _replyText = [[UITextView alloc]initWithFrame:CGRectMake(25, imgIV.frame.origin.y+90, Screen_Width-50, 150)];
//    [self.view addSubview:_replyText];
//    _replyText.backgroundColor = [UIColor grayColor];
//    
//    UIButton *addImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, _replyText.frame.origin.y+150+10, (Screen_Width-125)/4, (Screen_Width-125)/4)];
//    
//    [addImgBtn addTarget:self action:@selector(addImgClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:addImgBtn];
//    [addImgBtn setImage:[UIImage imageNamed:@"yuxi@2x"] forState:UIControlStateNormal];
//    [addImgBtn setTag:0];
//    
//    _submit = [[UIButton alloc]initWithFrame:CGRectMake(60, addImgBtn.frame.origin.y+(Screen_Width-125)/4+10, 100, 30)];
//    [_submit setTitle:@"提交" forState:UIControlStateNormal];
//    [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:_submit];
//    [_submit setBackgroundColor:[UIColor greenColor]];
//    
//    _cancel = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-60-100, addImgBtn.frame.origin.y+(Screen_Width-125)/4+10, 100, 30)];
//    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
//    [_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_cancel setBackgroundColor:[UIColor orangeColor]];
//    [self.view addSubview:_cancel];
//}
//
//
//
////622202 430103 057 8247
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
