//
//  DatabaseManage.m
//  JLPlatform
//
//  Created by Mac Os on 15/5/15.
//  Copyright (c) 2015年 zzm. All rights reserved.
//

#import "DatabaseManage.h"
#import "FMDatabaseAdditions.h"
//#import "JLShopModel.h"

@implementation DatabaseManage
+ (DatabaseManage *)sharedManager {
    static DatabaseManage *dbmanage = nil;
    static dispatch_once_t predicate;
     dispatch_once(&predicate, ^{
        dbmanage = [[self alloc] init];
    });
    return dbmanage;
}

- (id)init
{
    if (self = [super init]) {
        [self createDatabase];
        [self createMessageTable];
//        [self createAddressTable];
        [self createHistoryTable];
    }
    return self;
}

- (void)createDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    CLog(@"数据库路径: %@,",dbPath);
    _db = [FMDatabase databaseWithPath:dbPath] ;
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return ;
    }

}

-(void)createAddressTable
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        NSLog(@"数据库打开失败！");
        return;
    }
    [_db setShouldCacheStatements:YES];
    NSString * tableName=@"AddressTable";
    if (![_db tableExists:@"AddressTable"]) {
//        BOOL  flag =  [_db executeUpdate:@"create table AddressTable(procode TEXT, proname TEXT,citycode TEXT,cityname TEXT,areacode TEXT,areaname TEXT,schoolcode TEXT,schoolname TEXT,gradeid TEXT,gradecode TEXT,gradename TEXT,classcode TEXT,classname TEXT) "];
//        if (flag) {
//            NSLog(@"AddressTable create success!!");
//        }
        
        NSArray * colums=@[@"_id integer primary key autoincrement",
                           @"procode     text",
                           @"proname     text",
                           @"citycode    text",
                           @"cityname    text",
                           @"areacode    text",
                           @"areaname    text",
                           @"schoolcode  text",
                           @"gradeid     text",
                           @"gradecode   text",
                           @"gradename   text",
                           @"classcode   text",
                           @"classname   text",
                           ];
        NSArray * indexs=@[@"procode",
                           @"proname",
                           @"citycode",
                           @"cityname",
                           @"areacode",
                           @"areaname",
                           @"schoolcode",
                           @"gradeid",
                           @"gradecode",
                           @"gradename",
                           @"classcode",
                           @"classname",
                           ];
        BOOL result =[self createTable1:tableName columns:colums indexes:indexs whithDb:_db];
        if (result) {
            CLog(@"创建地址表成功");
        }
    }

}
-(BOOL)createTable1:(NSString *)table columns:(NSArray *)columns indexes:(NSArray *)indexes whithDb:(FMDatabase *)db
{
    BOOL success    = true;
    BOOL shouldDrop = false;
    NSString *ddl   = [NSString stringWithFormat:@"select count(*)"
                       " from sqlite_master"
                       " where type ='table' and name = '%@'", table];
    FMResultSet *rs = [db executeQuery:ddl];
    
    if ([rs next]
        && [rs intForColumnIndex:0]
        ) {
        shouldDrop = true;
    }
    
    [rs close];
    
    if (shouldDrop) {
        ddl     = [NSString stringWithFormat:@"DROP TABLE %@", table];
        success = success && [db executeUpdate:ddl];
    }
    
    //根据columns数组拼DDL，所有columns均设置为NOT NULL
    NSMutableArray *notNullColumns = [NSMutableArray arrayWithCapacity:columns.count];
    
    [columns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            return;
        }
        
        NSString *c = (NSString *)obj;
        NSString *d = nil;
        
        if ([c hasSuffix:@"text"]) {
            d = @" NOT NULL DEFAULT ''";
            
        } else if ([c hasSuffix:@"integer"]
                   || [c hasSuffix:@"real"]
                   || [c hasSuffix:@"numeric"]
                   ) {
            d = @" NOT NULL DEFAULT 0";
        } else if ([c hasSuffix:@"integer primary key autoincrement"]){
            d = @" NOT NULL DEFAULT 0";
        }
        
        [notNullColumns addObject:[obj stringByAppendingString:d]];
    }];
    
    //拼出CREATE TABLE语句
    ddl     = [NSString stringWithFormat:@"CREATE TABLE %@(%@)", table, [notNullColumns componentsJoinedByString:@", "]];
    success = success && [db executeUpdate:ddl];
    
    //建立索引
    for (NSString *idx in indexes) {
        ddl     = [NSString stringWithFormat:@"CREATE INDEX %@_%@_idx ON %@(%@)", table, idx, table, idx];
        success = success && [db executeUpdate:ddl];
    }
    
    return success;
}
//- (void)insertAddress:(ProviceDataModel *)provice
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return ;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return ;
//    }
//    [_db open];
//    [_db executeUpdate:@"INSERT INTO AddressTable(procode,proname,citycode,cityname,areacode,areaname,schoolcode,schoolname,gradeid,gradecode,gradename,classcode,classname) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",provice.provincecode,provice.provincename,provice.citycode,provice.cityname,provice.areacode,provice.areaname,provice.schoolcode,provice.schoolname,provice.gradeid,provice.gradecode,provice.gradename,provice.classcode,provice.classname];
////    CLog(@"插入了一个学校 %@",provice.schoolname);
//    [_db close];
//}


