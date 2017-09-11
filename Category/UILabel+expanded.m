//
//  UILabel+expanded.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "UILabel+expanded.h"

@implementation UILabel (expanded)

-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(txtCopy:)) {
        return YES;
    }
    return NO;
}

-(void)lableCopy{
    if ([self isKindOfClass:[UILabel class]]) {
        self.userInteractionEnabled=YES;
        //长按
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:recognizer];
    }
}
-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    UILabel *lbl=(UILabel *)longPress.view;
    [self becomeFirstResponder];
    /*  UIMenuController *menu = [UIMenuController sharedMenuController];
     [menu setTargetRect:self.frame inView:self.superview];
     [menu setMenuVisible:YES animated:YES];
     */
    UIMenuController *popMenu = [UIMenuController sharedMenuController];
    // popMenu set
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(txtCopy:)];
    NSArray *menuItems = [NSArray arrayWithObjects:item1,nil];
    [popMenu setMenuItems:menuItems];
    [popMenu setArrowDirection:UIMenuControllerArrowDown];
    [popMenu setTargetRect:self.bounds inView:self];
    [popMenu setMenuVisible:YES animated:YES];
    NSLog(@"________长按:%@",lbl.text);
}
-(void)txtCopy:(id)item{
    //  UIMenuController *menu=(UIMenuController*)item;
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    
    NSLog(@"________copy:%@",self.text);
}
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext{
    return [self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:NSTextAlignmentLeft];
}

+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment setLineSpacing:(float)afloat{
    UILabel *lblTemp=[self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:aalignment];
    if (!aframe.size.height) {
        lblTemp.numberOfLines=0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lblTemp.text];
        NSMutableParagraphStyle *paragraphStyleT = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyleT setLineSpacing:afloat];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleT range:NSMakeRange(0, [atext length])];
        lblTemp.attributedText = attributedString;
        CGSize size = [lblTemp sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        lblTemp.frame=aframe;
    }
    return lblTemp;
}

+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment{
    UILabel *baseLabel=[[UILabel alloc] initWithFrame:aframe];
    if(afont)baseLabel.font=afont;
    if(acolor)baseLabel.textColor=acolor;
    baseLabel.text=atext;
    baseLabel.textAlignment=aalignment;
    baseLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height>20){
        baseLabel.numberOfLines=0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
    baseLabel.backgroundColor=[UIColor clearColor];
    baseLabel.highlightedTextColor=acolor;
    return baseLabel;
}
@end
