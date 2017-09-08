

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(Addition)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

-(BOOL) containsSubView:(UIView *)subView;
-(BOOL) containsSubViewOfClassType:(Class)aclass;


-(void)roundCorner;
-(void)rotateViewStart;
-(void)rotateViewStop;
-(void)addSubviews:(UIView *)view,...;

//for UIImageView & UIButton.backgroudImage
-(void)imageWithURL:(NSString *)url;
-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress useActivity:(BOOL)useActivity;
-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress useActivity:(BOOL)useActivity defaultImage:(NSString *)strImage;


/**
 *  (方树风) 快速创建一个带默认文字的TextView 实现下面的代理方法即可
 *
 -(void)textViewDidChange:(UITextView *)textView
 {
 UIView *la = (UILabel *)[textView.superview viewWithTag:100];
 
 
 if (textView.text.length) {
 la.hidden = YES;
 }else{
 la.hidden = NO;
 }
 }
 */
+(UIView *)setTextViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(id<UITextViewDelegate>)delegate;

@end
