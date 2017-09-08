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

@end
