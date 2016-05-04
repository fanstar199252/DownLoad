//
//  DownLoadManager.m
//  load
//
//  Created by lanou on 16/4/12.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DownLoadManager.h"

@interface DownLoadManager ()

@property (nonatomic, strong ) NSMutableDictionary *downDictionary;//用来保存下载对象

@end
@implementation DownLoadManager


- (NSMutableDictionary *)downDictionary{
    if (!_downDictionary) {
        self.downDictionary = [NSMutableDictionary dictionary];
    }
    return _downDictionary;
}

+(instancetype) defaultManager
{
    static DownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc] init];
    });
    return manager;
}

//添加下载对象的方法
- (DownLoad *)addDownLoadWith:(NSString *)url
{
    //根据地址查找字典中的下载对象，如果不存在要创建新的
    DownLoad *download = [self.downDictionary objectForKey:url];
    if (!download) {
        download = [[DownLoad alloc] initWithUrl:url];
        [self.downDictionary setObject:download forKey:url];
    }
    return download;
}

//移除完成的下载对象
- (void) removeFinishDownload:(NSString *)url
{
    [self.downDictionary removeObjectForKey:url];
}

//获取所有的下载对象
- (NSArray *)findAllDownLoad
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    //遍历字典中的所有下载对象，放到数组中
    for (NSString *url in self.downDictionary) {
        [array addObject:self.downDictionary[url]];
    }
    return array;
}




@end
