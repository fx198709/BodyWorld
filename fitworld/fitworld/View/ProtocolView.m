//
//  ProtocolView.m
//  FFitWorld
//
//  Created by TinaXie on 2021/11/21.
//

#import "ProtocolView.h"


@interface ProtocolView ()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerH;

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *okBtn;
@property (nonatomic, weak) IBOutlet UIButton *noBtn;

@end

@implementation ProtocolView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadView];
}

- (void)loadView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.containerView cornerWithRadius:8.0 borderColor:self.containerView.backgroundColor];
    self.containerView.backgroundColor = UIColor.whiteColor;
    [self.okBtn cornerHalfWithBorderColor:self.okBtn.backgroundColor];
    [self.noBtn cornerHalfWithBorderColor:self.noBtn.backgroundColor];
    
    float top = 20.0;
    float maxH = 465;
    if (ScreenHeight > maxH + top * 2.0) {
        self.containerH.constant = maxH;
    } else {
        self.containerH.constant = ScreenHeight * 0.65;
    }
    [self updateConstraintsIfNeeded];
        
    self.textView.delegate = self;
    self.textView.backgroundColor = UIColor.whiteColor;
    NSString *content = @"欢迎进入FitWorld真人实时健身世界！\n点击“同意并继续”代表您已阅读并理解《用户协议》和《隐私协议》。\n本应用尊重并保护所有用户的个人隐私权，努力采取各种安全技术保护您的个人信息。当我们收集您的信息，以及获取设备某些权限的时候，我们都将单独征得您的同意。\n若您点击“不同意”，则您将无法使用我们的产品和服务，请您退出本APP。";
    
    UIColor *blueColor = [UIColor blueColor];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attrStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                     range:NSMakeRange(0, content.length)];
    NSDictionary *userDic = @{
        NSLinkAttributeName : [NSURL URLWithString:[NSString stringWithFormat:@"%@/assets/h5/user_guide.html",FITAPI_HTTPS_ROOT]],
        NSForegroundColorAttributeName:blueColor
    };
    NSString *userStr = @"《用户协议》";
    [attrStr setAttributes:userDic range:[content rangeOfString:userStr]];
    
    NSDictionary *privateDic = @{
        NSLinkAttributeName : [NSURL URLWithString:[NSString stringWithFormat:@"%@/assets/h5/private_policy.html",FITAPI_HTTPS_ROOT]],
        NSForegroundColorAttributeName:blueColor
    };
    NSString *privateStr = @"《隐私协议》";
    [attrStr setAttributes:privateDic range:[content rangeOfString:privateStr]];
    
    self.textView.attributedText = attrStr;
}

- (IBAction)exit:(id)sender {
//    什么都不做
//    exit(0);
}

- (IBAction)dismiss:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ProtocolShowKey];
    [self removeFromSuperview];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