//- (void)insertAddressWithArray:(NSMutableArray *)proviceArray
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return ;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return ;
//    }
//    [_db open];
//    [_db beginTransaction];
//    @try {
//        for (int i = 0;i<proviceArray.count;i++) {
//            ProviceDataModel *provice = proviceArray[i];
////             CLog(@"%d 插入了一个学校 %@ %@ %@",proviceArray.count, provice.schoolname,provice.gradename,provice.classname);
//            [_db executeUpdate:@"INSERT INTO AddressTable(procode,proname,citycode,cityname,areacode,areaname,schoolcode,schoolname,gradeid,gradecode,gradename,classcode,classname) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",provice.provincecode,provice.provincename,provice.citycode,provice.cityname,provice.areacode,provice.areaname,provice.schoolcode,provice.schoolname,provice.gradeid,provice.gradecode,provice.gradename,provice.classcode,provice.classname];
//            
//        }
//
//    }
//    @catch (NSException *exception) {
//          [_db rollback];
//    }
//    @finally {
//          [_db commit];
//    }
//    
//    [_db close];
//}


//- (BOOL)deleteAddress:(ProviceDataModel *)provice
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  NO;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return NO;
//    }
//    BOOL flag = [_db executeUpdate:@"delete from AddressTable where schoolcode = ?",provice.schoolcode];
//    CLog(@"删除了一个学校 %@",provice.schoolname);
//    return flag;
//
//}
//
//- (void)deleteAddressWithArray:(NSMutableArray *)proviceArray
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        
//    }
//    
//    
//    [_db open];
//    [_db beginTransaction];
//    @try {
//        for (ProviceDataModel *provice in proviceArray) {
//            CLog(@" %d 删除了一个学校 %@",proviceArray.count,provice.schoolname);
//            BOOL flag = [_db executeUpdate:@"delete from AddressTable where schoolcode = ?",provice.schoolcode];
//            
//        }
//        
//    }
//    @catch (NSException *exception) {
//        [_db rollback];
//    }
//    @finally {
//        [_db commit];
//    }
//}


//-(BOOL)queryAddressIsVaild:(AddressDataModel *)address
//{
//    [_db open];
//    NSString *sql = [NSString stringWithFormat:@"select * from AddressTable where procode=%@ and citycode = %@ and areacode= %@ and schoolcode= %@  and gradeid = %@ and classcode = %@",address.provincecode,address.citycode,address.areacode,address.schoolcode,address.gradeid,address.classcode];
//    CLog(@"%@",sql);
//    
//    FMResultSet *rs = [_db executeQuery:sql];
//    
//    while ([rs next]) {
//        if ([[rs stringForColumn:@"schoolname"] isEqualToString:address.schoolname] && [[rs stringForColumn:@"gradename"] isEqualToString:address.gradename ]&& [address.classname isEqualToString:[rs stringForColumn:@"classname"]]) {
//            return YES;
//        }
//        
//    }
//    [rs close];
//    [_db close];
//    return NO;
//}
//- (NSArray *)queryProvince
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  nil;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return  nil;
//    }
//    [_db open];
//    __block NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
//    NSMutableArray *codeArray = [[NSMutableArray alloc] initWithCapacity:0];
//    FMResultSet *rt = [_db executeQuery:@"select * from AddressTable order by procode ASC"];
//    while ([rt next]) {
//        ProviceDataModel *model = [[ProviceDataModel  alloc] init];
//        model.provincecode = [rt stringForColumn:@"procode"];
//        model.provincename = [rt stringForColumn:@"proname"];
//        
//        if (![codeArray containsObject:model.provincecode]) {
//            [provinceArray addObject:model];
//            [codeArray addObject:model.provincecode];
//        }
//         model=nil;
//    }
//    [rt close];
//    [_db close];
//    NSLog(@"select province num is %d",provinceArray.count);
//    return [NSArray arrayWithArray:provinceArray];
//}


