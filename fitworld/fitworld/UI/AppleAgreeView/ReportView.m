//
//  ReportView.m
//  FFitWorld
//
//  Created by feixiang on 2022/2/22.
//

#import "ReportView.h"
#import "ReportReaseonModel.h"
#import "CircleBtn.h"
@implementation ReportView

- (void)createSubview{
    uploadImageurl = @"";
    RemoveSubviews(self, @[]);
    viewTextDelegate = [[PBTextWithPlaceHoldViewDelegate alloc] init];
    viewTextDelegate.maxnumber = 500;

    self.backgroundColor = UIRGBColor(0, 0, 0, 1);
    CGSize psize = self.bounds.size;
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.text = ChineseStringOrENFun(@"举报", @"Report");
    headLabel.frame =CGRectMake(0, 0, psize.width, 40);
    headLabel.font = SystemFontOfSize(20);
    headLabel.textColor = UIColor.whiteColor;
    headLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:headLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(psize.width-50, 0, 40, 40);
    UIImage *closeImage = [UIImage imageNamed:@"bigclose"];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [closeBtn setImage:closeImage forState:UIControlStateHighlighted];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self addSubview:closeBtn];

    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.frame = CGRectMake(0, 80, psize.width, psize.height-80-60-30);
    [self addSubview:scrollview];
    NSArray *titleArray = [NSMutableArray arrayWithObjects:
                           ChineseStringOrENFun(@"低俗色情", @"Vulgar content"),
                           ChineseStringOrENFun(@"违法信息", @"Violation of laws or regulations"),
                           ChineseStringOrENFun(@"广告软文", @"Spam ads"),
                           ChineseStringOrENFun(@"恶意攻击谩骂", @"Malicious language attack"),
                           ChineseStringOrENFun(@"其他问题", @"Other reason"),nil];
    _dataArray = [NSMutableArray array];
    for (int index =0 ; index <  titleArray.count; index++) {
        NSString *title = [titleArray objectAtIndex:index];
        ReportReaseonModel *model = [[ReportReaseonModel alloc] initWithString:title andindex:index];
        [_dataArray addObject:model];
    }
    UILabel *titleLabel1 = [[UILabel alloc] init];
    int outStartY = 0;
    titleLabel1.frame = CGRectMake(30, outStartY, 200, 30);
    titleLabel1.text = ChineseStringOrENFun(@"举报原因", @"Reason");
    titleLabel1.font = SystemFontOfSize(17);
    titleLabel1.textColor = UIColor.whiteColor;//
    titleLabel1.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:titleLabel1];
    
    UIColor *contentColor = UIRGBColor(230, 230, 230, 1);
    outStartY = outStartY+30 +10;
    CGSize reaseonItemSize = CGSizeMake((psize.width-60)/2, 30);
    for (int index =0 ; index <  _dataArray.count; index++) {
        ScreenModel *screenModel = [_dataArray objectAtIndex:index];
        if (index%2 == 0 && index != 0) {
            outStartY = outStartY+30+10;
        }
        int startX = index%2 == 0?30: psize.width/2;
        CircleBtn *vbtn = [[CircleBtn alloc] initWithFrame:CGRectMake(startX, outStartY, 40, 30)];
        [vbtn changemodel:screenModel];
        WeakSelf
        vbtn.backBtnClicked = ^(id clickModel) {
            [wSelf circleBtnClicked:clickModel];
        };
        vbtn.tag = 100+index;
        [scrollview addSubview:vbtn];
        
        UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(startX+45, outStartY+5, reaseonItemSize.width-45, 20)];
        vlabel.text = screenModel.name;
        vlabel.font = SystemFontOfSize(14);
        vlabel.textColor = contentColor;//
        vlabel.textAlignment = NSTextAlignmentLeft;
        [scrollview addSubview:vlabel];
    }
    outStartY = outStartY+30+20;
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.frame = CGRectMake(30, outStartY, 200, 30);
    titleLabel2.text = ChineseStringOrENFun(@"举报描述", @"Details");
    titleLabel2.font = SystemFontOfSize(17);
    titleLabel2.textColor = UIColor.whiteColor;//
    titleLabel2.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:titleLabel2];
    UIColor *backGrayColor = UIRGBColor(45, 45, 45, 1);
    outStartY = outStartY+30+20;
    _textview = [[PBTextWithPlaceHoldView alloc] initWithFrame:CGRectMake(30, outStartY, psize.width-60, 100)];
    _textview.placeHoldTextColor= UIRGBColor(200, 200, 200, 1);
    _textview.placeHoldString =ChineseStringOrENFun(@"请描述你遇到的问题", @"Please describe in details.");
    _textview.backgroundColor =backGrayColor; //UIColor.grayColor;
    _textview.layer.cornerRadius = 5;
    _textview.clipsToBounds = YES;
    _textview.textColor = UIColor.whiteColor;
    _textview.delegate = viewTextDelegate;

    [scrollview addSubview:_textview];
    
    outStartY = outStartY+100+20;
    
    UILabel *titleLabel3 = [[UILabel alloc] init];
    titleLabel3.frame = CGRectMake(30, outStartY, 200, 30);
    titleLabel3.text = ChineseStringOrENFun(@"证明材料", @"Evidence");
    titleLabel3.font = SystemFontOfSize(17);
    titleLabel3.textColor = UIColor.whiteColor;//
    titleLabel3.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:titleLabel3];
    
    outStartY = outStartY+30+20;
    _uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, outStartY, 100, 100)];
    [scrollview addSubview:_uploadBtn];
    [_uploadBtn addTarget:self action:@selector(changeHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *uploadimage = [UIImage imageNamed:@"uploadimage"];
    [_uploadBtn setImage:uploadimage forState:UIControlStateNormal];
    [_uploadBtn setImage:uploadimage forState:UIControlStateHighlighted];
    _uploadBtn.backgroundColor = backGrayColor;
    _uploadBtn.layer.cornerRadius = 5;
    _uploadBtn.clipsToBounds = YES;
    outStartY = outStartY+100+20;

    UILabel *titleLabel4 = [[UILabel alloc] init];
    titleLabel4.frame = CGRectMake(30, outStartY, psize.width-60, 50);
    titleLabel4.text = ChineseStringOrENFun(@"请具体指出内容哪些部分存在侵权，并提供构成侵权的初步证据。法人或非法人组织投诉请提供加盖公章的投诉通知", @"Please specify the infringing or violating points and provide related evidence. Legal entities or non-legal entities please submit Report Notice with stamps.");
    titleLabel4.font = SystemFontOfSize(14);
    titleLabel4.textColor = UIRGBColor(100, 100, 100, 1);//
    titleLabel4.textAlignment = NSTextAlignmentLeft;
    titleLabel4.numberOfLines = 0;
    titleLabel4.lineBreakMode = NSLineBreakByCharWrapping;
    [scrollview addSubview:titleLabel4];
    scrollview.contentSize =CGSizeMake(0, outStartY+80);
    
    UIButton *reportBtn =[[UIButton alloc] initWithFrame:CGRectMake(30, psize.height-80, psize.width-60, 50)];
    reportBtn.backgroundColor = SelectGreenColor;
    reportBtn.layer.cornerRadius = 25;
    reportBtn.clipsToBounds = YES;
    NSString *reportBtnTitle = ChineseStringOrENFun(@"提交", @"Done");
    [reportBtn setTitle:reportBtnTitle forState:UIControlStateNormal];
    [reportBtn setTitle:reportBtnTitle forState:UIControlStateNormal];

    [self addSubview:reportBtn];
    [reportBtn addTarget:self action:@selector(submittedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)circleBtnClicked:(ScreenModel*)inModel{
    for (int index =0 ; index <  _dataArray.count; index++) {
        ScreenModel* model = [_dataArray objectAtIndex:index];
        CircleBtn *vbtn = [self viewWithTag:100+index];
        if ([inModel.id isEqualToString:model.id]) {
            model.hasSelected =YES;
        }else{
            model.hasSelected =NO;
        }
        [vbtn changemodel:model];
    }
}

- (void)closeBtnClick{
//    [self removeFromSuperview];
    if ([_rootControl respondsToSelector:@selector(closeReportView)]) {
        [_rootControl performSelector:@selector(closeReportView)];
    }
}


- (IBAction)submittedBtnClicked:(UIButton*)sender {
//   只点击一次
    sender.enabled = NO;
/*
 /api/report   [post]
   type         string   举报类型   单选  1 2 3 4
   content    string 内容
   pictures   string   多个图片逗号分隔

 */
    NSString *selectType = @"1";
    for (int index =0 ; index <  _dataArray.count; index++) {
        ScreenModel* model = [_dataArray objectAtIndex:index];
        if (model.hasSelected) {
            selectType= model.id;
        }
    }
    NSDictionary *param =@{@"type":selectType,@"content":_textview.text,@"pictures":uploadImageurl};// @{@"friend_id": StringWithDefaultValue(friend.id, @"")};
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"report" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSString *result = [responseObject objectForKey:@"recordset"];
        if ([result isEqualToString:@"success"]) {
//            [self.dataList removeObject:friend];
//            [self.tableView reloadData];
            [MTHUD showDurationNoticeHUD:ReportSuccessMsg];
            [self closeBtnClick];
        }else{
            [MTHUD showDurationNoticeHUD:ReportErrorMsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showChangeFailedError:error];
        NSString *msg = error == nil ? ChangeErrorMsg : error.localizedDescription;
        [MTHUD showDurationNoticeHUD:msg];
    }];
    sender.enabled = YES;
}

//修改头像
- (IBAction)changeHeadImg:(id)sender {
    [self endEditing:YES];
    [_rootControl.view endEditing:YES];
//    只能弹出照片
    [self showImgPicker:UIImagePickerControllerSourceTypePhotoLibrary];
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"拍照", @"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self showImgPicker:UIImagePickerControllerSourceTypeCamera];
//    }]];
//
//    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"相册", @"Photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self showImgPicker:UIImagePickerControllerSourceTypePhotoLibrary];
//    }]];
//    [ac addAction:[UIAlertAction actionWithTitle:CancelString style:UIAlertActionStyleCancel handler:nil]];
//
//    [_rootControl presentViewController:ac animated:YES completion:nil];
}

//显示拍摄/照片
- (void)showImgPicker:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSString *msg = ChineseStringOrENFun(@"请打开相册权限", @"Please open photo privacy");
        [MTHUD showDurationNoticeHUD:msg];
        return;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = _rootControl;
//    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = sourceType;
    [_rootControl presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editImg = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *img = editImg == nil ? originImage : editImg;
//    img = [img scaleImageToSize:CGSizeMake(300, 300)];
    currentImage = img;
    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
    [picker dismissViewControllerAnimated:YES completion:^{
        [self changeAvatarImageFromServer:imgData];
    }];
}

- (void)changeAvatarImageFromServer:(NSData *)imgData {
    NSString *url = @"upload";
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:url parameters:nil file:imgData success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSString *avatarUrl = [responseObject objectForKey:@"recordset"];
        if (avatarUrl) {
//            Printing description of avatarUrl:
            [self->_uploadBtn setImage:currentImage forState:UIControlStateNormal];
            [self->_uploadBtn setImage:currentImage forState:UIControlStateHighlighted];
            self->uploadImageurl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, avatarUrl];
            [MTHUD showDurationNoticeHUD:UploadSuccessMsg];
//            [self loadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showChangeFailedError:error];
        [MTHUD hideHUD];
    }];
}



// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
