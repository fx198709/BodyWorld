//
//  RoomCreator.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "RoomCreator.h"

@implementation RoomCreator

- (void)dealData {
    self.country_icon = [self.country_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}



@end
