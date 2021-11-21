#import "GuestPanel.h"
#import "UIDeps.h"
#import "GuestRenderView.h"

@interface GuestPanel ()
{
}


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
  
  mMyView = [UIView new];
  [self addSubview:mMyView];
  [mMyView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.and.top.equalTo(self);
    make.width.equalTo(self);
    make.height.equalTo(self.mMyView.mas_width);
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
//    [mGuestRenderView openGuestMedia];
}

- (void)detachGuestRenderView {
  if (mGuestRenderView == nil) {
    return;
  }
  [mGuestRenderView unbindMedia];
//[mGuestRenderView closeGuestMedia];
  [mGuestRenderView removeFromSuperview];
  mGuestRenderView = nil;
}

@end
