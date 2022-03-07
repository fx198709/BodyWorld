//
//  CommonText.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/30.
//

#ifndef CommonText_h
#define CommonText_h


//当前语言是不是中文
static inline BOOL ISChinese(){
    return [ConfigManager sharedInstance].language == LanguageEnum_Chinese;
}

UIKIT_STATIC_INLINE  NSString* ChineseOrENFun(NSObject* obj, NSString* key){
    if(ISChinese()){
        NSString *keyString = [NSString stringWithFormat:@"%@_cn",key];
        return [obj valueForKey:keyString];
    }else{
        return [obj valueForKey:key];;//[obj objectForKey:key];
    }
}


#define ChineseOrEN(obj, key)   ({\
if(ISChinese()){\
NSString *keyString = [NSString stringWithFormat:@"%@_cn",key];\
return [obj objectForKey:keyString];\
}else{\
return [obj objectForKey:key];\
})



#define SaveSuccessMsg ChineseStringOrENFun(@"保存成功", @"Saved")
#define ChangeSuccessMsg ChineseStringOrENFun(@"修改成功", @"Success changed")
#define ChangeErrorMsg ChineseStringOrENFun(@"修改失败", @"Change failed")
#define UploadSuccessMsg ChineseStringOrENFun(@"上传成功", @"Success upload")
#define ReportSuccessMsg ChineseStringOrENFun(@"举报成功", @"Success report")
#define ReportErrorMsg ChineseStringOrENFun(@"举报失败", @"Report failed")


#define GetValidCodeBtnTitle ChineseStringOrENFun(@"获取验证码", @"Request Code")
#define GetValidCodeBtnTitle_H ChineseStringOrENFun(@"重新获取", @"Request Again")

#define Text_More ChineseStringOrENFun(@"更多", @"More")

#define Text_Training ChineseStringOrENFun(@"对练课", @"Buddy Training")
#define Text_Group ChineseStringOrENFun(@"团课", @"Group Classes")
#define Text_Private ChineseStringOrENFun(@"私教", @"Personal Training")
#define CancelString ChineseStringOrENFun(@"取消", @"Cancel")
#define OKString ChineseStringOrENFun(@"确认", @"OK")
#define ActionSuccssString ChineseStringOrENFun(@"操作成功", @"Operate Successfully")
#define TrainerString ChineseStringOrENFun(@"教练", @"Trainer")
#define CommitSuccessString ChineseStringOrENFun(@"提交成功", @"Operate Successfully")
#define ChoosePeopleString ChineseStringOrENFun(@"请选择用户", @"Please Choose People")
#define MaxSelectedString ChineseStringOrENFun(@"最多选5项", @"MAX 5 Options")

#define PullDownToRefresh ChineseStringOrENFun(@"下拉刷新", @"Pull down to refresh")
#define ReleaseToRefresh ChineseStringOrENFun(@"松开刷新", @"Release to refresh")
#define Loading ChineseStringOrENFun(@"正在刷新中...", @"Loading...")
#define PullUpToLoadMoreData ChineseStringOrENFun(@"上拉加载更多数据", @"Pull up to load more data")
#define ReleaseToLoadMoreData ChineseStringOrENFun(@"松开加载更多数据", @"Release to load more data")
#define AllDataLoaded ChineseStringOrENFun(@"已经加载全部数据", @"All data loaded")
#define MJCustomerRefreshHeaderLastTimeText ChineseStringOrENFun(@"最后更新：", @"Last update: ")
#define MJNoRecordLastTimeText ChineseStringOrENFun(@"无记录：", @"No record")
#define MJTodayLastTimeText ChineseStringOrENFun(@"今天：", @"Today")


#endif /* CommonText_h */
