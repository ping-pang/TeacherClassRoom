//
//  RequestManage.m
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import "RequestManage.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "HTTPManage.h"

@implementation RequestManage
+(id)shareManage{
    static RequestManage *manage = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manage = [[self alloc] init];
    });
    return manage;
}
+(void)getRequestLoginWithUserName:(NSString*)userName Password:(NSString*)password AppCode:(NSString*)appcode complete:(void(^)(NSDictionary* dic))complete fail:(void (^)())fail{
    NSString * strUrl=[NSString stringWithFormat:@"%@login",JL_HTTP_URL];
    HTTPManage * manage=[HTTPManage shareInstance];
    NSDictionary * pariert=@{@"username":[userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"password":password,@"appCode":appcode,@"sysId":@"6"};
    CLog(@"登录信息==%@",pariert);
    [manage afpostRequsetWithUrl:strUrl withPariermet:pariert success:^(id responseObject) {
        NSDictionary* dic=(NSDictionary*)responseObject;
        CLog(@"登录接口调用成功===%@===%@",dic,dic[@"message"]);
        if(complete){
            complete(dic);
        }
        
    } fail:^{
        if (fail) {
            fail();
        }
    }];
}
+(void)getRequestLoginOut:(UserModel*)user AppCode:(NSString*)appcode complete:(void(^)(NSDictionary* dic))complete fail:(void (^)())fail{
    NSString * strUrl=[NSString stringWithFormat:@"%@&userId=%@&S=%@",JL_HTTP_URL_OUT,user.uid,user.my_cookie];
    CLog(@"登出url==%@",strUrl);
    HTTPManage * manage=[HTTPManage shareInstance];
    NSDictionary * pariert=@{};
    [manage afgetRequestWithUrl:strUrl withPariermet:pariert success:^(id responseObject) {
        if (complete) {
            complete(responseObject);
        }
    } fail:^{
        if (fail) {
            fail();
        }
    }];

}

+ (void)requestToFeddBackListFromSet:(BOOL)isFromSetvc complete:(void (^)(NSArray *array))complete{
    if (isFromSetvc) {
        [[MBProgressController sharedInstance]showWithText:@"正在努力加载...."];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HTTPManage * manage=[HTTPManage shareInstance];
        // http://218.94.114.215:10080/ssk-fzkt/mobile/exec?m=getAdviceList&userId=321078&mobileNum=15250997288&businessSysId=5&S=edda48e1-a097-400d-b36f-9475edbb3a35&mobileType=02&sysId=5&ip=10.0.3.15&mac=08-00-27-9d-a4-00
        
       
        
        NSString * rurl=[NSString stringWithFormat:@"%@getAdviceList&userId=%@&S=%@&sysId=11&mobileType=01&mobileNum=%@&businessSysId=5",JL_HTTP_URL111,[[UserModel sharedUser] uid],[[UserModel sharedUser] my_cookie],[[UserModel sharedUser] phoneNumber]];
        CLog(@"rurl = %@",rurl);
        NSString *myurl = [rurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manage afgetRequestWithUrl:myurl withPariermet:nil success:^(id responseObject) {
                        [[MBProgressController sharedInstance] hide];
            
                        NSDictionary * resDic=(NSDictionary*)responseObject;
                        BOOL isSuccess=[resDic[@"success"]boolValue];
                        if (isSuccess) {
                            NSArray * dataArr=resDic[@"data"];
                            if (complete) {
                                complete(dataArr);
                            }
                        }else{
                            [[MBProgressController sharedInstance] hide];
            
                            NSString * meeage=resDic[@"message"];
                            [[MBProgressController sharedInstance]showTipsOnlyText:meeage AndDelay:2];
                        }
            
        } fail:^{
            
        }];
        
        
    });
    
}

