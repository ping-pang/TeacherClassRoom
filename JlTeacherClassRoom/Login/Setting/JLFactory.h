//
//  JLFactory.h
//  JLClassroom
//
//  Created by JingLun on 15/6/25.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JLFactory : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  获取系统的UUID
 *
 *  @return
 */
+ (NSString *)getUUID;
/**
 *  获取手机IP
 *
 *  @return
 */
+ (NSString *)getIPAddress;
/**
 *  获得doc、pdf、gif等临时文件的缓存目录
 *
 *  @return
 */
+ (NSString *)getTmpCachesPath;
/**
 *   返回文本大小
 *
 *  @param text       文字内容
 *  @param font       字体大小
 *  @param constraint <#constraint description#>
 *
 *  @return <#return value description#>
 */
+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font contraint:(CGSize)constraint;
// 返回设备屏幕尺寸
+ (NSString *)screenHeight;
+ (NSString *)screenWidth;

// 返回视频质量级别
+ (NSString *)movQuality;
// 获得下载文件的保存根目录
+ (NSString *)getDownloadRootPath;
// 获得下载文件的临时根目录
+ (NSString *)getDownloadTempPath;
// 获得书籍下载文件的临时根目录
+ (NSString *)getDownloadBookTempPath;
// 通过资源地址获得资源名称
+ (NSString *)getFileNameFromURL:(NSString *)url_str;
// 从本地获取到商品的详细数据
+ (NSDictionary *)getCodeInfoFromLocal:(NSString *)goodsId;
// 当前日期
+ (NSString *)currentDate;
//button
+ (UIButton *)buttonWithRect:(CGRect)rect
                   normalImg:(NSString *)normalImg
                andPushedImg:(NSString *)pushed
              andSelectedImg:(NSString *)selected;
// 校验网址
+ (BOOL)isURL:(NSString *)url_str;
+ (NSString*)phoneSize;
@end

//获取消息的数据模型
@interface MessageModel : NSObject
@property (nonatomic,strong)NSString *messageId;
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,assign)int isRead;
@end

