//
//  ReportReaseonModel.m
//  FFitWorld
//
//  Created by feixiang on 2022/2/22.
//

#import "ReportReaseonModel.h"

@implementation ReportReaseonModel

- (id)initWithString:(NSString *)string andindex:(int)index;{
    self = [super init];
    if (self) {
        self.name = string;
        self.hasSelected = NO;
        self.id = [NSString stringWithFormat:@"%d",index];
    }
    return  self;
}

@end
