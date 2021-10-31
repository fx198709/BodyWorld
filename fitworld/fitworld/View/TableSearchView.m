//
//  TableSearchView.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/31.
//

#import "TableSearchView.h"

@implementation TableSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    _titleLabel1.text = ChineseStringOrENFun(@"本次对练是否允许随机陌生人加入", @"本次对练是否允许随机陌生人加入");
    _titlelabel2.text = ChineseStringOrENFun(@"您可邀请好友参加对练（最多5个，在列表勾选或搜索）", @"您可邀请好友参加对练（最多5个，在列表勾选或搜索）");
    self.searchbarBtn.delegate = self;
    [_selectedBtn addTarget:self action:@selector(canAllowOtherPeople ) forControlEvents:UIControlEventTouchUpInside];
}

- (void)canAllowOtherPeople{
    UIImage * currentimage = [UIImage imageNamed:@"invite_friends_user_list_item_unselected"];
    if (_canAllowOther == 1) {
        _canAllowOther = 2;
        currentimage = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    }else{
        _canAllowOther = 1;
    }
    [_selectedBtn setImage:currentimage forState:UIControlStateHighlighted];
    [_selectedBtn setImage:currentimage forState:UIControlStateNormal];
    if ([_searchDelegate respondsToSelector:@selector(allowOtherBtnClicked:)]) {
        [_searchDelegate allowOtherBtnClicked:_canAllowOther];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([_searchDelegate respondsToSelector:@selector(searhBarBtnClicked:)]) {
        [_searchDelegate searhBarBtnClicked:searchBar.text];
    }
}



@end
