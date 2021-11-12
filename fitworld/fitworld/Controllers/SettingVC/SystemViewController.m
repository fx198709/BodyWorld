//
//  UserCenterViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import "SystemViewController.h"
#import "ResetPwdController.h"
#import "LoginController.h"
#import "ChangeInfoViewController.h"
#import "ChangeIntroductionViewController.h"
#import "SelectCountryViewController.h"
#import "OurDatePickerView.h"
#import "NSDate+MT.h"
#import "UIImage+Extension.h"

@interface SystemViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
OurDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pwdTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nickTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *languageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;


@property (weak, nonatomic) IBOutlet UILabel *genderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;


@property (weak, nonatomic) IBOutlet UILabel *mobileTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;


@property (weak, nonatomic) IBOutlet UILabel *birthdayTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;


@property (weak, nonatomic) IBOutlet UILabel *heightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;


@property (weak, nonatomic) IBOutlet UILabel *weightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;


@property (weak, nonatomic) IBOutlet UILabel *cityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@property (weak, nonatomic) IBOutlet UILabel *introductionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;


@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;



@end

@implementation SystemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ChineseStringOrENFun(@"系统设置",@"PERSONAL SETTING");
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    //获取用户信息
    [[APPObjOnce sharedAppOnce] getUserinfo:^(bool isSuccess) {
        if (isSuccess) {
            [self loadData];
        }
    }];
}

- (void)initUI {
    self.pwdTitleLabel.text = ChineseStringOrENFun(@"修改密码", @"Change the password");
    self.headTitleLabel.text = ChineseStringOrENFun(@"头像", @"Head portrait");
    self.nickTitleLabel.text = ChineseStringOrENFun(@"昵称", @"Nickname");
    self.languageTitleLabel.text = ChineseStringOrENFun(@"语言", @"Language");
    self.genderTitleLabel.text = ChineseStringOrENFun(@"性别", @"Gender");
    self.mobileTitleLabel.text = ChineseStringOrENFun(@"手机号", @"Telephone");
    self.birthdayTitleLabel.text = ChineseStringOrENFun(@"生日", @"Date of birth");
    self.heightTitleLabel.text = ChineseStringOrENFun(@"身高", @"Height");
    self.weightTitleLabel.text = ChineseStringOrENFun(@"体重", @"Weight");
    self.cityTitleLabel.text = ChineseStringOrENFun(@"所在城市", @"Location");
    self.introductionTitleLabel.text = ChineseStringOrENFun(@"介绍", @"Introduction");
    
    self.logoutBtn.titleLabel.text = ChineseStringOrENFun(@"退出登录", @"Logout");
    
    [self.headImg cornerHalfWithBorderColor:[UIColor darkGrayColor]];
    [self.logoutBtn cornerWithRadius:6.0 borderColor:[self.logoutBtn backgroundColor]];
    
}

- (void)loadData {
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    
    self.headImg.hidden = [NSString isNullString:user.avatar];
    if (!self.headImg.hidden) {
        NSString *url = [FITAPI_HTTPS_ROOT stringByAppendingString:user.avatar];
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    self.nickLabel.text = user.nickname;
    self.languageLabel.text = ISChinese() ? @"中文" : @"English";
    self.genderLabel.text = SexNameFormGender(user.gender);
    self.mobileLabel.text = user.mobile;
    self.birthdayLabel.text = user.birthday;
    self.weightLabel.text = IntToString(user.weight);
    self.heightLabel.text = IntToString(user.height);
    self.cityLabel.text = [NSString stringWithFormat:@"%@-%@", user.country, user.city];
    self.introductionLabel.text = user.introduction;
}


#pragma mark - Action


//修改密码
-(IBAction)changePwd:(id)sender {
    [self.view endEditing:YES];

    ResetPwdController *nextVC = VCBySBName(@"ResetPwdController");
    [self.navigationController pushViewController:nextVC animated:YES];
}

//修改头像
- (IBAction)changeHeadImg:(id)sender {
    [self.view endEditing:YES];

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"拍照", @"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImgPicker:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"相册", @"Photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImgPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

//显示拍摄/照片
- (void)showImgPicker:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSString *msg = ChineseStringOrENFun(@"请打开相册权限", @"Please open photo privacy");
        [MTHUD showDurationNoticeHUD:msg];
        return;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = sourceType;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

//修改语言
-(IBAction)changeLanguage:(id)sender {
    [self.view endEditing:YES];

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showChangeLanguageTip:LanguageEnum_English];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showChangeLanguageTip:LanguageEnum_Chinese];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showChangeLanguageTip:(LanguageEnum)languageEnum {
    NSString *tips = ChineseStringOrENFun(@"是否确认更改默认语言?", @"the display lauguage will been changed");
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:ChineseStringOrENFun(@"提示", @"tips") message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:ChineseStringOrENFun(@"确定", @"yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存当前语言
        [ConfigManager sharedInstance].language = languageEnum;
        [[ConfigManager sharedInstance] saveConfig];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"no") style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:cancle];
    [alter addAction:sure];
    
    [self presentViewController:alter animated:YES completion:nil];
}

