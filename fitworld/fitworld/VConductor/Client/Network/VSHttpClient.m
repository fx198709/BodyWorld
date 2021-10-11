/*
 *  Copyright 2014 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "VSHttpClient.h"

//#import <WebRTC/RTCLogging.h>
#define RTCLogError NSLog

@implementation VSHttpClient

+ (void)sendRequestWithUrl:(NSString*)url andMethod:(NSString*)method andHeaders:(NSDictionary*)headers andPayload:(NSDictionary*)data andCallback:(void (^)(BOOL succeed, NSString *response, NSError *error))callback {
  
  NSURL *reqUrl = [NSURL URLWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reqUrl];
  request.HTTPMethod = method;
  for (NSString *headerKey in headers.allKeys) {
    NSString *headerValue = [headers objectForKey:headerKey];
    [request addValue:headerValue forHTTPHeaderField:headerKey];
  }
  if (data != nil) {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = jsonData;
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  }
  
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request
              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                  RTCLogError(@"Error posting data: %@", error.localizedDescription);
                  if (callback) {
                    callback(NO, nil, error);
                  }
                  return;
                }
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSString *serverResponse = data.length > 0 ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
                if (httpResponse.statusCode != 200) {
                  RTCLogError(@"Received bad response: %@", serverResponse);
                  if (callback) {
                    callback(NO, serverResponse, nil);
                  }
                  return;
                }
                if (callback) {
                  callback(YES, serverResponse, nil);
                }
              }] resume];
  
}


@end
