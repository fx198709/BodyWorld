//
//  AFAppNetAPIClient.m
//  Ework
//
//  Created by feixiang on 2016/10/19.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "AFAppNetAPIClient.h"
//通用访问网络类

@implementation AFAppNetAPIClient

+ (instancetype)sharedClient {
    static AFAppNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[self URLString]]];
        AFSecurityPolicy *securityPolicy =[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        // 客户端是否信任非法证书
        
        securityPolicy.allowInvalidCertificates = YES;
        
        // 是否在证书域字段中验证域名
        
        securityPolicy.validatesDomainName = NO;
        
        _sharedClient.securityPolicy = securityPolicy;
        _sharedClient.requestSerializer.timeoutInterval = 30;
        
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //是否对参数进行json解析，默认是 一级 解析，多级json对象会被压缩为一级
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    });
    
    return _sharedClient;
}

+ (NSString*)URLString {
    return FITAPI_HTTPS_PREFIX;
}

+ (NSString *)requestURLString:(NSString *)URLStr {
    return [[NSURL URLWithString:URLStr relativeToURL:[NSURL URLWithString:[self URLString]]] absoluteString];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    ModuleName:(NSString *)moduleName
                 operationName:(NSString *)operationName
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return nil;
    
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *userToken = [APPObjOnce getUserToken ];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_PREFIX,URLString];
    NSArray *noapis = @[@"login",@"captcha",@"captcha/validate",@"register"];
    if (![noapis containsObject:URLString]) {
        [self.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    }
    [self.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    return [self POST:strUrl parameters:parameters headers:nil progress:nil success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dealError:error task:task failure:failure];
    }];
}


- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *userToken = [APPObjOnce getUserToken ];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_PREFIX,URLString];
    
    [self.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:@"zh" forHTTPHeaderField:@"Accept-language"];

    [self.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    return [self PUT:strUrl parameters:parameters headers:nil success:success failure:failure];
}


/*
 Permission	JSON字符串
 操作说明
 Status	状态	0是正常 ,1 请求参数问题
 
 Msg
 
 Title	字符串
 
 Line	字符串数组
 
 IsNeedUpdate	是否需要升级
 0是正常
 1是当前APP版本不支持本操作,需要升级
 2是本操作已经下线不再支持
 
 IsContinue	是否继续执行
 0是正常 1是停止继续操作
 
 UpdateUrl	更新APP地址
 
 IsLoginErr	是否登录	0是正常 1是停止操作 要求用户重新登录APP
 
 Response	JSON字符串
 
 返回数据
 Status	状态	0是正常 非0是表示调用接口出现异常
 
 Msg	说明	异常说明
 
 Data	返回数据 具体结构参考相关接口说明	接口返回的数据
 */



-(void)willSuccessRequestWithTask:(NSURLSessionDataTask * __unused) task
                         JSONData:(id) JSON
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    
    /*
     [CommonTools showAlertWithContent:@"检测到非法登录，请重新登录系统"];
     [Login logout];
     [CommonTools showLoginView];
     */
    //权限 暂时不处理 延后
    NSDictionary *ResponseDic = [JSON valueForKeyPath:@"Response"];
    id Data = ResponseDic;
    if(success){
        success(task,Data);
    }
    
}

- (NSURLSessionDataTask *)GETFILE:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return  nil;
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    NSString *userToken = [APPObjOnce getUserToken ];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_PREFIX,URLString];
    
    [self.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    return [self GET:strUrl parameters:parameters headers:nil progress:nil success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dealError:error task:task failure:failure];
    }];
}

/**
 post带有附件的请求
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                          file:(NSData*)fileData
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    NSString *userToken = [APPObjOnce getUserToken ];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_PREFIX,URLString];
    
    [self.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    return [self POST:strUrl parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //给定数据流的数据名，文件名，文件类型（以图片为例）
        [formData appendPartWithFileData:fileData name:@"file" fileName:@"img1" mimeType:@"image/jpeg"];
    } progress:nil success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dealError:error task:task failure:failure];
    }];
}

- (void)dealError:(NSError *)error task:(NSURLSessionDataTask *) task failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (failure != nil) {
        failure(task, error);
    }
    
    //401 重登录
    if (error.localizedDescription != nil
        && [error.localizedDescription containsString:@"(401)"]
        && ![APPObjOnce sharedAppOnce].isLogining) {
        [APPObjOnce clearUserToken];
        [[APPObjOnce sharedAppOnce] showLoginView];
    }
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    ModuleName:(NSString *)moduleName
                 operationName:(NSString *)operationName
                    parameters:(id)parameters
                          file:(NSData *)fileData
                     mediaType:(SelecteMediaType)mediaType
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return nil;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                          file:(NSData*)fileData
                     mediaType:(SelecteMediaType)mediaType
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return nil;
}

-(void)willErrorWithTask:(NSURLSessionDataTask*)intask error:(NSError *)inError failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
}



//获取一个uuid
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


//系统版本号
- (NSString*)systemVersionString
{
    return  [[UIDevice currentDevice] systemVersion];
}


@end
