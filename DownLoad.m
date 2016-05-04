//
//  DownLoad.m
//  load
//
//  Created by lanou on 16/4/12.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DownLoad.h"


//延展
@interface DownLoad ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *reData;//用来保存断点数据
@property (nonatomic, copy) NSString *urlstring;//用来保存下载地址
@end

@implementation DownLoad

- (instancetype)initWithUrl:(NSString *)urlString
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.urlstring = urlString;
//        self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:urlString]];
        
    }
    return self;
}


//创建下载文件的路径，用来保存缓存数据，第一个作用，用来保存断点数据（下载中使用）， 第二个作用是用了保存最后下载完成的文件（下载完成后会将保存的断点数据进行覆盖）
- (NSString *) creatFilePath{
    NSString *cashes = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    //创建视频文件夹
    NSString *vidoPath = [cashes stringByAppendingPathComponent:@"video.MP4"];
    //创建文件夹路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:vidoPath]) {
        [fileManager createDirectoryAtPath:vidoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //在创建task时因为task还为空，找不到建议的文件名
    NSArray *array = [self.urlstring componentsSeparatedByString:@"/"];
    
    //创建视频文件路径
    NSString *filePath = [vidoPath stringByAppendingPathComponent:[array lastObject]];

    return filePath;

}





- (void) start {
    //断点
    if (self.downloadTask == nil) {
        //从文件中读取断点数据
        self.reData = [NSData dataWithContentsOfFile:[self creatFilePath]];
        if (self.reData == nil) {
        self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.urlstring]];//如果读取的数据为空就通过网址重新下载
        }else{
            self.downloadTask = [self.session downloadTaskWithResumeData:self.reData];//如果获取的数据不为空，就接着这个数据下载
        }
    }
        [self.downloadTask resume];
    
//    NSLog(@"%@",NSHomeDirectory());
    
}

//暂停
- (void) pause {
    //不能调用cancel  , cancel 是取消任务
//    [self.downloadTask suspend];
    
    //断点下载，
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.reData = resumeData;//1.保存断点数据，获取新的断点数据
        self.downloadTask = nil;//2.将task置空, 因为再次开始时需要用新的断点数据来创建task
        
        //将data保存到本地，防止用户退出应用，内存数据被回收，数据清空
        [self.reData writeToFile:[self creatFilePath] atomically:YES];
    }];
    
}

#pragma mark------代理方法--------

//必须要实现的协议方法，下载完成时才会被调用,将缓存数据保存到Caches文件夹
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //先把缓存的数据清空
    [[NSFileManager defaultManager] removeItemAtPath:[self creatFilePath] error:nil];
    //再将下载的数据移到文件路径下
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:[self creatFilePath] error:nil];
    //下载完成后通过Block将文件的网络路径和本地路径传出
    self.finishDownLoad(self.urlstring, [self creatFilePath]);
    
}


//写入文件
//didWriteData 本次写入的字节数
//totoalBytesWritten 总共写入的字节数
//totalBytesExpectedToWrite 下载的文件的总字节数

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    //获取下载进度，前小后大，要是整数值一直为0，所以第一个值要为小数值才为小数
   float progress = totalBytesWritten * 1.0  / totalBytesExpectedToWrite;
    //将进度值传出
    self.downLoding(progress);
   
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

//请求数据完成， 成功或失败都会走的方法，有错误提示，有错误信息就是失败，没有就是成功
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"error = %@", error);
}

@end