//- (NSMutableArray *)queryCityWithProcode:(NSString *)procode
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  nil;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return  nil;
//    }
//    __block NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
//    NSMutableArray *codeArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [_db open];
//    NSString *sql = [NSString stringWithFormat:@"select citycode,cityname from AddressTable where procode = %@ order by citycode ASC",procode];
//    FMResultSet *rt = [_db executeQuery:sql];
//    NSLog(@"%@",rt);
//    while ([rt next]) {
//        
//        ProviceDataModel *model = [[ProviceDataModel  alloc] init];
//        model.citycode = [rt stringForColumn:@"citycode"];
//        model.cityname = [rt stringForColumn:@"cityname"];
//        
//        if (![codeArray containsObject:model.citycode]) {
//            [provinceArray addObject:model];
//            [codeArray addObject:model.citycode];
//        }
//         model=nil;
//    }
//    [rt close];
//    [_db close];
//    return provinceArray;
//}


//- (NSMutableArray *)queryAreasWithCitycode:(NSString *)citycode 
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  nil;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return  nil;
//    }
//    [_db open];
//    __block NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
//    NSMutableArray *codeArray = [[NSMutableArray alloc] initWithCapacity:0];
//    NSString *sql = [NSString stringWithFormat:@"select areacode,areaname from AddressTable where citycode = %@ order by areacode ASC",citycode];
//    FMResultSet *rt = [_db executeQuery:sql];
//    while ([rt next]) {
//        ProviceDataModel *model = [[ProviceDataModel  alloc] init];
//        model.areacode = [rt stringForColumn:@"areacode"];
//        model.areaname = [rt stringForColumn:@"areaname"];
//        if (![codeArray containsObject:model.areacode]) {
//            [provinceArray addObject:model];
//            [codeArray addObject:model.areacode];
//        }
//         model=nil;
//    }
//    [rt close];
//    [_db close];
//    NSLog(@"areaList count is %d",provinceArray.count);
//    return provinceArray;
//    
//}

//- (NSMutableArray *)querySchoolsWithAreacode:(NSString *)areacode
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  nil;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return  nil;
//    }
//    [_db open];
//     __block NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
//    NSMutableArray *codeArray = [[NSMutableArray alloc] init];
//    NSString *sql = [NSString stringWithFormat:@"select schoolcode,schoolname from AddressTable where areacode = %@ order by schoolcode ASC",areacode];
//    FMResultSet *rt = [_db executeQuery:sql];
//    while ([rt next]) {
//        ProviceDataModel *model = [[ProviceDataModel  alloc] init];
//        model.schoolcode = [rt stringForColumn:@"schoolcode"];
//        model.schoolname = [rt stringForColumn:@"schoolname"];
//        if (![codeArray containsObject:model.schoolcode]) {
//            [provinceArray addObject:model];
//            [codeArray addObject:model.schoolcode];
//        }
//         model=nil;
//    }
//    [rt close];
//    [_db close];
//    NSLog(@"schoolList  count is %d",provinceArray.count);
//    return provinceArray;
//}

