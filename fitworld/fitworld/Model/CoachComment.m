//
//  CoachComment.m
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import "CoachComment.h"

@implementation CoachComment


- (void)dealData {
    self.country_icon = [self.country_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
