//
//  JLFactory.m
//  JLClassroom
//
//  Created by JingLun on 15/6/25.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "JLFactory.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "sys/utsname.h"

@implementation JLFactory
// 校验手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,177
     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|7[0-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09]|77)[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//获得iOS的mac地址。
//+ (NSString *)getUUID
//{
//    __autoreleasing NSString * uuid = nil;
//    UserBehavior * userbehavior = [UserBehavior sharedUserBehavior];
//    if(userbehavior.uuid != nil)
//    {
//        uuid = userbehavior.uuid;
//    }
//    else
//    {
//        CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
//        CFStringRef str_ref = CFUUIDCreateString(NULL, uuid_ref);
//        uuid = [NSString stringWithString:(NSString *)CFBridgingRelease(str_ref)];
//        //        CFRelease(str_ref);
//        CFRelease(uuid_ref);
//        userbehavior.uuid = uuid;
//    }
//    [userbehavior saveToLocal];
//    return uuid;
//}
//
////获得iOS的ip地址。
//+ (NSString *)getIPAddress
//{
//    __autoreleasing NSString *address = @"";
//    UserBehavior * userbehavior = [UserBehavior sharedUserBehavior];
//    if(userbehavior.ip != nil)
//    {
//        address = userbehavior.ip;
//    }
//    else
//    {
//        struct ifaddrs *interfaces = NULL;
//        struct ifaddrs *temp_addr = NULL;
//        int success = 0;
//        // retrieve the current interfaces - returns 0 on success
//        success = getifaddrs(&interfaces);
//        if (success == 0)
//        {
//            // Loop through linked list of interfaces
//            temp_addr = interfaces;
//            while(temp_addr != NULL)
//            {
//                if(temp_addr->ifa_addr->sa_family == AF_INET)
//                {
//                    // Check if interface is en0 which is the wifi connection on the iPhone
//                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
//                    {
//                        // Get NSString from C String
//                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                    }
//                }
//                temp_addr = temp_addr->ifa_next;
//            }
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//        userbehavior.ip = address;
//        [userbehavior saveToLocal];
//    }
//    
//    return address;
//}
+ (NSString *)getTmpCachesPath
{
    NSString *rtn = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    rtn = [documentDir stringByAppendingPathComponent:@"QRTmpCaches"];
    
    BOOL isDir = NO;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:rtn isDirectory:&isDir];
    if (!(isDir && isDirExist))
    {
        BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:rtn
                                                withIntermediateDirectories:YES
                                                                 attributes:nil error:nil];
        if (!create)
        {
            CLog(@"创建下载文件保存目录失败！！");
            return nil;
        }
    }
    
    return rtn;
}
// 返回文本size
+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font contraint:(CGSize)constraint
{
    CGSize size = CGSizeZero;
//    if (IOS7_OR_LATER)
//    {
        size = [text boundingRectWithSize:constraint
                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                  context:nil].size;
//    }
//    else
//    {
//        size = [text sizeWithFont:font constrainedToSize:constraint
//                    lineBreakMode:NSLineBreakByWordWrapping];
//    }
    return size;
}
+ (NSString *)screenHeight
{
    int height = [[UIScreen mainScreen] currentMode].size.height;
    return [NSString stringWithFormat:@"%d", height];
}

+ (NSString *)screenWidth
{
    int width = [[UIScreen mainScreen] currentMode].size.width;
    return [NSString stringWithFormat:@"%d", width];
}

+ (NSString *)movQuality
{
    if (iPhone5)
    {
        return @"H";
    }
    
    return @"N";
}


// 获得下载文件的保存根目录
+ (NSString *)getDownloadRootPath
{
    NSString *rtn = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    rtn = [documentDir stringByAppendingPathComponent:@"QRData"];
    
    BOOL isDir = NO;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:rtn isDirectory:&isDir];
    if (!(isDir && isDirExist))
    {
        BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:rtn
                                                withIntermediateDirectories:YES
                                                                 attributes:nil error:nil];
        if (!create)
        {
            CLog(@"创建下载文件保存目录失败！！");
            return nil;
        }
    }
    
    return rtn;
}
// 获得下载文件的临时根目录
+ (NSString *)getDownloadTempPath
{
    __autoreleasing NSString *rtn = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    rtn = [documentDir stringByAppendingPathComponent:@"QRDataTemp"];
    
    BOOL isDir = NO;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:rtn isDirectory:&isDir];
    if (!(isDir && isDirExist))
    {
        BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:rtn
                                                withIntermediateDirectories:YES
                                                                 attributes:nil error:nil];
        if (!create)
        {
            CLog(@"创建临时下载文件保存目录失败！！");
            return nil;
        }
    }
    
    return rtn;
}
// 获得书籍下载文件的临时根目录
+ (NSString *)getDownloadBookTempPath
{
    __autoreleasing NSString *rtn = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    rtn = [documentDir stringByAppendingPathComponent:@"BookDataTemp"];
    
    BOOL isDir = NO;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:rtn isDirectory:&isDir];
    if (!(isDir && isDirExist))
    {
        BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:rtn
                                                withIntermediateDirectories:YES
                                                                 attributes:nil error:nil];
        if (!create)
        {
            CLog(@"创建临时下载文件保存目录失败！！");
            return nil;
        }
    }
    
    return rtn;
}
// 通过资源地址获得资源名称
+ (NSString *)getFileNameFromURL:(NSString *)url_str
{
    NSString *suffix = [[url_str componentsSeparatedByString:@"/"] lastObject];
    return [[suffix componentsSeparatedByString:@"?"] firstObject];
}
// 从本地获取到商品的详细数据
+ (NSDictionary *)getCodeInfoFromLocal:(NSString *)goodsId
{
    __autoreleasing NSString *path = [[JLFactory getDownloadRootPath] stringByAppendingPathComponent:goodsId];
    //path = [path stringByAppendingPathComponent:CodeJsonName];
    __autoreleasing NSURL *fileURL = [NSURL fileURLWithPath:path];
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}
// 当前日期
+ (NSString *)currentDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformatter stringFromDate:currentDate];
    
    
    return date;
}
+ (UIButton *)buttonWithRect:(CGRect)rect
                   normalImg:(NSString *)normalImg
                andPushedImg:(NSString *)pushed
              andSelectedImg:(NSString *)selected
{
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (normalImg != nil)
    {
        [btn setImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
    }
    
    if (pushed != nil)
    {
        [btn setImage:[UIImage imageNamed:pushed] forState:UIControlStateHighlighted];
    }
    
    if (selected != nil)
    {
        [btn setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    }
    
    [btn setFrame:rect];
    return btn;
}
// 校验网址
+ (BOOL)isURL:(NSString *)url_str
{
    NSString *url_pre = @"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", url_pre];
    return [regex evaluateWithObject:url_str];
}
+ (NSString*)phoneSize{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4s";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5s";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6p";
    
    if ([deviceString isEqualToString:@"i386"])         return @"模拟器";//模拟器
    if ([deviceString isEqualToString:@"x86_64"])       return @"模拟器";//模拟器
    
    CLog(@"NOTE: Unknown device type: %@", deviceString);
    
    
    return deviceString;
}
@end

//消息数据类型
@implementation MessageModel



@end