//- (NSMutableArray *)queryGradesWithSchoolcode:(NSString *)schoolcode areaCode:(NSString *)areacode
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  nil;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return  nil;
//    }
//    [_db open];
//    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
//    NSMutableArray *codeArray = [[NSMutableArray alloc] initWithCapacity:0];
//    NSString *sql = [NSString stringWithFormat: @"select gradeid,gradecode,gradename from AddressTable where schoolcode = %@ and areacode = %@ order by gradecode ASC",schoolcode,areacode];
//    NSLog(@" sql is %@",sql);
//    FMResultSet *rt = [_db executeQuery:sql];
//    while ([rt next]) {
//        ProviceDataModel *model = [[ProviceDataModel  alloc] init];
//        model.gradecode = [rt stringForColumn:@"gradecode"];
//        model.gradename = [rt stringForColumn:@"gradename"];
//        model.gradeid = [rt stringForColumn:@"gradeid"];
//        
//        if (![codeArray containsObject:model.gradecode]) {
//            [provinceArray addObject:model];
//            [codeArray addObject:model.gradecode];
//        }
//         model=nil;
//        
//    }
//    [rt close];
//    [_db close];
//    CLog(@"gradeList  count is %d",provinceArray.count);
//    return provinceArray;
//}

//- (NSMutableArray *)queryClassesWithGradecode:(NSString *)gradecode schoolCode:(NSString *)schoolcode areaCode:(NSString *)areacode
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  nil;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"AddressTable"]) {
//        return  nil;
//    }
//    [_db open];
//    __block NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
//    NSMutableArray *codeArray = [[NSMutableArray alloc] init];
//    
//    NSString *sql = [NSString stringWithFormat:@"select classcode,classname from AddressTable where gradeid= %@ and schoolcode = %@ and areacode = %@ order by classcode ASC",gradecode,schoolcode,areacode];
//    NSLog(@"%@",sql);
//    FMResultSet *rt = [_db executeQuery:sql];
//    while ([rt next]) {
//        ProviceDataModel *model = [[ProviceDataModel  alloc] init];
//        model.classcode = [rt stringForColumn:@"classcode"];
//        model.classname = [rt stringForColumn:@"classname"];
//        if (![codeArray containsObject:model.classcode]) {
//            [provinceArray addObject:model];
//            [codeArray addObject:model.classcode];
//        }
//        model=nil;
//    }
//    [rt close];
//    [_db close];
//     CLog(@"classList  count is %d  %@",provinceArray.count,provinceArray);
//    return provinceArray;
//}

- (BOOL)clearAddressTable
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM AddressTable"];
    if (![_db executeUpdate:sqlstr])
    {
        return NO;
    }
    NSLog(@"删除了 地址表数据");
    return YES;

}
#pragma  mark -------MessageTable-----------
- (void)createMessageTable
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        NSLog(@"数据库打开失败！");
        return;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MessageTable"]) {
        BOOL  flag =  [_db executeUpdate:@"create table MessageTable(id INTEGER PRIMARY KEY,messageid  INTEGER, content TEXT, title TEXT,imgurl TEXT,date TEXT,isread INTEGER,userid TEXT) "];
        if (flag) {
            CLog(@"MessageTable create success!!");
        }
    }else{
        //备份一下
        
    }
    
}

- (void)insertMessage:(MessageModel *)message withUserId:(NSString*)userId
{
    if (!message) {
        return;
    }
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        NSLog(@"数据库打开失败！");
        return ;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MessageTable"]) {
        return ;
    }
//    CLog(@"userid==%@消息id====%@",userId,message.messageId);
    FMResultSet *rs = [_db executeQuery:@"select * from MessageTable where messageid = ? and userid = ?",[NSNumber numberWithInt:[message.messageId intValue]],userId];
    if ([rs next]) {
//        CLog(@"不需要插入消息表中");
    }else{
//        CLog(@"000需要插入消息表中");
//        NSString * sqlStr=[NSString stringWithFormat:@"insert into MessageTable messageid ,content,title,imgurl,date,isread,userid",]
        [_db executeUpdate:@"insert into MessageTable(messageid,content,title,imgurl,date,isread,userid) values (?,?,?,?,?,?,?)",message.messageId,message.content,message.title,message.imgUrl,message.time,[NSNumber numberWithInt:message.isRead],userId];
    }
    [rs close];
    [_db close];
}


