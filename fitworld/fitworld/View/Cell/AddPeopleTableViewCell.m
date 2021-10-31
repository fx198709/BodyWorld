//
//  AddPeopleTableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/31.
//

#import "AddPeopleTableViewCell.h"
@implementation AddPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imagebackview.layer.cornerRadius = 20;
    _userimageview.layer.cornerRadius = 18;
    [_selectBtn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)changeViewWithModel:(UserInfo*)userinfo{
    self.user = userinfo;
    [_userimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, userinfo.avatar]]];
    
    [self changeimagebtn];
    _namelabel.text = userinfo.nickname;
    _citylabel.text = [NSString stringWithFormat:@"%@ %@",userinfo.city,userinfo.country];
 }
- (void)changeimagebtn{
    UIImage * currentimage = [UIImage imageNamed:@"invite_friends_user_list_item_unselected"];
    if (self.user.hasSelect) {
        currentimage = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    }
    [_selectBtn setTitle:@"" forState:UIControlStateHighlighted];
    [_selectBtn setTitle:@"" forState:UIControlStateNormal];
    [_selectBtn setImage:currentimage forState:UIControlStateHighlighted];
    [_selectBtn setImage:currentimage forState:UIControlStateNormal];
}

- (void)btnclick{
    self.user.hasSelect = !self.user.hasSelect;
    [self changeimagebtn];
    if (self.cellBtnClick) {
        self.cellBtnClick(self.user);
    }
}

@end
