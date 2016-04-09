//
//  DBManager.m
//  manbu-shx
//
//  Created by 张摇奖 on 15-5-13.
//  Copyright (c) 2015年 john. All rights reserved.
//

#import "DBManager.h"

#define debugMethod(...) NSLog((@"In %s,%s [Line %d] "), __PRETTY_FUNCTION__,__FILE__,__LINE__,##__VA_ARGS__)

static FMDatabase *shareDataBase = nil;

@implementation DBManager


/**
 创建数据库类的单例对象
 
 **/
+ (FMDatabase *)createDataBase {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shareDataBase = [FMDatabase databaseWithPath:dataBasePath];
		[DBManager createTableStrip];
	});
	return shareDataBase;
}

/**
 关闭数据库
 **/
+ (void)closeDataBase {
	if(![shareDataBase close]) {
		NSLog(@"数据库关闭异常，请检查");
		return;
	}
}

/**
 判断数据库中表是否存在
 **/
+ (BOOL) isTableExist:(NSString *)tableName
{
	FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
	while ([rs next])
	{
		// just print out what we've got in a number of formats.
		NSInteger count = [rs intForColumn:@"count"];
		NSLog(@"%@ isOK %ld", tableName,(long)count);
		
		if (0 == count)
		{
			return NO;
		}
		else
		{
			return YES;
		}
	}
	
	return NO;
}


+ (BOOL)createTableStrip
{
    if ([shareDataBase open]) {
        if (![DBManager isTableExist:@"Strip"]) {
            NSString *sql = @"CREATE TABLE \"Strip\" (\"zAddress\" TEXT PRIMARY KEY  NOT NULL  check(typeof(\"zAddress\") = 'blob') )";
            [shareDataBase executeUpdate:sql];
        }
        [shareDataBase close];
    }
    return YES;
}
+ (BOOL)saveOrUpdataStrip:(StripProperty *) zStrip
{
    BOOL isOk = NO;
    if ([shareDataBase open]) {
        if ([shareDataBase executeUpdate:[NSString stringWithFormat:@"delete from \"Strip\" WHERE \"zAddress\" = '%@'", zStrip.zAddress]]) {
            isOk = [shareDataBase executeUpdate: @"INSERT INTO \"Strip\" (\"zAddress\" ) VALUES(?)", zStrip.zAddress];
        }
        [shareDataBase close];
    }
    return isOk;
}
+ (NSMutableArray*)selecStrip
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString* strip =@"Strip";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", strip]];
        while([s next]) {
            StripProperty * dev = [[StripProperty alloc] init];
            dev.zAddress =  [s dataForColumn:@"zAddress"];
            [arr addObject:dev];
        }
    }
    [shareDataBase close];
    return arr;
}
+ (BOOL)deleteStripByAddress:(NSData *)zAddress
{
   	BOOL isOK = NO;
    if ([shareDataBase open]) {
        isOK = [shareDataBase executeUpdate:[NSString stringWithFormat:@"delete from \"Strip\" WHERE \"zAddress\" = '%@'", zAddress]];
        [shareDataBase close];
        return isOK;
    }
    return isOK;
}

@end