+ (void)delHasCommitFeedByAdvice:(NSString*)advice complete:(void(^)(NSDictionary*))complete{
    [[MBProgressController sharedInstance]showTipsOnlyText:@"正在删除" AndDelay:1];
    
    NSString *requestUrl=  [NSString stringWithFormat:@"%@deleteAdvicer&userId=%@&S=%@&adviceId=%@",JL_HTTP_URL111,[[UserModel sharedUser] uid],[[UserModel sharedUser] my_cookie],advice];
    HTTPManage * manage = [HTTPManage shareInstance];
    
    
    
    [manage afgetRequestWithUrl:requestUrl withPariermet:nil success:^(id responseObject) {
        
        NSDictionary *dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
            if (complete) {
                complete(dict);
            }
            [[MBProgressController sharedInstance] hide];
            [[MBProgressController sharedInstance] showTipsOnlyText:@"删除成功" AndDelay:1];
            
        }else
        {
            [[MBProgressController sharedInstance] showTipsOnlyText:@"删除失败" AndDelay:1];
        }

        
    } fail:^{
        
    }];
    

}

+ (void)requestToCommitFeedContent:(NSString*)content complete:(void (^)(BOOL succeed))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString * phone =[[UserModel sharedUser] phoneNumber];
        NSString * requestUrl=[NSString stringWithFormat:@"%@submitCustomerAdvice&%@&adviceContent=%@&telNo=%@&sysId=11&mobileType=01&businessSysId=5",JL_HTTP_URL111,BaseUrl,content,phone];
        CLog(@"提交反馈意见的url===%@",requestUrl);
        
        HTTPManage * manage=[HTTPManage shareInstance];
         NSString *myurl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manage afpostRequsetWithUrl:myurl withPariermet:nil success:^(id responseObject) {
            NSDictionary * resDic=(NSDictionary*)responseObject;
            BOOL isSuccess=[resDic[@"success"]boolValue];
            if (isSuccess) {
                if (resDic[@"data"] != [NSNull null] ) {
                    if (complete) {
                        complete(YES);
                    }
                    
                }
            }else{
                if (complete) {
                    complete(isSuccess);
                }
                NSString * massage=resDic[@"message"];
                [[MBProgressController sharedInstance] showTipsOnlyText:massage
                                                               AndDelay:1.5];
            }

        } fail:^{
            
        }];
   
    });
}

+ (void)requestSelectFeedDetilByAdvice:(NSString*)advice complete:(void (^)(NSDictionary *))complete{
    [[MBProgressController sharedInstance]showWithText:@"正在努力加载...."];
    
    NSString * reqUrl= [NSString stringWithFormat:@"%@getAdviceDetail&userId=%@&S=%@&adviceId=%@",JL_HTTP_URL111,[[UserModel sharedUser] uid],[[UserModel sharedUser] my_cookie],advice];
    HTTPManage * manage=[HTTPManage shareInstance];
    
    
    
    [manage afgetRequestWithUrl:reqUrl withPariermet:nil success:^(id responseObject) {
        NSDictionary * resdic=(NSDictionary*)responseObject;
        BOOL isSuccess=[resdic[@"success"]boolValue];
        [[MBProgressController sharedInstance]hide];
        if (isSuccess) {
            NSDictionary *dataDic = resdic[@"data"][0];
            if (resdic[@"data"] != [NSNull null] && [resdic[@"data"] count] !=0) {
                CLog(@"意见详情====%@",dataDic);
                if (complete) {
                    complete(dataDic);
                }
            }
            
        }else{
            [[MBProgressController sharedInstance]hide];
            NSString * massage=resdic[@"message"];
            [[MBProgressController sharedInstance] showTipsOnlyText:massage AndDelay:1.5];

        }
        
    } fail:^{
        
    }];
    

}

+ (void)requestCheckUpdayeVisonWithCurrentVison:(NSString*)versionUrl complete:(void(^)(NSDictionary*))complete{
    HTTPManage * manage=[HTTPManage shareInstance];
    [manage afgetRequestWithUrl:versionUrl withPariermet:nil success:^(id responseObject) {
        NSDictionary * resDic=(NSDictionary*)responseObject;
        if (complete) {
            complete(resDic);
        }
    } fail:^{
        
    }];
    
//    [manage afWorkRequestWithUrl:versionUrl success:^(id responseObject) {
//        NSDictionary * resDic=(NSDictionary*)responseObject;
//        if (complete) {
//            complete(resDic);
//        }
//    } fail:^{
//        
//    }];
}
@end
