//
//  PublishPushViewController.h
//  JlTeacherClassRoom
//
//  Created by myl on 16/1/5.
//  Copyright © 2016年 app. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^reloadWeb)(NSString *str);
@interface PublishPushViewController : JLBaseViewController
@property(nonatomic,copy)reloadWeb reloadBlock;
-(void)returnReload:(reloadWeb)block;
@end