//修改性别
-(IBAction)changeSex:(id)sender {
    [self.view endEditing:YES];

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:SexNameFormGender(GenderEnum_Male) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeSexFromServer:GenderEnum_Male];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:SexNameFormGender(GenderEnum_Female) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeSexFromServer:GenderEnum_Female];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

//修改手机号
-(IBAction)changeMobile:(id)sender {
    //不能修改手机号
}

//修改生日
-(IBAction)changeBirthday:(id)sender {
    [self.view endEditing:YES];

    OurDatePickerView *datepickerView = [[OurDatePickerView alloc] init];
    datepickerView.pickerDelegate = self;
    datepickerView.pickerType = YearMonAndDay;
    datepickerView.minuteInterval = 1;
    
    datepickerView.leftmaxDate = [NSDate date];
    [datepickerView pickerViewWithView:self.view];
}

//修改昵称
-(IBAction)changeNickName:(id)sender {
    [self.view endEditing:YES];
    [self goToChangeInfoViewController:ChangeTypeEnum_NickName];
    
}

//修改身高
-(IBAction)changeHeight:(id)sender {
    [self.view endEditing:YES];
    [self goToChangeInfoViewController:ChangeTypeEnum_Height];
}

//修改体重
-(IBAction)changeWeight:(id)sender {
    [self.view endEditing:YES];
    [self goToChangeInfoViewController:ChangeTypeEnum_Weight];
}

//修改所在城市
-(IBAction)changeCity:(id)sender {
    [self.view endEditing:YES];
    SelectCountryViewController *nextVC = VCBySBName(@"SelectCountryViewController");
    [self.navigationController pushViewController:nextVC animated:YES];
}

//修改介绍
-(IBAction)ChangeIntroduction:(id)sender {
    [self.view endEditing:YES];
    ChangeIntroductionViewController *nextVC = VCBySBName(@"ChangeIntroductionViewController");
    [self.navigationController pushViewController:nextVC animated:YES];
}

//跳转到修改页面
- (void)goToChangeInfoViewController:(ChangeTypeEnum)type {
    [self.view endEditing:YES];
    ChangeInfoViewController *nextVC = VCBySBName(@"ChangeInfoViewController");
    nextVC.changeType = type;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)loginOut:(id)sender {
    [self.view endEditing:YES];

    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"确定退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
        LoginController *loginVC = VCBySBName(@"LoginController");
        [self.navigationController setViewControllers:[NSArray arrayWithObject:loginVC] animated:YES];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:sure];
    [alter addAction:cancle];
    
    [self presentViewController:alter animated:YES completion:nil];
}

#pragma mark - server


- (void)changeSexFromServer:(GenderEnum)gender {
    NSDictionary *param = @{@"gender" : IntToString(gender)};
    [self changeUserInfoFromServer:param];
}

//发送修改信息到服务器
- (void)changeUserInfoFromServer:(NSDictionary *)param {
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] PUT:@"user" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        if ([responseObject objectForKey:@"recordset"]) {
            [APPObjOnce sharedAppOnce].currentUser = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
            [self loadData];
            [MTHUD showDurationNoticeHUD:ChangeSuccessMsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}

- (void)changeAvatarImageFromServer:(NSData *)imgData {
    NSString *url = @"user/avatar";
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:url parameters:nil file:imgData success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        if ([responseObject objectForKey:@"recordset"]) {
            [APPObjOnce sharedAppOnce].currentUser.avatar = responseObject;
            [self loadData];
            [MTHUD showDurationNoticeHUD:ChangeSuccessMsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD hideHUD:YES completedBlock:^{
            [self showChangeFailedError:error];
        }];
    }];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editImg = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *img = editImg == nil ? originImage : editImg;
    img = [img scaleImageToSize:CGSizeMake(60, 60)];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
        [self changeAvatarImageFromServer:imgData];
    }];
}


// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DataPicker

- (void)seletedDate:(NSDate*)selectedDate andview:(OurDatePickerView*)pickerView{
    NSString *birthday =  [selectedDate mt_formatString:DateFormatter_Day];
    NSDictionary *param = @{@"birthday" : birthday};
    [self changeUserInfoFromServer:param];
}

@end
