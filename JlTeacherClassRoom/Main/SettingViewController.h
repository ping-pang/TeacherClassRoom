//
//  SettingViewController.h
//  JlTeacherClassRoom
//
//  Created by app on 16/1/11.
//  Copyright © 2016年 app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : JLBaseViewController
@property(nonatomic,strong)NSFileManager   *setupHelpFm;//"设置帮组"缓存fm
@property(nonatomic,copy) NSString    *setupHelpPath;//"设置帮组"缓存fm
@property(nonatomic,strong)NSMutableArray *setupHelpArr;//"设置帮组"缓存数据
@end
