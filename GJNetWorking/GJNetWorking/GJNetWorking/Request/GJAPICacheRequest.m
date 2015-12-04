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

@property (nonatomic, assign) BOOL callBackUseCache;

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

- (void)start {
    
    BOOL useCache = ([self cachePolicy] == GJUseAPICacheIfExistPolicy);
    
    NSString *filePath = [self apiCacheFilePath];
    
    if (!useCache ||
        ![self fileExist:filePath] ||
        ![self checkCacheValidTimeCanBeUsed]) {
        [super start];
        return;
    }
    
    NSDictionary *cacheJsonDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!cacheJsonDic || !self.successBlock) {
        [super start];
        return;
    }
    
    self.callBackUseCache = YES;
    NSLog(@"user cache data %@",cacheJsonDic);
    self.successBlock(cacheJsonDic , nil, nil);

}


- (void)setSuccessBlock:(GJRequestFinishedBlock)successBlock {
    
    __weak typeof(self) weakSelf = self;
    
    [super setSuccessBlock:^(id responseJson, id status , NSError *error) {
        
        if (([weakSelf cachePolicy] == GJUseAPICacheIfExistPolicy ||
            [weakSelf cachePolicy] == GJUseAPICacheWhenFailedPolicy) &&
            ![weakSelf callBackUseCache]) {
            
            [weakSelf archiveJsonToCurrentAPICache:responseJson];
            
        }
        
        !successBlock ? : successBlock(responseJson , status, error);

    }];
}

- (BOOL)checkCacheValidTimeCanBeUsed {
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