- (void)updateMessageIsRead:(NSInteger)isread withMessageId:(NSString *)messageId withUserId:(NSString*)uid
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return ;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MessageTable"]) {
        return ;
    }
    BOOL flag = [_db executeUpdate:@"update MessageTable set isread = ? where messageid = ? and userid = ?",[NSNumber numberWithInt:isread],[NSNumber numberWithInt:[messageId integerValue]],uid];
    if (flag) {
        CLog(@"update message isread success!!");
    }
    
}

- (NSMutableArray *)queryMessagesWithNoread
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return nil;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MessageTable"]) {
        return nil;
    }
   __block NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from MessageTable where isread = %d",0];
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        MessageModel *message = [[MessageModel alloc] init];
        message.messageId = [NSString stringWithFormat:@"%d",[rs intForColumn:@"messageid"]];
        message.content = [rs stringForColumn:@"content"];
        message.time = [rs stringForColumn:@"date"];
        message.title = [rs stringForColumn:@"title"];
        message.isRead = [rs intForColumn:@"isread"];
        message.imgUrl = [rs stringForColumn:@"imgurl"];
        [messageArray addObject:message];
    }
    CLog(@"%lu",(unsigned long)messageArray.count);
    return messageArray;
}
- (BOOL)deleteMessageWithId:(NSString *)messageId WithUserId:(NSString*)userId
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        NSLog(@"数据库打开失败！");
        return  NO;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MessageTable"]) {
        return NO;
    }
    BOOL flag = [_db executeUpdate:@"delete from MessageTable where messageid = ? and userid = ?",[NSNumber numberWithInt:[messageId intValue]],userId];
    return flag;
}
#pragma mark--查看所所有消息
- (NSMutableArray *)queryMessagesWithUserId:(NSString*)userId;
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return nil;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MessageTable"]) {
        return nil;
    }
   __block  NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQuery:@"select * from MessageTable where userid = ?",userId];
    while ([rs next]) {
        MessageModel *message = [[MessageModel alloc] init];
        message.messageId = [NSString stringWithFormat:@"%d",[rs intForColumn:@"messageid"]];
        message.content = [rs stringForColumn:@"content"];
        message.time = [rs stringForColumn:@"date"];
        message.title = [rs stringForColumn:@"title"];
        message.isRead = [rs intForColumn:@"isread"];
        message.imgUrl = [rs stringForColumn:@"imgurl"];
        [messageArray addObject:message];
    }
    
    return messageArray;
}
- (NSMutableArray *)queryUnreadMessagesWithUserId:(NSString*)userId
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return nil;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MessageTable"]) {
        return nil;
    }
    __block  NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQuery:@"select * from MessageTable where isread = '0' and userid = ? ",userId];
    while ([rs next]) {
        MessageModel *message = [[MessageModel alloc] init];
        message.messageId = [NSString stringWithFormat:@"%d",[rs intForColumn:@"messageid"]];
        message.content = [rs stringForColumn:@"content"];
        message.time = [rs stringForColumn:@"date"];
        message.title = [rs stringForColumn:@"title"];
        message.isRead = [rs intForColumn:@"isread"];
        message.imgUrl = [rs stringForColumn:@"imgurl"];
        [messageArray addObject:message];
    }
    
    return messageArray;
}

- (BOOL)clearMessageTable
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM MessageTable"];
    if (![_db executeUpdate:sqlstr])
    {

        return NO;
    }
    CLog(@"删除了 消息表数据");
    return YES;

}

#pragma mark ------------------------HistroryTable Edit ---------------------------

- (void)createHistoryTable
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        NSLog(@"数据库打开失败！");
        return;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"HistoryTable"]) {
        BOOL  flag =  [_db executeUpdate:@"create table HistoryTable(shopid TEXT, shopname TEXT, userid TEXT,date TEXT)"];
        if (flag) {
            CLog(@"HistoryTable create success!!");
//            [self insertHistoryWith:@"11" name:@"mane"];
        }
    }

}
- (void)insertShopHistoryWithShopId:(NSString*)shopid withShopName:(NSString*)shopName withDate:(NSString*)date love:(NSString *)love{
    NSString * uid=[[UserModel sharedUser] uid];//[[User sharedUser] uid];
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"打开数据库失败");
        return;
    }
    [_db setShouldCacheStatements:YES];
    if (![_db tableExists:@"HistoryTable"]) {
        return ;
    }
