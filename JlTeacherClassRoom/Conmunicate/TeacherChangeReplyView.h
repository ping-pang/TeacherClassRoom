//
//  TeacherReplyDidReplyView.h
//  JlTeacherClassRoom
//
//  Created by apple on 15/12/26.
//  Copyright © 2015年 app. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DidReplyView <NSObject>

-(void)onClick:(UIButton *)sender;
@end
@interface TeacherChangeReplyView : UIView

@property(nonatomic,strong)UILabel *infoLab;
@property(nonatomic,strong)UILabel *timeLab;

@property(nonatomic,assign)id<DidReplyView> delegate;

@property(nonatomic,strong)id vc;
@end
