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
    make.height.equalTo(self.mMyView.mas_width);
  }];
  
  mMyLabel = [[UILabel alloc] init];
  [mMyLabel setText:@"我"];
  [mMyLabel setTextColor:[UIColor whiteColor]];
  [mMyLabel setTextAlignment:NSTextAlignmentCenter];
  [mMyLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
  [mMyLabel sizeToFit];
  [mMyView addSubview:mMyLabel];
  [mMyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.and.centerY.equalTo(self.mMyView);
  }];
  
//  mNameLabel = [[UILabel alloc] init];
//  [mNameLabel setText:@""];
//  [mNameLabel setTextColor:[UIColor whiteColor]];
//  [mNameLabel setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
//  [mNameLabel setTextAlignment:NSTextAlignmentLeft];
//  [mNameLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
//  [self addSubview:mNameLabel];
//  [mNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.left.equalTo(self);
//    make.top.equalTo(self.mMyView.mas_bottom);
//    make.width.equalTo(self);
//    make.height.equalTo(@40);
//  }];
  
//  mChatBtn = [UIButton new];
//    mChatBtn.backgroundColor = UIColor.redColor;
//  [self addSubview:mChatBtn];
//  [mChatBtn addTarget:self action:@selector(oChatClicked) forControlEvents:UIControlEventTouchUpInside ];
//  [mChatBtn setImage:[UIImage imageNamed:@"header_im"] forState:UIControlStateNormal];
//  [mChatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//   make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
//    make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
//    make.width.equalTo(self).multipliedBy(0.4);
//    make.height.equalTo(self.mChatBtn.mas_width);
//  }];
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
}

- (void)detachLocalView {
  if (mLocalView == nil) {
    return;
  }
  [mLocalView unbindMedia];
  [mLocalView removeFromSuperview];
  mLocalView = nil;
}

@end
