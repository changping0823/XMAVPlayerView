//
//  VideoResourceSupport.h
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


#define DOWNLOAD_CACHE_DATA_FILE_PATH ([NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CacheFiles"])
#define DOWNLOAD_CACHE_DATA_INFO_PATH ([NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CacheInfos"])

@class RequestInfo;
@class VideoResourceSupport;

@interface RequestInfo : NSObject

@property(nonatomic,assign)BOOL haveDone;
@property(nonatomic,copy,readonly)NSURL *url;
@property(nonatomic,strong,readonly)NSURLSessionDataTask *task;
@property(nonatomic,assign,readonly)long long startLocation;
@property(nonatomic,assign,readonly)long long requestLength;
@property(nonatomic,assign)long long downloadLength;
@property(nonatomic,weak)VideoResourceSupport* delegate;
@property(nonatomic,copy)NSString *filePath;

-(instancetype)initWithURL:(NSURL*)url startLocation:(long long)startLocation requestLength:(long long)requestLength delegate:(VideoResourceSupport*)delegate;

@end

@interface LocationFileInfo : NSObject

@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,assign,readonly)long long startLocation;
@property(nonatomic,assign,readonly)long long dataLength;
@property(nonatomic,assign,readonly)long long endLocation;

-(instancetype)initWithFilePath:(NSString*)filePath;

@end

@class VideoResourceSupport;

typedef void(^HaveLoadDataBlock)(NSArray<__kindof LocationFileInfo*>* dataRanges,VideoResourceSupport *support);

@interface VideoResourceSupport : NSObject
<AVAssetResourceLoaderDelegate,NSURLSessionDataDelegate>

@property(nonatomic,copy)NSURL *url;
@property(nonatomic,strong,readonly)RequestInfo *currentRequestInfo;
@property(nonatomic,assign,readonly)long long currentStartOffset;
@property(nonatomic,assign,readonly)long long currentLoadingRequestLength;
@property(nonatomic,assign,readonly)long long currentLoadingRequestStartOffset;
@property(nonatomic,assign,readonly)long long videoLength;
@property(nonatomic,assign,readonly)BOOL getVideoLengthState;//0未获取1获取成功2正在获取
@property(nonatomic,strong,readonly)NSURLSession *downLoadSession;
@property(nonatomic,strong,readonly)NSMutableArray *resourceLoadingRequests;
@property(nonatomic,copy)NSString *dictionaryPath;
@property(nonatomic,copy)NSString *infoDictionaryPath;
@property(nonatomic,strong,readonly)NSFileManager *fileManager;
//当获取得到数据时执行的Block
@property(nonatomic,copy)HaveLoadDataBlock dataBlock;

@property(nonatomic,strong,readonly)NSMutableArray *locationFiles;

-(instancetype)initWithURL:(NSURL*)url;
@end
