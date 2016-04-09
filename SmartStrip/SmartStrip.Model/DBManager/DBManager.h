//
//  DBManager.h
//  manbu-shx
//
//  Created by 张摇奖 on 15-5-13.
//  Copyright (c) 2015年 john. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"dataBase.sqlite"

@interface DBManager : NSObject

/****/
/**
 *	@brief	数据库对象单例方法
 *
 *	@return	返回FMDateBase数据库操作对象
 */
+ (FMDatabase *)createDataBase;


/**
 *	@brief	关闭数据库
 */
+ (void)closeDataBase;

/**
 *	@brief	判断表是否存在
 *
 *	@param 	tableName 	表明
 *
 *	@return	创建是否成功
 */
+ (BOOL) isTableExist:(NSString *)tableName;

/*
 *  Strip
 */
+ (BOOL)createTableStrip;
+ (BOOL)saveOrUpdataStrip:(StripProperty *) zStrip;
+ (NSMutableArray*)selecStrip;
+ (BOOL)deleteStripByAddress:(NSData*)zAddress;

@end
