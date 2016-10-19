//
//  LoginViewController.h
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (nonatomic,copy) void (^blockEnterMain)();

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *center_bg_top;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phone_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phone_right;
@property (weak, nonatomic) IBOutlet UIView *center_bg;
@property (weak, nonatomic) IBOutlet UIImageView *phone_bg;
@property (weak, nonatomic) IBOutlet UIImageView *psw_bg;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *pswtf;
//老师入口
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacher_topcon;
@property (weak, nonatomic) IBOutlet UILabel *teacherlable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacher_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacher_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerbg_tea;///<老师入口和输入框bg

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logBtn_topCon;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logBtn_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswtf_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phonetf_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pf_bg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tf_center_cons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfbg_center_cons;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logobg_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logobg_h;

@end
