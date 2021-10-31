//
//  TableSearchView.h
//  FFitWorld
//
//  Created by feixiang on 2021/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TableSearchViewDelegate <UIBarPositioningDelegate>
- (void)searhBarBtnClicked:(NSString*)searchString;
- (void)allowOtherBtnClicked:(NSInteger)otherType;

@end

@interface TableSearchView : UIView<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel2;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbarBtn;
@property (nonatomic, assign) NSInteger canAllowOther;
@property (nonatomic, weak)id<TableSearchViewDelegate> searchDelegate;

@end

NS_ASSUME_NONNULL_END
