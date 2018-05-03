//
//  UITextField+expanded.m
//  MyCocoaPods
#import "UITextField+expanded.h"
@implementation UITextField (expanded)
+ (UITextField *)textFieldlWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor placeholder:(NSString *)aplaceholder text:(NSString*)atext{
    UITextField *baseTextField=[[UITextField alloc]initWithFrame:aframe];
    [baseTextField setKeyboardType:UIKeyboardTypeDefault];
    [baseTextField setBorderStyle:UITextBorderStyleNone];
    [baseTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [baseTextField setTextColor:acolor];
    baseTextField.placeholder=aplaceholder;
    baseTextField.font=afont;
    [baseTextField setSecureTextEntry:NO];
    [baseTextField setReturnKeyType:UIReturnKeyDone];
    [baseTextField setText:atext];
    baseTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return baseTextField;
}
@end
