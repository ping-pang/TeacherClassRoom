//
//  UserModel.h
//  JlTeacherClassRoom
//
//  Created by app on 15/12/1.
//  Copyright © 2015年 app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *log_name;
@property (nonatomic, strong) NSString *my_cookie;
@property (nonatomic, strong) NSString *phoneNumber;

+ (id)sharedUser;
- (BOOL)saveToLocal;
@end
