//
//  AppPreFerence.m
//  JlTeacherClassRoom
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 app. All rights reserved.
//

#import "AppPreFerence.h"
#define PwdRemembered @"userPwdIsRememberedByUserDefault"
#define LoginAutomatically @"loginAutomatically"
#define UserLoggedIn @"aUserIsLoggedInThisApp"
static AppPreFerence *sharedPreference = nil;

@implementation AppPreFerence
- (id)init
{
    if (self = [super init]) {
       
        _pwdRemembered = [USER_DEFAULT boolForKey:PwdRemembered];
        _loginAutomatically = [USER_DEFAULT boolForKey:LoginAutomatically];
        _userLoggedin = [USER_DEFAULT boolForKey:UserLoggedIn];
       
        return self;
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self){
        if (!sharedPreference) {
            sharedPreference = [super allocWithZone:zone];
            return sharedPreference;
        }
    }
    return nil;
}
+ (id)sharedAppPreference
{
    @synchronized (self){
        if (!sharedPreference) {
            sharedPreference = [[AppPreFerence alloc] init];
            return sharedPreference;
        }
    }
    return sharedPreference;
}
- (BOOL)saveToLocal
{
    
    [USER_DEFAULT setBool:_pwdRemembered forKey:PwdRemembered];
    [USER_DEFAULT setBool:_loginAutomatically forKey:LoginAutomatically];
    [USER_DEFAULT setBool:_userLoggedin forKey:UserLoggedIn];
    
    
    /***************清空用户关键数据****************/
    [USER_DEFAULT setObject:@"" forKey:UserId];
    [USER_DEFAULT setObject:@"" forKey:UserPwd];
    [USER_DEFAULT setObject:@"" forKey:@"cookies"];
    [USER_DEFAULT setObject:@"" forKey:@"buyPassword"];
    /*******************************/
    [USER_DEFAULT setBool:_avAccessed forKey:AVAcessed];

    
    
    [USER_DEFAULT synchronize];
    return YES;
}
@end
