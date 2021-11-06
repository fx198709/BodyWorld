//
//  MessageListModel.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/5.
//

#import "MessageListModel.h"

@implementation MessageListModel
- (instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        self.id = NSStringFromDic(json, @"id", @"");
        self.send_to_uid = NSStringFromDic(json, @"send_to_uid", @"");
        self.content = NSStringFromDic(json, @"content", @"");
        self.subject = NSStringFromDic(json, @"subject", @"");
        self.is_read = LongValueFromDic(json, @"is_read", 0);
        self.created_at = LongValueFromDic(json, @"created_at", 0);;
        self.updated_at = LongValueFromDic(json, @"updated_at", 0);
        self.updated_atString = ReachYearANDTime(self.updated_at);
    }
    return self;
    

}

@end


/*
 "id": "44651382707325444",
             "send_to_uid": "44651294610164228",
             "content": "您预约的测试用1分钟课程课程已经开课，快来一起锻炼吧！",
             "subject": "课程提醒",
             "is_read": "0",
             "created_at": 1636044698,
             "updated_at": 1636044698
 */
