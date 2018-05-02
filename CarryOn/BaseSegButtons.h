//
//  BaseSegButtons.h
//  HTFProject
#import <UIKit/UIKit.h>
@interface BaseSegButtons : UIScrollView
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items font:(UIFont*)font;
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items font:(UIFont*)font itemBgColor:(UIColor*)color;
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items font:(UIFont*)font itemBgColor:(UIColor*)color scrollAble:(BOOL)canScroll;
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong)void (^didSelectBlock)(NSInteger index);
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSMutableArray *buttonItems;
@end
