#import "LocalView.h"
#import "UIDeps.h"

#import "VConductorClient.h"

@interface LocalView()
{
}
@property (nonatomic, strong) VSVideoRender* mVideoRender;
@property (nonatomic, strong) UILabel* mLabel;

@end


@implementation LocalView

@synthesize mVideoRender;
@synthesize mLabel;

- (void)dealloc{
  NSLog(@"LocalView dealloc");
}

- (id) init {
  self = [super init];
  
  self.backgroundColor = [UIColor grayColor];
  
  mVideoRender = [[VConductorClient sharedInstance] createVideoRender];
  [self addSubview:mVideoRender.render_view];
  [mVideoRender.render_view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.with.top.equalTo(self);
    make.size.equalTo(self);
  }];
  [mVideoRender set_content_mode:UIViewContentModeScaleAspectFit];

  
  mLabel = [[UILabel alloc] init];
  [mLabel setText:@""];
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

- (void)bindMedia {
  [[VConductorClient sharedInstance] bindLocalVideoRender:mVideoRender];
// [LogHelper writeClockLog:[NSString stringWithFormat:@"%@------%@",@"教练视频绑定流",@"[mLocalView bindMedia]"]];
}

- (void)unbindMedia {
  [[VConductorClient sharedInstance] unbindLocalVideoRender:mVideoRender];
}

@end