////    [_db executeUpdate:@"insert into MessageTable(messageid,content,title,imgurl,date,isread) values (?,?,?,?,?,?)",message.messageId,message.content,message.title,message.imgUrl,message.time,[NSNumber numberWithInt:message.isRead]];
//    NSString * sqlStr=[NSString stringWithFormat:@"INSERT INTO HistoryTable (shopid,shopname,userid,date) VALUES ('%@','%@','%@','%@')",shopid,shopName,uid,date];
    NSString * sqlStr=@"";
    NSString * selectStr=[NSString stringWithFormat:@"select * from HistoryTable where shopid = '%@' and userid = '%@'",shopid,uid];
    FMResultSet *rs = [_db executeQuery:selectStr];
    if ([rs next]) {
        //只需要更新时间就可以
//        update classDB set name = '%@',phone = '%@',age = %d where ID = %d",name,phone,age,ID
        sqlStr=[NSString stringWithFormat:@"update  HistoryTable set date = '%@' where shopid = '%@' and userid = '%@' ",date,shopid,uid];
    }else{
        sqlStr=[NSString stringWithFormat:@"insert into HistoryTable(shopid,shopname,userid,date)values('%@','%@','%@','%@')",shopid,shopName,uid,date];
    }
//    [_db executeUpdate:sqlStr];

    BOOL loveYES=[_db executeUpdate:sqlStr];
    if (loveYES==YES &&![love isEqualToString:@""]) {
        CLog(@"存入数据库");
    }
    [_db close];
    
}
-(NSMutableArray *)queryHistoryWith:(NSString*)userid{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return nil;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"HistoryTable"]) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from HistoryTable where userid = '%@' order by date desc",userid];
    __block NSMutableArray *shopDic = [[NSMutableArray alloc] init];
    NSMutableArray * shopArray=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray * shopIDArr=[NSMutableArray arrayWithCapacity:0];
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
//        JLShopModel * model=[[JLShopModel alloc]init];
//        model.shopID=[rs stringForColumn:@"shopid"];
//        model.shopName=[rs stringForColumn:@"shopname"];
//        model.shopDate=[rs stringForColumn:@"date"];
//        [shopIDArr addObject:model.shopID];
//        [shopArray addObject:model];
    }
    [rs close];

    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    NSString *sql1 = [NSString stringWithFormat:@"select date from HistoryTable where userid = '%@' order by date desc",userid];
    FMResultSet *rt = [_db executeQuery:sql1];
    while ([rt next]) {
        NSString *date = [rt stringForColumn:@"date"];
        if (![dateArray containsObject:date]) {
            [dateArray addObject:date];
        }
    }
    [rt close];
    [_db close];

    for (NSString *dateString in dateArray) {
        
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
//        for (JLShopModel *model in shopArray) {
//            if ([dateString isEqualToString:model.shopDate]) {
//                [timeArray addObject:model];
//            }
//        }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:timeArray,dateString, nil];
        [shopDic  addObject:dic];
    }
    CLog(@"history count is %lu",(unsigned long)shopDic.count);
    return shopDic;

    
}
- (BOOL)clearHistoryTable
{
    
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return NO;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"HistoryTable"]) {
        return NO;
    }
//    User *user=[User sharedUser];
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM HistoryTable WHERE userid = '%@'",[[UserModel sharedUser] uid]];
     BOOL flag = [_db executeUpdate:sqlstr];
    if (flag) {
        CLog(@"删除了 历史表数据");
    }
    return flag;
}
- (BOOL)clearHistoryTableWithShopName:(NSString *)shopName
{
     NSString * uid=[[UserModel sharedUser] uid];
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return NO;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"HistoryTable"]) {
        return NO;
    }
    NSString * sqlTr=[NSString stringWithFormat:@"DELETE FROM HistoryTable WHERE shopid = '%@' and userid = '%@'",shopName,uid];
     BOOL flag =[_db executeUpdate:sqlTr];
    if (flag) {
        CLog(@"删除了 历史表数据%@",shopName);
    }
    return flag;
}

