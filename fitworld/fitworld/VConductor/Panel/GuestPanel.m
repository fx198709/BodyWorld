#import "GuestPanel.h"
#import "UIDeps.h"
#import "GuestRenderView.h"
#import "UserHeadPicView.h"
@interface GuestPanel ()
{
}
//@property (nonatomic, weak)ClassMember* guestMember; //弱引用，方便释放
@property (nonatomic, strong)UserHeadPicView* guestImageView;
@property (nonatomic, strong)UIImageView* countryImageView;

@property (nonatomic, strong) GuestRenderView* mGuestRenderView;
@end

@implementation GuestPanel

@synthesize mMyView;
@synthesize mMyLabel;
@synthesize mNameLabel;
@synthesize mChatBtn;

@synthesize mGuestRenderView;

- (void)dealloc{
    NSLog(@"GuestPanel dealloc");
}

- (id) init {
    self = [super init];
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    self.clipsToBounds = YES;
    mMyView = [UIView new];
    [self addSubview:mMyView];
    [mMyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    mMyLabel = [[UILabel alloc] init];
    [mMyLabel setText:@"GUEST"];
    [mMyLabel setTextColor:[UIColor whiteColor]];
    [mMyLabel setTextAlignment:NSTextAlignmentCenter];
    [mMyLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [mMyLabel sizeToFit];
    [mMyView addSubview:mMyLabel];
    [mMyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //    make.centerX.and.centerY.equalTo(self.mMyView);
        make.left.equalTo(mMyView).offset(5);
        make.top.equalTo(mMyView).offset(5);
        
    }];
    
    _countryImageView = [[UIImageView alloc] init];
    [mMyView addSubview:_countryImageView];
    [_countryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //    make.centerX.and.centerY.equalTo(self.mMyView);
        make.left.equalTo(mMyLabel.mas_right).offset(2);
        make.centerY.equalTo(mMyLabel).offset(5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    return self;
}

- (void)changeCountryIcon:(NSString*)imageurl{
    [_countryImageView sd_setImageWithURL: [NSURL URLWithString:imageurl] placeholderImage:nil];
}

//创建头像
- (void)createImageSubview{
    if (!_guestImageView) {
        _guestImageView = [[UserHeadPicView alloc] init];
        [self addSubview:_guestImageView];
        [_guestImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //    make.centerX.and.centerY.equalTo(self.mMyView);
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 100));
            
        }];
        _guestImageView.clipsToBounds = YES;
        _guestImageView.layer.cornerRadius = 50;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [_guestImageView changeDataWithUserImageUrl:_userImageString];
    }
   
}

- (void)deleteImageSubview{
    [_guestImageView removeFromSuperview];
    _guestImageView = nil;
}


- (void)syncSession:(ClassMember*)session {
    mMyLabel.text = session.nickName;
//    保存member信息  后续免打扰 显示头像
//    _guestMember = session;
}

- (void)oChatClicked {
    if (self.pressBtnChat) {
        self.pressBtnChat();
    }
}

- (void)attachGuestRenderView {
    if (mGuestRenderView == nil) {
        mGuestRenderView = [[GuestRenderView alloc] initWithUserId:_mUserId forMainVideo:YES];
        mGuestRenderView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:mGuestRenderView];
        [mGuestRenderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(self);
            make.width.and.height.equalTo(self);
        }];
    }
    [mGuestRenderView bindMedia];
    [self bringSubviewToFront:mMyView];
    //    [mGuestRenderView openGuestMedia];
}

- (void)detachGuestRenderView {
    if (mGuestRenderView == nil) {
        return;
    }
    [mGuestRenderView unbindMedia];
    [mGuestRenderView removeFromSuperview];
    mGuestRenderView = nil;
}

//屏蔽其他人 只显示头像
- (void)onlyShowUserImage{
    [self createImageSubview];
    [self detachGuestRenderView];
}
//显示其他人的流
- (void)showUservideo{
    [self deleteImageSubview];
    [self attachGuestRenderView];

}

@end
