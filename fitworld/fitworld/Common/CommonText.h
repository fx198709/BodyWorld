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



#define ChangeSuccessMsg ChineseStringOrENFun(@"修改成功", @"Success changed")
#define ChangeErrorMsg ChineseStringOrENFun(@"修改失败", @"Change failed")


#define GetValidCodeBtnTitle ChineseStringOrENFun(@"获取验证码", @"Request Code")
#define GetValidCodeBtnTitle_H ChineseStringOrENFun(@"重新获取", @"Request Again")

#define Text_More ChineseStringOrENFun(@"更多", @"More")

#define Text_Buddy ChineseStringOrENFun(@"对练课", @"BUDDY TRAINING")
#define Text_Group ChineseStringOrENFun(@"团课", @"GROUP CLASS")

#endif /* CommonText_h */
