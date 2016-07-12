//
//  GJAPICacheRequest.m
//  GJNetWorking
//
//  Created by wangyutao on 15/12/1.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJAPICacheRequest.h"
#import "GJNetworkingConfig.h"
#import <CommonCrypto/CommonDigest.h>

@interface GJAPICacheRequest ()

/**
 *  使用的缓存对象
 */
@property (nonatomic, strong) id cacheObject;

@end

@implementation GJAPICacheRequest

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return -1;
}

- (NSString *)cacheDirectory {
    return nil;
}

- (NSError *)error {
    if (self.cacheObject) {
        return nil;
    }
    return [super error];
}

- (id)responseObject {
    if (self.cacheObject) {
        return self.cacheObject;
    }
    return [super responseObject];
}

- (id)responseJson {
    if (self.cacheObject) {
        return self.cacheObject;
    }
    return [super responseJson];
}

- (void)start {
    
    BOOL useCache = ([self cachePolicy] == GJUseAPICacheIfExistPolicy);
    
    NSString *filePath = [self apiCacheFilePath];
    
    //不用缓存 或 缓存文件不存在 或 缓存时间超时 则 重新请求
    if (!useCache ||
        ![self fileExist:filePath] ||
        ![self checkCacheValidTimeCanBeUsed]) {
        [super start];
        return;
    }
    
    id cacheObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    //取缓存不可用，重新请求
    if (!cacheObject) {
        [super start];
        return;
    }
    
    //缓存可用
    self.cacheObject = cacheObject;
    
    [self requestTerminate];
}

//网络请求结束后,callback前调用,
- (void)requestCompleted {
    BOOL success = !self.error;
    
    if (success) {//成功，保存缓存
        [self archiveJson:self.responseObject];
    }
    else {//失败，如果是失败用缓存的策略，则使用缓存
        if ([self cachePolicy] == GJUseAPICacheWhenFailedPolicy) {
            
            id cacheJsonDic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self apiCacheFilePath]];
            if (cacheJsonDic) {
                self.cacheObject = cacheJsonDic;
                return;
            }
        }
    }
}

- (void)archiveJson:(id)responseJson {
    //是否存档,必须是没有使用cacheObject的时候
    if (([self cachePolicy] == GJUseAPICacheIfExistPolicy ||
         [self cachePolicy] == GJUseAPICacheWhenFailedPolicy) &&
        ![self cacheObject]) {
        
        [self archiveJsonToCurrentAPICache:responseJson];
    }
}

- (BOOL)checkCacheValidTimeCanBeUsed {
    NSTimeInterval interval = [self existTimeOfCache:[self apiCacheFilePath]];
    if (interval >= [self cacheValidTime]) {
        return NO;
    }
    return YES;
}

- (BOOL)fileExist:(NSString *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (NSString *)apiCacheFilePath {
    NSString *directoryPath = [self apiCacheDirectoryPath];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:[self makeCacheFileNameKey]];
    return filePath;
}

- (NSString *)apiCacheDirectoryPath {
    NSString *path = [self directoryPathWithDirectoryName:[GJNetworkingConfig getCacheDirectory]];
    if ([self respondsToSelector:@selector(cacheDirectory)]) {
        path = [self cacheDirectory].length ? [self cacheDirectory] : path;
    }
    return path;
}

- (NSString *)makeCacheFileNameKey {
    NSString *method = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[self method]]];
    NSString *baseUrl = [GJNetworkingConfig defaultBaseUrl];
    if ([self respondsToSelector:@selector(baseUrl)]) {
        baseUrl = [self baseUrl];
    }
    NSString *path = @"";
    if ([self respondsToSelector:@selector(path)]) {
        path = [self path];
    }
    NSString *parameters = @"";
    if ([self respondsToSelector:@selector(parameters)]) {
        parameters = [NSString stringWithFormat:@"%@",[self parameters]];
    };
    NSString *keyString = [NSString stringWithFormat:@"%@_%@_%@_%@",method,baseUrl,path,parameters];
    keyString = [self cachedFileNameForKey:keyString];
    return keyString;
}

#pragma mark- private

- (NSTimeInterval)existTimeOfCache:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (!attributes) {
        NSLog(@"get file:%@ ,attribute failed:%@", path, error);
        return -1;
    }
    NSTimeInterval interval = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return interval;
}

- (void)archiveJsonToCurrentAPICache:(NSDictionary *)jsonDic {
    [self archiveJson:jsonDic toCacheFilePath:[self apiCacheFilePath]];
}

- (void)archiveJson:(NSDictionary *)jsonDic toCacheFilePath:(NSString *)path{
    if ([self cacheValidTime] > 0) {
        if (jsonDic && [self checkCacheDirecotryExist]) {
            
            BOOL cacheSuccess = [NSKeyedArchiver archiveRootObject:jsonDic toFile:path];
            if (!cacheSuccess) NSLog(@"achicve json to cache failed!");
            else NSLog(@"achicve json to cache success!");
        }
    }
}

- (BOOL)checkCacheDirecotryExist {
    NSString *dirPath = [self apiCacheDirectoryPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)directoryPathWithDirectoryName:(NSString *)dirName {
    return [[self cachesPath] stringByAppendingPathComponent:dirName];
}

- (NSString *)cachesPath
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

@end
