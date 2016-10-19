//
//  RequestManage.h
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface RequestManage : NSObject
+(id)shareManage;
/**
 *  登录调用的请求
 *
 *  @param userName   登录用户
 *  @param password   密码
 *  @param password   appcode
 *  @param complete
 */
+(void)getRequestLoginWithUserName:(NSString*)userName Password:(NSString*)password AppCode:(NSString*)appcode complete:(void(^)(NSDictionary* dic))complete fail:(void (^)())fail;
/**
 *  登出业务系统的请求
 *
 *  @param user       用户
 *  @param password   appcode
 *  @param complete
 */

+(void)getRequestLoginOut:(UserModel*)user AppCode:(NSString*)appcode complete:(void(^)(NSDictionary* dic))complete fail:(void (^)())fail;

/**
 *  获取意见列表的接口
 *
 *  @param isFromSetvc 是否来自设置界面
 *  @param complete    获得意见列表完成
 */
+ (void)requestToFeddBackListFromSet:(BOOL)isFromSetvc complete:(void (^)(NSArray *array))complete;

/**
 *  删除提交的反馈信息
 *
 *  @param advice   意见ID
 *  @param complete
 */
+ (void)delHasCommitFeedByAdvice:(NSString*)advice complete:(void(^)(NSDictionary*))complete;

/**
 *  提交反馈意见
 *
 *  @param content  意见内容
 *  @param complete 获得意见内容完成
 */
+ (void)requestToCommitFeedContent:(NSString*)content complete:(void (^)(BOOL succeed))complete;

/**
 *  查看意见的详细内容和回复信息
 *
 *  @param advice   意见ID
 *  @param complete 提交意见完成
 */
+ (void)requestSelectFeedDetilByAdvice:(NSString*)advice complete:(void (^)(NSDictionary *))complete;

+ (void)requestCheckUpdayeVisonWithCurrentVison:(NSString*)versionUrl complete:(void(^)(NSDictionary*))complete;

@end
