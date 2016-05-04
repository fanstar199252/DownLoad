//
//  DownLoad.h
//  load
//
//  Created by lanou on 16/4/12.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DownLoad : NSObject

//监控下载进度
@property (nonatomic, copy) void (^downLoding)(float );

//下载完成的Block,将下载地址和文件本地路径传出
@property (nonatomic, copy) void (^finishDownLoad)(NSString *url, NSString *savePath);

//自定义初始化方法，传入下载的地址
- (instancetype)initWithUrl:(NSString *)urlString;

//开始下载
- (void) start;

//暂停下载
- (void) pause;




@end
