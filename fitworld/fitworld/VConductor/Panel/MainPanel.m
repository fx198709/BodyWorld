#import "MainPanel.h"
#import "UIDeps.h"
#import "LocalView.h"
#import "RemoteView.h"

#import "../Widgets/LocalView.h"
#import "../Widgets/RemoteView.h"

#import "VConductorClient.h"
#import "LogHelper.h"

@interface MainPanel () {
}

@property (nonatomic, strong) LocalView* mLocalView;
@property (nonatomic, strong) NSMutableDictionary *mMainViews;
@property (nonatomic, strong) NSMutableDictionary *mShareViews;
@property (nonatomic, strong) UIImageView *waitImageview;



@property (nonatomic, strong) UITapGestureRecognizer *mDoubleTapGesture;
@property (nonatomic, assign) PlayoutLayoutMode mLayout;
@end

@implementation MainPanel

@synthesize mLocalView;
@synthesize mMainViews;
@synthesize mShareViews;
@synthesize mDoubleTapGesture;
@synthesize mLayout;


- (void)dealloc{
    NSLog(@"MainPanel dealloc");
}

- (id)init {
    self = [super init];
    
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    
    mMainViews = [NSMutableDictionary new];
    mShareViews = [NSMutableDictionary new];
    
    mDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDoubleTapped:)];
    mDoubleTapGesture.numberOfTapsRequired = 2;
    mDoubleTapGesture.cancelsTouchesInView = YES;
    [self addGestureRecognizer:mDoubleTapGesture];
    mLayout = PLAYOUT_LAYOUT_GRID;
    [LogHelper writeClockLog:[NSString stringWithFormat:@"------%@",@"教练视频初始化"]];
    return self;
}

-(void)viewDoubleTapped:(UITapGestureRecognizer *)tapGr{
    if (self.viewDoubleTapped) {
        self.viewDoubleTapped();
    }
}

- (void)attachLocalView {
    if (mLocalView == nil) {
        mLocalView = [LocalView new];
        [self addSubview:mLocalView];
    }
    [mLocalView bindMedia];
//    [LogHelper writeClockLog:[NSString stringWithFormat:@"%@------%@",@"教练视频绑定流",@"[mLocalView bindMedia]"]];

    [self syncRemoteView];
    [self relayoutVideoView];
    NSLog(@"needLayout M");
}

- (void)createPlaceImageView{
    if (!_waitImageview) {
        _waitImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self addSubview:_waitImageview];
        _waitImageview.image = [UIImage imageNamed:@"pg_room_waitting_bg"];
        _waitImageview.contentMode = UIViewContentModeScaleAspectFill;
    }
    _waitImageview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (void)changePlaceImage:(UIInterfaceOrientation)orientation{
    if (orientation == UIInterfaceOrientationPortrait) {
        _waitImageview.image = [UIImage imageNamed:@"pg_room_waitting_bg"];
    }else{
        _waitImageview.image = [UIImage imageNamed:@"landpage-video"];
    }
    _waitImageview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

}


- (void)detachLocalView {
    if (mLocalView == nil) {
        return;
    }
    [mLocalView unbindMedia];
    [mLocalView removeFromSuperview];
    mLocalView = nil;
    
    [self syncRemoteView];
    [self relayoutVideoView];
    NSLog(@"needLayout N");
}

- (void)setLectureLayout:(BOOL)isLecture {
    mLayout = isLecture ? PLAYOUT_LAYOUT_LECTURE : PLAYOUT_LAYOUT_GRID;
    NSLog(@"setLectureLayout----- %ld", (long)mLayout);
    [self relayoutVideoView];
}

- (void)syncRemoteView {
    BOOL needLayout = NO;
    NSDictionary *onAirMembers = [[VConductorClient sharedInstance] getOnAirMembers];
    
    // remove not exist guests main views
    NSMutableDictionary *newMainViews = [NSMutableDictionary new];
    for (RemoteView *guestView in mMainViews.allValues) {
        if ([onAirMembers objectForKey:guestView.userId] == nil) {
            [guestView unbindMedia];
            [guestView removeFromSuperview];
            needLayout = YES;
        } else {
            [newMainViews setObject:guestView forKey:guestView.userId];
        }
    }
    mMainViews = newMainViews;
    
    // remove not exist guests share views
    NSMutableDictionary *newShareViews = [NSMutableDictionary new];
    for (RemoteView *shareView in mShareViews.allValues) {
        ClassMember *member = [onAirMembers objectForKey:shareView.userId];
        BOOL isSharing = (member != nil) ? member.isSharing : NO;
        if (!isSharing) {
            [shareView unbindMedia];
            [shareView removeFromSuperview];
            needLayout = YES;
        } else {
            [newShareViews setObject:shareView forKey:shareView.userId];
        }
    }
    mShareViews = newShareViews;
    
    for (ClassMember *guest in onAirMembers.allValues) {
        RemoteView *mainView = [mMainViews objectForKey:guest.userId];
        if (mainView == nil) {
            mainView = [[RemoteView alloc] initWithUserId:guest.userId forMainVideo:YES];
            [self addSubview:mainView];
            [mMainViews setObject:mainView forKey:guest.userId];
            needLayout = YES;
        }
        [mainView bindMedia];
    }
    if (needLayout) {
        [self relayoutVideoView];
    }
}

