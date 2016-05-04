//
//  DownLoadManager.h
//  load
//
//  Created by lanou on 16/4/12.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoad.h"
@interface DownLoadManager : NSObject


// 单例方法
+(instancetype ) defaultManager;

//添加下载对象的方法
- (DownLoad *)addDownLoadWith:(NSString *)url;

//移除完成的下载对象
- (void) removeFinishDownload:(NSString *)url;

//获取所有的下载对象
- (NSArray *)findAllDownLoad;


@end
