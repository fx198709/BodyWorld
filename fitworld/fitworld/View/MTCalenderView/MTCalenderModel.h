//
//  MTCalenderModel.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/14.
//

#import <Foundation/Foundation.h>


@interface MTCalenderModel : NSObject

@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithData:(NSDate *)date;

@end
