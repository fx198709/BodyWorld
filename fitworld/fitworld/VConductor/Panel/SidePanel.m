#import "SidePanel.h"
#import "UIDeps.h"
#import "LocalView.h"

@interface SidePanel ()
{
}
@property (nonatomic, strong) UIView* mMyView;
@property (nonatomic, strong) UILabel* mMyLabel;
@property (nonatomic, strong) UILabel* mNameLabel;
@property (nonatomic, strong) UIButton* mChatBtn;
@property (nonatomic, strong)UIImageView* countryImageView;

@property (nonatomic, strong) LocalView* mLocalView;
@end

@implementation SidePanel

@synthesize mMyView;
@synthesize mMyLabel;
@synthesize mNameLabel;
@synthesize mChatBtn;

@synthesize mLocalView;

- (void)dealloc{
    NSLog(@"SidePanel dealloc");
}

- (id) init {
    self = [super init];
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    
    mMyView = [UIView new];
    [self addSubview:mMyView];
    [mMyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    mMyLabel = [[UILabel alloc] init];
    [mMyLabel setText:[APPObjOnce sharedAppOnce].currentUser.nickname];
    [mMyLabel setTextColor:[UIColor whiteColor]];
    [mMyLabel setTextAlignment:NSTextAlignmentCenter];
    [mMyLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [mMyLabel sizeToFit];
    [mMyView addSubview:mMyLabel];
    [mMyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mMyView).offset(5);
        make.top.equalTo(mMyView).offset(5);
    }];
    
    _countryImageView = [[UIImageView alloc] init];
    [mMyView addSubview:_countryImageView];
    [_countryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //    make.centerX.and.centerY.equalTo(self.mMyView);
        make.left.equalTo(mMyLabel.mas_right).offset(2);
        make.centerY.equalTo(mMyLabel);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    NSString *countryUrl = [APPObjOnce sharedAppOnce].currentUser.country_icon;
    [_countryImageView sd_setImageWithURL: [NSURL URLWithString:countryUrl] placeholderImage:nil];
    _countryImageView.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}

- (void)syncSession:(ClassMember*)session {
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:session.nickName attributes:@{ NSParagraphStyleAttributeName : style}];
    mNameLabel.attributedText = attrText;
}

- (void)oChatClicked {
    if (self.pressBtnChat) {
        self.pressBtnChat();
    }
}

- (void)attachLocalView {
    if (mLocalView == nil) {
        mLocalView = [LocalView new];
        [mMyView addSubview:mLocalView];
        [mLocalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(self.mMyView);
            make.width.and.height.equalTo(self.mMyView);
        }];
    }
    [mLocalView bindMedia];
    [mMyView bringSubviewToFront:mMyLabel];
    [mMyView bringSubviewToFront:_countryImageView];

}

- (void)detachLocalView {
    if (mLocalView == nil) {
        return;
    }
    [mLocalView unbindMedia];
    [mLocalView removeFromSuperview];
    mLocalView = nil;
}


//创建头像
- (void)createImageSubview{
    if (!_guestImageView) {
        _guestImageView = [[UserHeadPicView alloc] init];
        [self addSubview:_guestImageView];
    }
    [self changeUserImageLayout];

   
}

- (void)changeUserImageLayout{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    int parentHeight = self.frame.size.height;
    if (parentHeight <150) {
        [_guestImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //    make.centerX.and.centerY.equalTo(self.mMyView);
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(parentHeight/2, parentHeight/2));
            
        }];
        _guestImageView.clipsToBounds = YES;
        _guestImageView.layer.cornerRadius = parentHeight/4;
    }else{
        [_guestImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //    make.centerX.and.centerY.equalTo(self.mMyView);
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 100));
            
        }];
        _guestImageView.clipsToBounds = YES;
        _guestImageView.layer.cornerRadius = 50;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [_guestImageView changeDataWithUserImageUrl:_userImageString];
}


- (void)deleteImageSubview{
    [_guestImageView removeFromSuperview];
    _guestImageView = nil;
}


@end
