//
//  TeacherReplyDidReplyView.m
//  JlTeacherClassRoom
//
//  Created by apple on 15/12/26.
//  Copyright © 2015年 app. All rights reserved.
//

#import "TeacherChangeReplyView.h"

@implementation TeacherChangeReplyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UILabel *markLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
    markLab.text = @"解答";
NSString *str = @"rReplyDidReplyVierReplyDidReplyVierReplyDidReplyVierReplyDidReplyVierReplyDidReplyVierReplyDidReplyVierReplyDidReplyVierReplyDidReplyVierReplyDidReplyVierReplyDidReplyVi:";
    

    markLab.textColor = [UIColor orangeColor];
    markLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:markLab];
    
    _infoLab = [[UILabel alloc]init];//WithFrame:CGRectMake(50, 10, Screen_Width - 60, 0)];
    _infoLab.text = str;
    _infoLab.font = [UIFont systemFontOfSize:14];
    [_infoLab setNumberOfLines:0];
    [self getLabelHeight:_infoLab.text];
    [self addSubview:_infoLab];
    
     //修改按钮
    UIButton *alterBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, _infoLab.frame.size.height+15, 100, 20)];
    [alterBtn setTitle:@"修改答案" forState:UIControlStateNormal];
    [alterBtn setTitleColor:RGB(85, 108, 83, 1) forState:UIControlStateNormal];
    alterBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [self addSubview:alterBtn];
    [alterBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, alterBtn.frame.origin.y+35, Screen_Width-10, 15)];
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.text = @"2015...12...26     ";
    _timeLab.textColor = RGB(179, 222, 202, 1);
    [self addSubview:_timeLab];
    
    alterBtn.backgroundColor  = [UIColor clearColor];
    self.backgroundColor = RGB(245, 253, 251, 1);
}

-(void)btnClick:(UIButton *)sender{
    NSLog(@"......click");
    self.delegate = _vc;

    if (self.delegate && [self.delegate respondsToSelector:@selector(onClick:)]) {
        [self.delegate onClick:sender];
    }
}





-(void)getLabelHeight:(NSString *)text{
    CGSize size = CGSizeMake(Screen_Width-60, 1000);

    CGSize labelSize = [_infoLab.text sizeWithFont:_infoLab.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    //    _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, _infoLabel.frame.origin.y, SCREEN_W - 100, labelSize.height);
    _infoLab.frame = CGRectMake(50, 10, Screen_Width-60, labelSize.height);
}

@end
