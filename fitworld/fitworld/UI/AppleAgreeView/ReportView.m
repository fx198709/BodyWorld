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
    RemoveSubviews(self, @[]);
    CGSize psize = self.bounds.size;
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.text = ChineseStringOrENFun(@"举报", @"Report");
    headLabel.frame =CGRectMake(0, 0, psize.width, 40);
    headLabel.font = SystemFontOfSize(20);
    headLabel.textColor = UIColor.whiteColor;
    headLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:headLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(psize.width-40, 0, 40, 40);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];

    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.frame = CGRectMake(0, 80, psize.width, psize.height-80-60);
    NSArray *titleArray = [NSMutableArray arrayWithObjects:
                           ChineseStringOrENFun(@"低俗色情", @"Report"),
                           ChineseStringOrENFun(@"违法信息", @"Report"),
                           ChineseStringOrENFun(@"广告软文", @"Report"),
                           ChineseStringOrENFun(@"恶意攻击谩骂", @"Report"),
                           ChineseStringOrENFun(@"其他问题", @"Report"),nil];
    _dataArray = [NSMutableArray array];
    for (int index =0 ; index <  titleArray.count; index++) {
        NSString *title = [titleArray objectAtIndex:index];
        ReportReaseonModel *model = [[ReportReaseonModel alloc] initWithString:title andindex:index];
        [_dataArray addObject:model];
        
    }
    
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    int outStartY = 0;
    titleLabel1.frame = CGRectMake(30, outStartY, 200, 30);
    titleLabel1.text = ChineseStringOrENFun(@"举报原因", @"Report");
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
        int startX = index%2?30: psize.width/2;
        CircleBtn *vbtn = [[CircleBtn alloc] initWithFrame:CGRectMake(startX, outStartY, 40, 30)];
        [vbtn changemodel:screenModel];
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
    titleLabel2.text = ChineseStringOrENFun(@"举报描述", @"Report");
    titleLabel2.font = SystemFontOfSize(17);
    titleLabel2.textColor = UIColor.whiteColor;//
    titleLabel2.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:titleLabel2];
    
    outStartY = outStartY+30+20;
    _textview = [[PBTextWithPlaceHoldView alloc] initWithFrame:CGRectMake(30, outStartY, psize.width-60, 100)];
    _textview.placeHoldString =ChineseStringOrENFun(@"请描述你遇到的问题", @"");
    [scrollview addSubview:_textview];
    
    outStartY = outStartY+100+20;
    
    UILabel *titleLabel3 = [[UILabel alloc] init];
    titleLabel3.frame = CGRectMake(30, outStartY, 200, 30);
    titleLabel3.text = ChineseStringOrENFun(@"证明材料", @"Report");
    titleLabel3.font = SystemFontOfSize(17);
    titleLabel3.textColor = UIColor.whiteColor;//
    titleLabel3.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:titleLabel3];
    
    outStartY = outStartY+30+20;
    _uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, outStartY, 100, 100)];
    [scrollview addSubview:_uploadBtn];
    [_uploadBtn addTarget:self action:@selector(changeHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    outStartY = outStartY+100+20;

    UILabel *titleLabel4 = [[UILabel alloc] init];
    titleLabel4.frame = CGRectMake(30, outStartY, psize.width-60, 50);
    titleLabel4.text = ChineseStringOrENFun(@"证明材料", @"Report");
    titleLabel4.font = SystemFontOfSize(14);
    titleLabel4.textColor = UIRGBColor(100, 100, 100, 1);//
    titleLabel4.textAlignment = NSTextAlignmentLeft;
    titleLabel4.numberOfLines = 0;
    titleLabel4.lineBreakMode = NSLineBreakByCharWrapping;
    [scrollview addSubview:titleLabel3];
    scrollview.contentSize =CGSizeMake(0, outStartY+80);
    
    UIButton *reportBtn =[[UIButton alloc] initWithFrame:CGRectMake(30, outStartY, 100, 50)];
    reportBtn.backgroundColor = SelectGreenColor;
    reportBtn.layer.cornerRadius = 25;
    reportBtn.clipsToBounds = YES;
    NSString *reportBtnTitle = ChineseStringOrENFun(@"提交", @"OK");
    [reportBtn setTitle:reportBtnTitle forState:UIControlStateNormal];
    [reportBtn setTitle:reportBtnTitle forState:UIControlStateNormal];

    [self addSubview:reportBtn];
    [reportBtn addTarget:self action:@selector(submittedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)closeBtnClick{
    [self removeFromSuperview];
}


- (IBAction)submittedBtnClicked:(UIButton*)sender {
//   只点击一次
    sender.enabled = NO;
    
    sender.enabled = YES;
}

//修改头像
- (IBAction)changeHeadImg:(id)sender {
    [self endEditing:YES];
    [_rootControl.view endEditing:YES];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"拍照", @"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImgPicker:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"相册", @"Photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImgPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:CancelString style:UIAlertActionStyleCancel handler:nil]];
    
    [_rootControl presentViewController:ac animated:YES completion:nil];
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
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = sourceType;
    [_rootControl presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editImg = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *img = editImg == nil ? originImage : editImg;
//    img = [img scaleImageToSize:CGSizeMake(300, 300)];
    
    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
    [picker dismissViewControllerAnimated:YES completion:^{
        [self changeAvatarImageFromServer:imgData];
    }];
}

- (void)changeAvatarImageFromServer:(NSData *)imgData {
    NSString *url = @"/api/upload";
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:url parameters:nil file:imgData success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSString *avatarUrl = [responseObject objectForKey:@"recordset"];
        if (avatarUrl) {
//            [APPObjOnce sharedAppOnce].currentUser.avatar = avatarUrl;
            [MTHUD showDurationNoticeHUD:ChangeSuccessMsg];
//            [self loadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showChangeFailedError:error];
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
