//
//  TableSearchView.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/31.
//

#import "TableSearchView.h"
#import "UIImage+Extension.h"

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
    _searchbarBtn.placeholder = ChineseStringOrENFun(@"搜索", @"Search");
    _canAllowOther = 1;
    _titleLabel1.text = ChineseStringOrENFun(@"本次对练是否允许随机陌生人加入", @"Allow random matching");
    _titlelabel2.text = ChineseStringOrENFun(@"您可邀请好友参加对练（最多5个，在列表勾选或搜索）", @"select friends(up to 5)");
    self.searchbarBtn.delegate = self;
    _searchbarBtn.backgroundColor = [UIColor clearColor];
    _searchbarBtn.showsCancelButton = NO;
    _searchbarBtn.backgroundColor = BgGrayColor;
    
    for (UIView *subView in _searchbarBtn.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
        }
    }
    _searchbarBtn.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    [_selectedBtn addTarget:self action:@selector(canAllowOtherPeople ) forControlEvents:UIControlEventTouchUpInside];
    NSString *searchString = ChineseStringOrENFun(@"搜索", @"Search");
    [_searchActionBtn setTitle:searchString forState:UIControlStateHighlighted];
    [_searchActionBtn setTitle:searchString forState:UIControlStateNormal];
    [_searchActionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [_searchActionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    _searchActionBtn.backgroundColor = UIRGBColor(28, 28, 30, 1);
    _searchActionBtn.layer.cornerRadius = 8;
    _searchActionBtn.clipsToBounds = YES;
    [_searchActionBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)canAllowOtherPeople{
    UIImage * currentimage = [UIImage imageNamed:@"invite_friends_user_list_item_unselected"];
    if (_canAllowOther == 1) {
        _canAllowOther = 2;
        currentimage = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    }else{
        _canAllowOther = 1;
    }
    [_selectedBtn setTitle:@"" forState:UIControlStateHighlighted];
    [_selectedBtn setTitle:@"" forState:UIControlStateNormal];
    [_selectedBtn setImage:currentimage forState:UIControlStateHighlighted];
    [_selectedBtn setImage:currentimage forState:UIControlStateNormal];
    if ([_searchviewDelegate respondsToSelector:@selector(allowOtherBtnClicked:)]) {
        [_searchviewDelegate allowOtherBtnClicked:_canAllowOther];
    }

}

- (void)searchBtnClick {
    if ([_searchviewDelegate respondsToSelector:@selector(searhBarBtnClicked:)]) {
        [_searchviewDelegate searhBarBtnClicked:_searchbarBtn.text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    输入文字改变
    if ([_searchviewDelegate respondsToSelector:@selector(searhBartextChanged:)]) {
        [_searchviewDelegate searhBartextChanged:searchBar.text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([_searchviewDelegate respondsToSelector:@selector(searhBarBtnClicked:)]) {
        [_searchviewDelegate searhBarBtnClicked:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self endEditing:YES];
//    清除所有的
//    if ([_searchviewDelegate respondsToSelector:@selector(searhBarBtnClicked:)]) {
//        [_searchviewDelegate searhBarBtnClicked:@""];
//    }
}



@end
