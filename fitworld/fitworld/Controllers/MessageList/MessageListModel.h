//
//  MessageListModel.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/5.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModel : BaseObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *send_to_uid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) long is_read;
@property (nonatomic, assign) long created_at;
@property (nonatomic, assign) long updated_at;
@property (nonatomic, copy) NSString *updated_atString;



@end

NS_ASSUME_NONNULL_END

/*
 "id": "44651382707325444",
             "send_to_uid": "44651294610164228",
             "content": "您预约的测试用1分钟课程课程已经开课，快来一起锻炼吧！",
             "subject": "课程提醒",
             "is_read": "0",
             "created_at": 1636044698,
             "updated_at": 1636044698
 */
