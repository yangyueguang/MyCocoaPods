
//
//  UILabel+Extension.swift
import Foundation
import UIKit
public extension UILabel {
    //下划线
    func bottomLine(_ str : String) -> Void {
        let str1 = NSMutableAttributedString(string: str)
        let range1 = NSRange(location: 0, length: str1.length)
        let number = NSNumber(value: NSUnderlineStyle.single.rawValue as Int)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
        str1.addAttribute(NSAttributedString.Key.underlineStyle, value: number, range: range1)
        str1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range1)
        self.attributedText = str1
    }
    func txtCopy(_ item: Any) {
        UIPasteboard.general.string = text
        print("________copy:\(String(describing: text))")
    }
    public convenience init(frame: CGRect, text: String, font: UIFont, color: UIColor = .black, alignment: NSTextAlignment = .left, lines: Int = 0, lineSpace: CGFloat?, shadowColor: UIColor = UIColor.clear) {
        self.init(frame: frame)
        self.font = font
        self.text = text
        self.backgroundColor = UIColor.clear
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = lines
        self.shadowColor = shadowColor
        if let lineSpace = lineSpace {
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = lineSpace
            let attributedString = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle:paragraphStye])
            self.attributedText = attributedString
        }
    }

//    -(void)lableCopy{
//    if ([self isKindOfClass:[UILabel class]]) {
//    self.userInteractionEnabled=YES;
//    //长按
//    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [self addGestureRecognizer:recognizer];
//    }
//    }
//    -(void)longPress:(UILongPressGestureRecognizer *)longPress{
//    UILabel *lbl=(UILabel *)longPress.view;
//    [self becomeFirstResponder];
//    UIMenuController *popMenu = [UIMenuController sharedMenuController];
//    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(txtCopy:)];
//    NSArray *menuItems = [NSArray arrayWithObjects:item1,nil];
//    [popMenu setMenuItems:menuItems];
//    [popMenu setArrowDirection:UIMenuControllerArrowDown];
//    [popMenu setTargetRect:self.bounds inView:self];
//    [popMenu setMenuVisible:YES animated:YES];
//    NSLog(@"________长按:%@",lbl.text);
//    }
//    -(void)txtCopy:(id)item{
//    //  UIMenuController *menu=(UIMenuController*)item;
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    pboard.string = self.text;
//    NSLog(@"________copy:%@",self.text);
//    }

}

