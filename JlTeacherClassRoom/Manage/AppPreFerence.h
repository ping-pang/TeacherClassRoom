//
//  AppPreFerence.h
//  JlTeacherClassRoom
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 app. All rights reserved.
//

#import <Foundation/Foundation.h>
#define AVAcessed @"AdultVideoWatched"

@interface AppPreFerence : NSObject

@property (nonatomic, assign) BOOL pwdRemembered;
@property (nonatomic, assign) BOOL loginAutomatically;          // 自动登陆
@property (nonatomic, assign) BOOL userLoggedin;

@property (nonatomic, assign) BOOL avAccessed;
@property (nonatomic, assign) BOOL notOnlyInWifi;                  // 仅在wifi模式下下载或浏览视频、音频、pdf(no:only wifi)
@property (nonatomic, assign) BOOL isInWifi;               

+ (id)sharedAppPreference;
- (BOOL)saveToLocal;

@end
