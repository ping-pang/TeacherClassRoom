//
//  HTTPManage.m
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import "HTTPManage.h"
#import "AFNetworking.h"
#import "MBProgressController.h"
@implementation HTTPManage
+(id)shareInstance{
    static HTTPManage *manage = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manage = [[self alloc] init];
    });
    return manage;
}
-(void)afpostRequsetWithUrl:(NSString*)url withPariermet:(NSDictionary*)pariermet success:(void (^)(id responseObject))success fail:(void (^)())fail{
    CLog(@"url is: %@",url);
    AFHTTPRequestOperationManager * manager= [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:pariermet success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"Error: %@", error);
        if (fail) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            alertView=nil;
            fail(error);
        }

    }];
}

-(void)afgetRequestWithUrl:(NSString*)url withPariermet:(NSDictionary*)pariermet success:(void (^)(id responseObject))success fail:(void (^)())fail{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval=30.0;
    CLog(@"Error: %@", url);
    [manager GET:url parameters:pariermet success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"~~::%@",responseObject);
        if (success) {
            
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"Error: %@", error);
        if (fail) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            alertView=nil;
            fail(error);
        }

    }];
}

-(void)afpostrequestWithUrl:(NSString *)url withPram:(NSDictionary *)dic withDate:(NSMutableArray *)imgArr withVideoPath:(NSMutableArray *)videoPath success:(void (^)(id responseObject))success fail:(void(^)())fail{
    

    
    [[MBProgressController sharedInstance]showWithText:@"正在上传"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"%@",url);
    
    NSLog(@"%@",dic);
    
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    

    
//    if (imgArr.count >0) {
    
        
        
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
           if (imgArr.count >0) {
            for (UIImage *img in imgArr) {
                
                NSData *data = UIImagePNGRepresentation(img);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = @"yyyyMMddHHmmss";
                
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                
                [formData appendPartWithFileData:data name:@"images" fileName:fileName mimeType:@"image/png"];
                
            }
            
           }
        

            if (videoPath.count > 0) {
                
                for (NSURL *pathURL in videoPath){
                    NSString *str = [NSString stringWithFormat:@"%@",pathURL];
                    NSData *voiceData = [NSData dataWithContentsOfURL:pathURL];
                    NSArray *arr = [str componentsSeparatedByString:@"Documents/"];
                    NSString *fileName = arr[1];
                    //                NSString *fileName = [NSString stringWithFormat:@"%@.wav", @"downloadFile"];
                    NSLog(@"fileName is %@",fileName);
                    [formData appendPartWithFileData:voiceData name:@"Recording" fileName:fileName mimeType:@"audio/x-wav"];
                    NSLog(@"formData is  %@",formData);
                }
            }
                     
            

        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"success::::::%@",dic);
            
            if (success) {
                
                success(dic);
                
                [[MBProgressController sharedInstance]hide];
                
                CLog(@"success%@",dic);
            }
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            if (fail) {
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alertView show];
                
                alertView=nil;
                
                
                
                fail(error);
                
                [[MBProgressController sharedInstance]hide];
                
                
                
            }
            
            
            
        }];
        
//    }else{
//        
//        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            
//            
//            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            
//            NSLog(@"success::::::%@",dic);
//            
//            if (success) {
//                
//                success(dic);
//                
//                CLog(@"success%@",dic);
//                
//                [[MBProgressController sharedInstance]hide];
//                
//                
//                
//            }
//            
//            
//            
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            
//            if (fail) {
//                
//                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                
//                [alertView show];
//                
//                alertView=nil;
//                
//                
//                
//                fail(error);
//                
//                [[MBProgressController sharedInstance]hide];
//                
//            }
//            
//        }];
//        
//    }
    
    
    
}


-(void)afpostPushRequestWithUrl:(NSString *)url withPram:(NSDictionary *)dic withDate:(NSMutableArray *)imgArr withVideoPath:(NSMutableArray *)videoPath success:(void (^)(id responseObject))success fail:(void(^)())fail{
    
    
    
    [[MBProgressController sharedInstance]showWithText:@"正在上传"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"%@",url);
    
    NSLog(@"%@",dic);
    
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    
    
    //    if (imgArr.count >0) {
    
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        UIImage *image = [UIImage imageNamed:@"aaa.png"];
        
        if (imgArr.count >0) {
            for (UIImage *img in imgArr) {
                
                NSData *data = UIImagePNGRepresentation(img);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = @"yyyyMMddHHmmss";
                
                NSString *str = [formatter stringFromDate:[NSDate date]];
                
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                
                
                
                [formData appendPartWithFileData:data name:@"images" fileName:fileName mimeType:@"image/png"];
                
            }
            
        }
        if (videoPath.count > 0) {
            for (NSString *str in videoPath) {
                
                NSData *voiceData = [NSData dataWithContentsOfFile:str];
                NSArray *arr = [str componentsSeparatedByString:@"Documents/"];
                NSString *fileName = arr[1];
                //                NSString *fileName = [NSString stringWithFormat:@"%@.wav", @"downloadFile"];
                NSLog(@"fileName is %@",fileName);
                [formData appendPartWithFileData:voiceData name:@"Recording" fileName:fileName mimeType:@"audio/x-wav"];
                NSLog(@"formData is  %@",formData);
            }
            
        }

    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"success::::::%@",dic);
        
        if (success) {
            
            success(dic);
            
            [[MBProgressController sharedInstance]hide];
            
            CLog(@"success%@",dic);
            
            
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (fail) {
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alertView show];
            
            alertView=nil;
            
            
            
            fail(error);
            
            [[MBProgressController sharedInstance]hide];
            
            
            
        }
        
        
        
    }];
}




@end
