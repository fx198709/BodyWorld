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
@property (nonatomic, copy) NSDictionary * extended_data;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) float rowHeight;


@end

NS_ASSUME_NONNULL_END


