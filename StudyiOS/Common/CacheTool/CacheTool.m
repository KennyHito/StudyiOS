//
//  CacheTool.m
//  StudyiOS
//
//  Created by Apple on 2023/11/8.
//

#import "CacheTool.h"

@implementation CacheTool
/* 返回多少M*/
+ (NSString *)showCache{
    return [NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()]]];
}

/* 清除缓存*/
+ (void)clearCache{
    [self clearCacheFromPath:[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()]];
}

/* 返回缓存的大小 */
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/* 遍历文件夹获得文件夹大小 */
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    //通过枚举遍历法遍历文件夹中的所有文件
    //创建枚举遍历器
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    //首先声明文件名称、文件大小
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //得到当前遍历文件的路径
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        //调用封装好的获取单个文件大小的方法
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);//转换为多少M进行返回
}

/* 清除缓存大小 打印NSHomeDritiony前往Documents进行查看路径*/
+ (void)clearCacheFromPath:(NSString*)path{
    //建立文件管理器
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        //如果文件路径存在 获取其中所有文件
        NSArray * fileArr = [manager subpathsAtPath:path];//找到所有子文件的路径，存到数组中。
        //首先需要转化为完整路径
        //直接删除所有子文件
        for (int i = 0; i < fileArr.count; i++) {
            NSString * fileName = fileArr[i];
            //完整路径
            NSString * filePath = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:filePath error:nil];
        }
    }
}
@end
