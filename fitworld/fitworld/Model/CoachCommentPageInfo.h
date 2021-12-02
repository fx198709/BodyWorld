//
//  CoachCommentPageInfo.h
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import "BaseJSONModel.h"
#import "CoachComment.h"

@protocol CoachComment;

NS_ASSUME_NONNULL_BEGIN

@interface CoachCommentPageInfo : BaseJSONModel

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<CoachComment> *rows;

@end

NS_ASSUME_NONNULL_END