- (void) relayoutVideoView {
    [self removeConstraints:self.constraints];
    
    if (mLayout == PLAYOUT_LAYOUT_GRID) {
        NSMutableArray *viewArr = [NSMutableArray new];
        if (mLocalView != nil) {
            [viewArr addObject:mLocalView];
        }
        if (mShareViews.count > 0) {
            UIView *shareView = [mShareViews objectForKey:mShareViews.allKeys.firstObject];
            [viewArr addObject:shareView];
        }
        
        NSArray *viewKeyArr = [mMainViews allKeys];
        NSArray *sortedViewKeyArr = [viewKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        for (NSString *viewKey in sortedViewKeyArr) {
            [viewArr addObject:[mMainViews objectForKey:viewKey]];
        }
        
        if (viewArr.count == 1) {
            UIView *firstView = viewArr[0];
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.bottom.equalTo(self);
                make.size.equalTo(self);
            }];
        } else if (viewArr.count == 2) {
            UIView *firstView = viewArr[0];
            UIView *secondView = viewArr[1];
            
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.centerY.equalTo(self);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(firstView.mas_width).multipliedBy(0.5625);
            }];
            [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(firstView.mas_right);
                make.centerY.equalTo(self);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(secondView.mas_width).multipliedBy(0.5625);
            }];
        } else if (viewArr.count == 3) {
            UIView *firstView = viewArr[0];
            UIView *secondView = viewArr[1];
            UIView *thirdView = viewArr[2];
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_centerY);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(firstView.mas_width).multipliedBy(0.5625);
            }];
            [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.equalTo(self.mas_centerY);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(secondView.mas_width).multipliedBy(0.5625);
            }];
            [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(secondView.mas_right);
                make.top.equalTo(self.mas_centerY);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(thirdView.mas_width).multipliedBy(0.5625);
            }];
        } else if (viewArr.count == 4) {
            UIView *firstView = viewArr[0];
            UIView *secondView = viewArr[1];
            UIView *thirdView = viewArr[2];
            UIView *fourthView = viewArr[3];
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.bottom.equalTo(self.mas_centerY);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(firstView.mas_width).multipliedBy(0.5625);
            }];
            [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(firstView.mas_right);
                make.bottom.equalTo(self.mas_centerY);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(secondView.mas_width).multipliedBy(0.5625);
            }];
            [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.equalTo(self.mas_centerY);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(thirdView.mas_width).multipliedBy(0.5625);
            }];
            [fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(thirdView.mas_right);
                make.top.equalTo(self.mas_centerY);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.equalTo(fourthView.mas_width).multipliedBy(0.5625);
            }];
        }
    } else {
        if (mShareViews.count > 0) {
            UIView *shareView = [mShareViews objectForKey:mShareViews.allKeys.firstObject];
            [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.bottom.equalTo(self);
                make.width.equalTo(self);
                //make.height.equalTo(self.mHostShareView.mas_width).multipliedBy(0.5625);
                make.height.equalTo(self).multipliedBy(0.875);
            }];
        }
        
        NSMutableArray *viewArr = [NSMutableArray new];
        if (mLocalView != nil) {
            [viewArr addObject:mLocalView];
        }
        NSArray *viewKeyArr = [mMainViews allKeys];
        NSArray *sortedViewKeyArr = [viewKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        for (NSString *viewKey in sortedViewKeyArr) {
            [viewArr addObject:[mMainViews objectForKey:viewKey]];
        }
        
        if (viewArr.count == 1) {
            UIView *firstView = viewArr[0];
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.and.top.equalTo(self);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
        } else if (viewArr.count == 2) {
            UIView *firstView = viewArr[0];
            UIView *secondView = viewArr[1];
            
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_centerX);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
            [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
        } else if (viewArr.count == 3) {
            UIView *firstView = viewArr[0];
            UIView *secondView = viewArr[1];
            UIView *thirdView = viewArr[2];
            [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.centerX.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(secondView.mas_left);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
            [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(secondView.mas_right);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
        } else if (viewArr.count == 4) {
            UIView *firstView = viewArr[0];
            UIView *secondView = viewArr[1];
            UIView *thirdView = viewArr[2];
            UIView *fourthView = viewArr[3];
            [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_centerX);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(secondView.mas_left);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
            [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
            [fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(thirdView.mas_right);
                make.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.125);
                make.width.equalTo(firstView.mas_height).multipliedBy(1.7778);
            }];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
