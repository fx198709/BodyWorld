//
//  AFAppDotNetAPIClientNEw2_0.h
//  Ework
//
//  Created by feixiang on 2016/10/19.
//  Copyright © 2016年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, SelecteMediaType){
    SelecteMediaTypeImage = 1,
    SelecteMediaTypeVedio,
};
@interface AFAppNetAPIClient : AFHTTPSessionManager<UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isShowingAlert;
+ (instancetype)sharedClient;


/**
 *  获取 BaseURLString
 *  这里等于AFAppDotNetAPIBaseURLString
 *
 *  @return
 */
+ (NSString *)URLString;

/**
 *  获取完整的请求链接
 *
 *  @param URLStr  需要拼接的URL
 *
 *  @return
 */
+ (NSString *)requestURLString:(NSString *)URLStr;

/**
 覆盖AFHTTPSessionManager方法  添加了安全访问的内容
 
 @param 请求的url
 @param 请求的参数
 @param 请求成功的block
 @param 请求失败的block
 
 @see -dataTaskWithRequest:completionHandler:
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  
 *  新接口使用的方法
 *  @param URLString  <#URLString description#>
 *  @param moduleName    模块名称
 *  @param operationName 操作名称
 *  @param parameters    接口请求参数
 *  @param success       请求成功的block
 *  @param failure       请求失败的block
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    ModuleName:(NSString *)moduleName
                 operationName:(NSString *)operationName
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 覆盖AFHTTPSessionManager方法  添加了安全访问的内容
 
 @param 请求的url
 @param 请求的参数
 @param 请求成功的block
 @param 请求失败的block
 
 @see -dataTaskWithRequest:completionHandler:
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/**
 获取指定的文件  添加了安全访问的内容
 
 @param 请求的url
 @param 请求的参数
 @param 请求成功的block
 @param 请求失败的block
 
 @see -dataTaskWithRequest:completionHandler:
 */
- (NSURLSessionDataTask *)GETFILE:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 post带有附件的请求
 
 @param 请求的url
 @param 请求的参数
 @param 上传的文件
 @param 请求成功的block
 @param 请求失败的block
 
 @see -dataTaskWithRequest:completionHandler:
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                          file:(NSData*)fileData
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSMutableDictionary *)addDefaultObjectTodic:(NSDictionary *)inDic;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    ModuleName:(NSString *)moduleName
                 operationName:(NSString *)operationName
                    parameters:(id)parameters
                          file:(NSData *)fileData
                     mediaType:(SelecteMediaType)mediaType
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
//获得设备型号
- (NSString *)getCurrentDeviceInfoString;
//系统版本号
- (NSString*)systemVersionString;
//获取一个uuid
- (NSString*)uuid;
- (NSString *)RequestCode:(NSString *)uuid;
@end
