//
//  Train3TableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import "BaseTableViewCell.h"
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface Train3TableViewCell : BaseTableViewCell

@property (nonatomic, strong)NSArray *currentUsers;
@property (nonatomic, copy)AnyBtnBlock peopleBtnClick;


- (void)changeDataWithUserList:(NSArray*)userList;

@end

NS_ASSUME_NONNULL_END
