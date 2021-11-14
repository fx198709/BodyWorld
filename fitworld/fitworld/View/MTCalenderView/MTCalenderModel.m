//
//  MTCalenderModel.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/14.
//

#import "MTCalenderModel.h"

@implementation MTCalenderModel

- (instancetype)initWithData:(NSDate *)date {
    if (self= [self init]) {
        self.date = date;
    }
    return self;
}

@end
