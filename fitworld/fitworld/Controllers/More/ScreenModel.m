//
//  ScreenModel.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/15.
//

#import "ScreenModel.h"

@implementation ScreenModel
- (instancetype)initWithJSON:(NSDictionary *)json
{
    NSError *error;

    if (self = [[ScreenModel alloc] initWithDictionary:json error:&error]) {
        _hasSelected = NO;
    }
    return self;
}
@end
