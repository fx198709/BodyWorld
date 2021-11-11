

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName renderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName renderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    
    // 设置按钮的尺寸为背景图片尺寸
    button.size = button.currentBackgroundImage.size;
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

@end
