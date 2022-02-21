//
//  BaseRoomViewController.m
//  FFitWorld
//
//  Created by feixiang on 2022/1/23.
//

#import "BaseRoomViewController.h"
#import "AfterTrainingViewController.h"
@interface BaseRoomViewController ()

@end

@implementation BaseRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needChangeOrientation) {
        [self performSelector:@selector(changeOrientation) withObject:nil afterDelay:0.5];
    }
}

- (void)changeOrientation{
    
}

- (void)leaveRoomwithCutsomer{
    
}

- (void)removeAboveView{
    
}

#pragma mark 跳转到完成页面
- (void)realjumpToTrainingvc:(NSTimeInterval)during{
    AfterTrainingViewController *trainingvc = [[AfterTrainingViewController alloc] initWithNibName:@"AfterTrainingViewController" bundle:nil];
    trainingvc.event_id = _mCode[@"eid"];
    trainingvc.invc = self.invc;
    trainingvc.during = during;
    [self.navigationController pushViewController:trainingvc animated:YES];
}
//跳转之前，需要发一个请求
- (void)jumpToTrainingvc{
    [self removeAboveView];
    NSTimeInterval duringTime = 0;
    if (_startliveingTime) {
        duringTime = [[NSDate date] timeIntervalSinceDate:_startliveingTime];
    }
//    duration    76
//    heart_rate_max    0
//    event_id    393747062606268932
//    heart_rate_min    0
//    calorie    0
//    record_time    1644221213
    if (duringTime > 0) {
//        大于0 ，发一个训练的时长给后端
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
        NSDictionary *baddyParams = @{
            @"event_id": self.mCode[@"eid"],
            @"duration":[NSNumber numberWithInteger:duringTime],
            @"heart_rate_max":[NSNumber numberWithInteger:0],
            @"heart_rate_min":[NSNumber numberWithInteger:0],
            @"calorie":[NSNumber numberWithInteger:0],
            @"record_time":[NSString stringWithFormat:@"%llu",(UInt64)[[NSDate date] timeIntervalSince1970]],
        };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager POST:@"practise" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self realjumpToTrainingvc:duringTime];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self realjumpToTrainingvc:duringTime];
        }];
    }else{
        [self realjumpToTrainingvc:0];
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//获取主视频的音量
- (int)reachCurrentMainMediaVoice{
    VConductorClient *client = [VConductorClient sharedInstance];
    ClassMember *host = [client getHostMember];
    if (host) {
        return  [host GetMainVolume];
    }
//    没有的话，默认就是10
    return  10;
}

//获取其他成员的音量
- (int)reachGuestMediaVoice{
    VConductorClient *client = [VConductorClient sharedInstance];
    NSDictionary *dic = [client getGustMemberData];
    if (dic && dic.allKeys.count >0) {
        NSString *key =[dic.allKeys firstObject];
        ClassMember *guest = [dic objectForKey:key];
        if (guest) {
            return  [guest GetMainVolume];
        }
    }
    
//    没有的话，默认就是10
    return  10;
}

//+ (void)configAvSessionCategoryWithError:(NSError **)error {
//    AVAudioSession *session = [AVAudioSession sharedInstance];
////    int currentVoice = [session outputVolume];
////    //AVAudioSessionCategorySoloAmbient是系统默认的category
////    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
////
////    //激活AVAudioSession
////    [session setActive:YES error:nil];
//}

- (void)changeMainVoice:(int)value{
    VConductorClient *client = [VConductorClient sharedInstance];
    ClassMember *host = [client getHostMember];
    if (host) {
        [host SetMainVolume:value];
    }
    
}
- (void)changeGuestVoice:(int)value{
    VConductorClient *client = [VConductorClient sharedInstance];
    NSDictionary *dic = [client getGustMemberData];
    if (dic && dic.allKeys.count >0) {
        for (NSString *key in dic.allKeys) {
            ClassMember *guest = [dic objectForKey:key];
            if (guest) {
                [guest SetMainVolume:value];
            }
        }
        
    }
}


@end