#pragma mark MyADDressTable
- (void)createMyAddressTable
{
    if (!_db) {
        [self createDatabase];
    }
    if (![_db open]) {
        CLog(@"数据库打开失败！");
        return;
    }
    [_db setShouldCacheStatements:YES];
    
    if (![_db tableExists:@"MyAddressTable"]) {
        BOOL  flag =  [_db executeUpdate:@"create table MyAddressTable(addid TEXT, address  TEXT,addressType TEXT,isdefault TEXT,loginname TEXT,receivename TEXT,  procode TEXT, proname TEXT,citycode TEXT,cityname TEXT,areacode TEXT,areaname TEXT,schoolcode TEXT,schoolname TEXT,gradeid TEXT,gradecode TEXT,gradename TEXT,classcode TEXT,classname TEXT) "];
        if (flag) {
            CLog(@"MyAddressTable create success!!");
        }
    }

}

//- (void)insertMyAddressWithData:(AddressDataModel *)provice
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return ;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"MyAddressTable"]) {
//        return ;
//    }
//    [_db open];
//    [_db executeUpdate:@"INSERT INTO MyAddressTable(addid , address ,addressType ,isdefault ,loginname ,receivename ,procode,proname,citycode,cityname,areacode,areaname,schoolcode,schoolname,gradeid,gradecode,gradename,classcode,classname) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",provice.shoppingAddressId,provice.address,provice.addressType,provice.isdefault,provice.loginName,provice.receiveName,provice.provincecode,provice.provincename,provice.citycode,provice.cityname,provice.areacode,provice.areaname,provice.schoolcode,provice.schoolname,provice.gradeid,provice.gradecode,provice.gradename,provice.classcode,provice.classname];
//    [_db close];
//
//}

//- (NSMutableArray *)queryMyAddress
//{
//    if (!_db) {
//        [self createDatabase];
//    }
//    if (![_db open]) {
//        NSLog(@"数据库打开失败！");
//        return  nil;
//    }
//    [_db setShouldCacheStatements:YES];
//    
//    if (![_db tableExists:@"MyAddressTable"]) {
//        return  nil;
//    }
//    [_db open];
//    __block NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
//    NSMutableArray *codeArray = [[NSMutableArray alloc] initWithCapacity:0];
//    FMResultSet *rt = [_db executeQuery:@"select * from MyAddressTable"];
//    while ([rt next]) {
//        AddressDataModel *model = [[AddressDataModel  alloc] init];
//        /*addid , address ,addressType ,isdefault ,loginname ,receivename ,procode,proname,citycode,cityname,areacode,areaname,schoolcode,schoolname,gradeid,gradecode,gradename,classcode,classname*/
//        
//        model.address = [rt stringForColumn:@"address"];
//        model.addressType = [rt stringForColumn:@"addressType"];
//        model.citycode = [rt stringForColumn:@"citycode"];
//        model.cityname = [rt stringForColumn:@"cityname"];
//        model.provincecode = [rt stringForColumn:@"procode"];
//        model.provincename = [rt stringForColumn:@"proname"];
//        model.areacode = [rt stringForColumn:@"areacode"];
//        model.areaname = [rt stringForColumn:@"areaname"];
//        model.schoolcode = [rt stringForColumn:@"schoolcode"];
//        model.schoolname = [rt stringForColumn:@"schoolname"];
//        model.gradeid = [rt stringForColumn:@"gradeid"];
//        model.gradecode = [rt stringForColumn:@"gradecode"];
//        model.gradename = [rt stringForColumn:@"gradename"];
//        model.classcode = [rt stringForColumn:@"classcode"];
//        model.classname = [rt stringForColumn:@"classname"];
//        model.isdefault =[rt stringForColumn:@"isdefault"];
//        model.receiveName = [rt stringForColumn:@"receivename"];
//        model.shoppingAddressId = [rt stringForColumn:@"addid"];
//        model.loginName =[rt stringForColumn:@"loginname"];
//        
//        if (![codeArray containsObject:model.shoppingAddressId]) {
//            [provinceArray addObject:model];
//            [codeArray addObject:model.shoppingAddressId];
//        }
//    }
//    [rt close];
//    [_db close];
//    CLog(@"select province num is %d",provinceArray.count);
//    return provinceArray;
//}

@end
