//
//  NSMutableDictionary+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 2017/7/26.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "NSMutableDictionary+YCExtension.h"

//沙盒document路径
#define DOCUMENT_DIRECTORY ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
//沙盒document路径里面的YC_file_storage
#define FILE_STORAGE_DIRECTORY ([DOCUMENT_DIRECTORY stringByAppendingPathComponent:@"YC_file_storage"])


@implementation NSMutableDictionary (YCExtension)
static NSString *_storePath;
+ (void)ensureStorePath:(NSString *)path {
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isDir = NO;
        _storePath = path;
        if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
            return;
        }
        [fileManager createDirectoryAtPath:_storePath
               withIntermediateDirectories:true
                                attributes:nil
                                     error:nil];
        
    });
    
}

- (instancetype)initWithStore:(NSString *)storeKey {
    
    if (storeKey && storeKey.length > 0) {
        NSRange range = [storeKey rangeOfString:@".xml"];
        if (range.location == NSNotFound) {
            storeKey = [NSString stringWithFormat:@"%@.xml",storeKey];
        }
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableDictionary ensureStorePath:FILE_STORAGE_DIRECTORY];
#endif
        NSString *filePath = [_storePath stringByAppendingPathComponent:storeKey];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            self = [self initWithContentsOfFile:filePath];
        } else {
            self = [self init];
            [self writeToStore:storeKey];
        }
        return self;
    }else{
        self = [self init];
        return self;
    }
}

- (NSString *)filePathStore:(NSString *)storeKey {
    if (storeKey && storeKey.length > 0) {
        NSRange range = [storeKey rangeOfString:@".xml"];
        if (range.location == NSNotFound) {
            storeKey = [NSString stringWithFormat:@"%@.xml",storeKey];
        }
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableDictionary ensureStorePath:FILE_STORAGE_DIRECTORY];
#endif
        NSString *filePath = [_storePath stringByAppendingPathComponent:storeKey];
        return filePath;
    }else{
        return @"";
    }
}

- (void)writeToStore:(NSString *)storeKey {
    if (storeKey && storeKey.length > 0) {
        NSRange range = [storeKey rangeOfString:@".xml"];
        if (range.location == NSNotFound) {
            storeKey = [NSString stringWithFormat:@"%@.xml",storeKey];
        }
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableDictionary ensureStorePath:FILE_STORAGE_DIRECTORY];
#endif
        NSString *filePath = [_storePath stringByAppendingPathComponent:storeKey];
        [self writeToFile:filePath atomically:YES];
    }

}
@end
