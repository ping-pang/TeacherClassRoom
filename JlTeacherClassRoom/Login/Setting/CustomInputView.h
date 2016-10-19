//
//  CustomInputView.h
//  JLClassroom
//
//  Created by JingLun on 15/7/1.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomInputViewDelegate

@optional

-(void)commitFeedMeeage:(UIButton*)sender;

@end


@interface CustomInputView : UIView
@property(nonatomic,strong)UITextView * textView;///<输入框
@property(nonatomic,assign)id       delegate;

-(id)initWithconfimNameBtn:(NSString*)confimNameBtn WithCancleNameBtn:(NSString*)cancleNameBtn WithDeleagate:(id<CustomInputViewDelegate>)del;
@end
