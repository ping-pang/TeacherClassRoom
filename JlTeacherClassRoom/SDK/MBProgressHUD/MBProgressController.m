//
//  ThirdViewController.m
//  RealToolPicker
//
//  Created by xxcao on 13-1-8.
//  Copyright (c) 2013年 dream. All rights reserved.
//

#import "MBProgressController.h"
@interface MBProgressController ()

@end

@implementation MBProgressController

static MBProgressController *progressController = nil;

+ (MBProgressController *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressController = [[MBProgressController alloc] init];
    });
    return progressController;
}

- (id)init{
    if (self = [super init]) {
        //自定义的imgView
        self.customV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 74, 37)];
        [self.customV setImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.customV.contentMode = UIViewContentModeCenter;
    }
    return self;
}

#pragma mark -Customed MBProgress methods

- (void)showWithText:(NSString *)tipsStr {
    [self allocNewMBprogressHUDwithType: MBProgressHUDModeIndeterminate];
    if (tipsStr && tipsStr.length != 0) {
        self.hud.labelText = tipsStr;
    }
    [self.hud show:YES];
}

- (void)hide {
    if (self.hud) {
        self.hud.removeFromSuperViewOnHide = YES;
        [self.hud hide:YES];
    }
}

- (void)showTipsLoadingWithText:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay {
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeIndeterminate];
    if (tipsStr && tipsStr.length != 0) {
        self.hud.labelText = tipsStr;
    }
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           [self mbprogressDelaySet:delay];
       }completionBlock:^(){
           [self.hud removeFromSuperview];
           self.hud = nil;
       }];
}

- (void)showTipsLoadingWithText:(NSString *)tipsStr WithResult:(BOOL)isSuccess AndDelay:(NSTimeInterval)delay {
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeIndeterminate];
    if (tipsStr && tipsStr.length != 0) {
        self.hud.labelText = tipsStr;
    }
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           self.isTrue = isSuccess;
           [self mbprogressDelayWithResultSet:delay];
       }completionBlock:^(){
           [self.hud removeFromSuperview];
           self.hud = nil;
       }];
}

- (void)showTipsOnlyText:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay {
    if (!tipsStr || tipsStr.length == 0) {
        return;
    }
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeText];
    self.hud.labelText = tipsStr;
    self.hud.margin = 10;
    //    self.hud.yOffset = 150;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           [self mbprogressDelaySet:delay];
       }
           completionBlock:^(){
           [self.hud removeFromSuperview];
           self.hud = nil;
       }];
}

- (void)showTipsOnlyCustomViewWith:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay{
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeCustomView];
    if (tipsStr && tipsStr.length != 0) {
        self.hud.labelText = tipsStr;
    }
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           [self mbprogressDelaySet:delay];
       }completionBlock:^(){
           [self.hud removeFromSuperview];
           self.hud = nil;
       }];
}

#pragma mark -Init MBprogressHUD methods
- (void)allocNewMBprogressHUDwithType:(MBProgressHUDMode)type {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.hud = [[MBProgressHUD alloc] initWithWindow:window];
    self.hud.mode = type;
    if (type == MBProgressHUDModeCustomView) {
        self.hud.customView = self.customV;
    }
    [window addSubview:self.hud];
}

#pragma mark -Delay methods
- (void)mbprogressDelaySet:(NSTimeInterval)delay{
    sleep(delay);
    
}

-(void)mbprogressDelayWithResultSet:(NSTimeInterval)delay{
    sleep(delay);
    if (self.isTrue) {
        self.hud.mode = MBProgressHUDModeCustomView;
        self.hud.customView = self.customV;
        self.hud.labelText = @"成 功";
    } else {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"失 败";
        self.hud.margin = 10.0;
        self.hud.yOffset = 150.0;
        self.hud.removeFromSuperViewOnHide = YES;
    }
    sleep(2.0);
}
@end
