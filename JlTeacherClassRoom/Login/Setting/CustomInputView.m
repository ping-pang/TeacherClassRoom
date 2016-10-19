    //
//  CustomInputView.m
//  JLClassroom
//
//  Created by JingLun on 15/7/1.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "CustomInputView.h"


@interface CustomInputView()<UITextViewDelegate>

@end

@implementation CustomInputView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
    
        
    }
    return self;
}
-(id)initWithconfimNameBtn:(NSString*)confimNameBtn WithCancleNameBtn:(NSString*)cancleNameBtn WithDeleagate:(id<CustomInputViewDelegate>)del{
    self=[super initWithFrame:CGRectMake(0, 0, Screen_Width, 205)];
    if (self) {
        
        _delegate=del;
        
        UIImageView *suggestionBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, Screen_Width-26, 125)];
        suggestionBackImg.image = [UIImage imageNamed:@"feedbackbg1.png"];
        [self addSubview:suggestionBackImg];
        UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideEditKeyboard:)];
        [self addGestureRecognizer:tapGesture];
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(13, 10, Screen_Width-26, 125)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:16.0];
        _textView.delegate = self;
        [_textView becomeFirstResponder];//保证点击前面输入框,跳转后光标存在
        
        UIButton    *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(20, 155, 125, 40);
        doneButton.tag=101;
        [doneButton setTitle:confimNameBtn forState:UIControlStateNormal];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"submit_opinion_normal.png"] forState:UIControlStateNormal];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"submit_opinion_Selected.png"] forState:UIControlStateSelected];

        [doneButton addTarget:self action:@selector(inputClcik:) forControlEvents:UIControlEventTouchUpInside];
        UIButton    *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(Screen_Width-125-20, 155, 125, 40);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_Opinion.png"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_Opinion_selected.png"] forState:UIControlStateSelected];
        [cancelButton setTintColor:[UIColor whiteColor]];
        [cancelButton setTitle:cancleNameBtn forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(inputClcik:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag=102;
        
        [self addSubview:doneButton];
        [self addSubview:cancelButton];
        [self addSubview:_textView];
                
    }
    return self;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 200 && text.length > range.length) {
        textView.text = [textView.text substringToIndex:200];
        return NO;
    }
    if (textView.textInputMode.primaryLanguage) {
        return YES;
    }
    return NO;

}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    
    //textView.markedTextRange == nil,这个判断中英文输入，在ios8中，已经做了优化,不需要这个校验了
    if (textView.markedTextRange == nil && textView.text.length > 200)
    {
        textView.text = [textView.text substringToIndex:200];
    }
//保证每次结束编辑之后TextView自动滚动到最后一行(汉字输入问题)
    _textView = textView;
    [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height-15, _textView.contentSize.width, 10) animated:YES];
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    CLog(@"选中区域");
}
- (void)inputClcik:(UIButton*)sender{
    if ([_delegate respondsToSelector:@selector(commitFeedMeeage:)]) {
        [_delegate commitFeedMeeage:sender];
    }
}
- (void)HideEditKeyboard:(UITapGestureRecognizer *)gesture
{
    [self.textView endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
