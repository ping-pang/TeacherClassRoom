//
//  JLHelpBackViewController.h
//  JLClassroom
//
//  Created by JingLun on 15/6/30.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "JLBaseViewController.h"

@interface JLHelpBackViewController : JLBaseViewController

@property(nonatomic,strong)NSMutableArray * dataList;///<数据源

//@property(nonatomic,strong)NSFileManager   *setupDetilFm;///<"设置帮组"缓存fm
//@property(nonatomic,copy) NSString    *setupDetilPath;///<"设置帮组"缓存fm
@property(nonatomic,strong)NSMutableArray *setupDetilArr;///<"设置帮组"缓存数据
@property(nonatomic,strong)NSMutableDictionary *setupHelpDic;//设置帮助信息详细页


@end
