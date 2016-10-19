//
//  UserModel.m
//  JlTeacherClassRoom
//
//  Created by app on 15/12/1.
//  Copyright © 2015年 app. All rights reserved.
//

#import "UserModel.h"

static UserModel *singletonUser = nil;
@implementation UserModel
- (id)init
{
    if (self = [super init]) {
        _uid = [USER_DEFAULT objectForKey:UserId];
        _password = [USER_DEFAULT objectForKey:UserPwd];
        _userName = [USER_DEFAULT objectForKey:@"userName"];
        _log_name = [USER_DEFAULT objectForKey:@"phoneNumber"];
        _password = [USER_DEFAULT objectForKey:@"password"];
        _my_cookie = [USER_DEFAULT objectForKey:@"cookies"];
        _phoneNumber = [USER_DEFAULT objectForKey:@"phoneNumber"];
    }
    return self;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (!singletonUser) {
            singletonUser = [super allocWithZone:zone];
            return singletonUser;
        }
    }
    return nil;
}

#pragma mark - public methods.....
+ (id)sharedUser
{
    @synchronized (self){
        if (!singletonUser) {
            singletonUser = [[UserModel alloc] init];
            return singletonUser;
        }
    }
    return singletonUser;
}

- (NSString *)isNeedUpdateAddress
{
    if ([USER_DEFAULT objectForKey:@"currentVno"]) {
        return [USER_DEFAULT objectForKey:@"currentVno"];
    }else {
        return @"";
    }
}
- (BOOL)saveToLocal
{
    [USER_DEFAULT setObject:_uid forKey:UserId];
    [USER_DEFAULT setObject:_password forKey:UserPwd];
    [USER_DEFAULT setObject:_userName forKey:@"usrName"];
    [USER_DEFAULT setObject:_log_name forKey:@"phoneNumber"];
    [USER_DEFAULT setObject:_password forKey:@"password"];
    [USER_DEFAULT setObject:_my_cookie forKey:@"cookies"];
    [USER_DEFAULT synchronize];
    return YES;
}

@end
