//
//  DatabaseManage.h
//  JLPlatform
//
//  Created by Mac Os on 15/5/15.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "JLFactory.h"
#import <UIKit/UIKit.h>

@interface DatabaseManage : NSObject
@property (nonatomic,strong)FMDatabase *db;
+ (DatabaseManage *)sharedManager;
/**
 *  创建表的索引
 *
 *  @param table   表名
 *  @param columns 表的属性数组
 *  @param indexes 表的索引数组
 *  @param db      数据库
 *
 *  @return Yes
 */
-(BOOL)createTable1:(NSString *)table columns:(NSArray *)columns indexes:(NSArray *)indexes whithDb:(FMDatabase *)db;

- (void)insertMessage:(MessageModel *)message withUserId:(NSString*)userId;
- (NSMutableArray *)queryMessagesWithUserId:(NSString*)userId;
- (NSMutableArray *)queryUnreadMessagesWithUserId:(NSString*)userId;
;
- (BOOL)deleteMessageWithId:(NSString *)messageId WithUserId:(NSString*)userId;
- (void)updateMessageIsRead:(NSInteger)isread withMessageId:(NSString *)messageId withUserId:(NSString*)uid;
- (BOOL)clearMessageTable;
- (NSMutableArray *)queryMessagesWithNoread;


//- (BOOL)queryAddressIsVaild:(AddressDataModel *)address;
//- (void)deleteAddressWithArray:(NSMutableArray *)proviceArray;
//- (void)insertAddressWithArray:(NSMutableArray *)proviceArray;
//- (NSArray *)queryProvince;
//- (void)insertAddress:(ProviceDataModel *)provice;
//- (NSMutableArray *)queryClassesWithGradecode:(NSString *)gradecode schoolCode:(NSString *)schoolcode areaCode:(NSString *)areacode;
//- (NSMutableArray *)queryGradesWithSchoolcode:(NSString *)schoolcode areaCode:(NSString *)areacode;
//- (NSMutableArray *)querySchoolsWithAreacode:(NSString *)areacode;
//- (NSMutableArray *)queryAreasWithCitycode:(NSString *)citycode;
//- (NSMutableArray *)queryCityWithProcode:(NSString *)procode;
//- (BOOL)clearAddressTable;
//- (BOOL)deleteAddress:(ProviceDataModel *)provice;


- (NSMutableArray *)queryHistoryWith:(NSString*)userid;
/**
 *  插入浏览历史记录
 *
 *  @param shopid   商品ID
 *  @param shopName 商品名字
 *  @param date     浏览日期
 */
- (void)insertShopHistoryWithShopId:(NSString*)shopid withShopName:(NSString*)shopName withDate:(NSString*)date love:(NSString *)love;
//- (void)insertHistoryWith:(NSString *)mid name:(NSString *)mname date:(NSString *)date;
- (BOOL)clearHistoryTable;

- (BOOL)clearHistoryTableWithShopName:(NSString *)shopName;

@end


