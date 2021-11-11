#import "GuestRenderView.h"
#import "UIDeps.h"

#import "VConductorClient.h"

@interface GuestRenderView()
{
}
@property (nonatomic, strong) NSString* mUserId;
@property (nonatomic, assign) BOOL mIsMain;

@property (nonatomic, strong) VSVideoRender* mVideoRender;
@property (nonatomic, strong) UILabel* mLabel;

@end


@implementation GuestRenderView

@synthesize mUserId;
@synthesize mIsMain;
@synthesize mVideoRender;
@synthesize mLabel;

- (void)dealloc{
  NSLog(@"GuestRenderView dealloc");
}

- (id)initWithUserId:(NSString*)uId forMainVideo:(BOOL)main {
  self = [super init];
  
  mUserId = uId;
  mIsMain = main;
  
  mVideoRender = [[VConductorClient sharedInstance] createVideoRender];
  [self addSubview:mVideoRender.render_view];
  [mVideoRender.render_view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.with.top.equalTo(self);
    make.size.equalTo(self);
  }];
    mVideoRender.render_view.backgroundColor = [UIColor blueColor];
//    展示形式
//  if (!mIsMain) {
    [mVideoRender set_content_mode:UIViewContentModeScaleAspectFill];
//  }

  mLabel = [[UILabel alloc] init];
  [mLabel setText:@"GUEST"];
  [mLabel setTextColor:[UIColor whiteColor]];
  [mLabel setBackgroundColor:[UIColor darkGrayColor]];
  [mLabel setTextAlignment:NSTextAlignmentRight];
  [mLabel setFont:[UIFont systemFontOfSize:10.0]];
  [mLabel sizeToFit];
  [mLabel setAlpha:0.7];
  [self addSubview:mLabel];
  [mLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.with.bottom.equalTo(self);
  }];
  
  return self;
}

- (NSString*)userId {
  return mUserId;
}

- (void)bindMedia {
  if (mIsMain) {
    [[VConductorClient sharedInstance] bindMainVideoRender:mVideoRender ofUser:mUserId];
  } else {
    [[VConductorClient sharedInstance] bindShareVideoRender:mVideoRender ofUser:mUserId];
  }
}

- (void)unbindMedia {
  if (mIsMain) {
    [[VConductorClient sharedInstance] unbindMainVideoRender:mVideoRender ofUser:mUserId];
  } else {
    [[VConductorClient sharedInstance] unbindShareVideoRender:mVideoRender ofUser:mUserId];
  }
}

@end
