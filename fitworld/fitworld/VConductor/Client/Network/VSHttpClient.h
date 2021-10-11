#import <Foundation/Foundation.h>


@interface VSHttpClient : NSObject

+ (void)sendRequestWithUrl:(NSString*)url andMethod:(NSString*)method andHeaders:(NSDictionary*)headers andPayload:(NSDictionary*)data andCallback:(void (^)(BOOL succeed, NSString *response, NSError *error))callback;

@end
