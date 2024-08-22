//
//  SQliteManager.m
//  LOLBox
//
//  Created by KennyHito on 16/5/19.
//  Copyright © 2016年 KennyHito. All rights reserved.
//

#import "SQliteManager.h"

@interface SQliteManager()

@property(nonatomic,strong)FMDatabase * dataBase;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation SQliteManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //1.路径
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/menu.db"];
        
        NSLog(@"%@",path);
        
        //2.根据路径创建数据库
        
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        
        //3.判断数据库是否创建成功
        if ([_dataBase open]) {
            NSLog(@"数据库创建成功");
        }else{
            NSLog(@"数据库创建失败");
        }
        //4.创建表
        NSString * createSql = @"create table if not exists menuTable(menuID varchar(64))";
        
        //5.执行语句
        BOOL isOK = [_dataBase executeUpdate:createSql];
        
        if (isOK) {
            NSLog(@"表创建成功");
        }else{
            NSLog(@"表创建失败");
        }
        
    }
    return self;
}

#pragma mark -- 单例实现
+ (instancetype)defaultSqliteManager{
    
    static SQliteManager * manager ;

    //线程GCD
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SQliteManager alloc]init];
    });
    
    return manager;
}

#pragma mark -- 增加
- (BOOL)menuWithID:(NSString *)menuID{
    
    //增加
    NSString * insertSql = @"insert into menuTable(menuID) values(?)";
    //执行
    if ([_dataBase executeUpdate:insertSql,menuID]) {
        NSLog(@"收藏成功");
        return YES;
    }else{
        NSLog(@"收藏失败");
        return NO;
    }
}

#pragma mark -- 判断是否收藏
- (BOOL)isExsitMenuWithID:(NSString *)menuID{
    
    //查询
    NSString * selectSql = @"select * from menuTable where menuID = ?";
    
    FMResultSet * set = [_dataBase executeQuery:selectSql,menuID];
    
    if ([set next]) {
        NSLog(@"已经收藏");
        return YES;
    }else{
        NSLog(@"未收藏");
        return NO;
    }
}

#pragma mark -- 删除功能
- (void)deleteMenuWithID:(NSString *)menuID{
    
    NSString * deleteSql = @"delete from menuTable where menuID = ?";
    if ([_dataBase executeUpdate:deleteSql,menuID]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}


#pragma mark -- 查询功能
- (NSArray *)selectMenuWithID{
    [_dataArr removeAllObjects];
    NSString * selectSql = @"select menuID from menuTable";
    FMResultSet * set = [_dataBase executeQuery:selectSql];
    while([set next]) {
        NSString * myTitle = [set stringForColumn:@"menuID"];
        [self.dataArr addObject:myTitle];
    }
    
    return _dataArr;
}

#pragma mark -- 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

@end
