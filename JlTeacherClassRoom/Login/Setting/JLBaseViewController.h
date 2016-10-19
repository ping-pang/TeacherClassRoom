//
//  JLBaseViewController.h
//  JLClassroom
//
//  Created by Mac Os on 15/6/23.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavagitionView;
@interface JLBaseViewController : UIViewController
@property (nonatomic,strong)NavagitionView *navView;
- (void)addNavigationViewWithLeftImg:(NSString *)leftImg title:(NSString *)title rightImg:(NSString *)rightImg;
- (void)addNavigationViewtitle:(NSString *)title;
- (void)setRightTitle:(NSString*)title;
- (void)back:(UIButton *)sender;
- (void)rightBtnClick:(UIButton *)sender;
- (void)showAlert:(NSString *)message;
- (void)addAlertTitle:(NSString*)title withMessage:(NSString*)message withConfirmbtn:(NSString*)confirmBtn withCancelBtn:(NSString*)cancaleBtn withAlertTag:(NSInteger)alertTag withDelegate:(id)del;
@end


@interface NavagitionView : UIView
@property (nonatomic,strong)UIImageView *bgImgView;
@property (nonatomic,strong)UIImageView *leftImgView;
@property (nonatomic,strong)UIImageView *rightImgView;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UILabel *titleLabel;

@end