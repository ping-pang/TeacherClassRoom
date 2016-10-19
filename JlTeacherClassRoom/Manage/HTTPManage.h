//
//  HTTPManage.h
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPManage : NSObject
+(id)shareInstance;
/*post请求*/
-(void)afpostRequsetWithUrl:(NSString*)url withPariermet:(NSDictionary*)pariermet success:(void (^)(id responseObject))success fail:(void (^)())fail;
/*get请求*/
-(void)afgetRequestWithUrl:(NSString*)url withPariermet:(NSDictionary*)pariermet success:(void (^)(id responseObject))success fail:(void (^)())fail;
/*文件*/
-(void)afpostrequestWithUrl:(NSString *)url withPram:(NSDictionary *)dic withDate:(NSMutableArray *)imgArr withVideoPath:(NSMutableArray *)videoPath  success:(void (^)(id responseObject))success fail:(void(^)())fail;
//推送
-(void)afpostPushRequestWithUrl:(NSString *)url withPram:(NSDictionary *)dic withDate:(NSMutableArray *)imgArr withVideoPath:(NSMutableArray *)videoPath  success:(void (^)(id responseObject))success fail:(void(^)())fail;
-(void)afWorkRequestWithUrl:(NSString*)urlStr success:(void (^)(id responseObject))success fail:(void (^)())fail;

@end
