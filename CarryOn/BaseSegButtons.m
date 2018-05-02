//
//  BaseSegButtons.m
//  HTFProject
#import "BaseSegButtons.h"
#define SegButtonH    40
@interface BaseSegButtons()
@property(nonatomic,strong)UIView *redLine;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIColor *itemBgColor;
@property(nonatomic,assign)BOOL canScroll;
@end
@implementation BaseSegButtons
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items{
    self = [self initWithFrame:frame items:items font:[UIFont systemFontOfSize:15]];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items font:(UIFont *)font{
    self = [self initWithFrame:frame items:items font:font itemBgColor:nil];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items font:(UIFont *)font itemBgColor:(UIColor *)color{
    self = [self initWithFrame:frame items:items font:font itemBgColor:color scrollAble:NO];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items font:(UIFont *)font itemBgColor:(UIColor *)color scrollAble:(BOOL)canScroll{
    self = [super initWithFrame:frame];
    self.contentSize = CGSizeMake(0,0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
    self.font = font;
    self.canScroll = canScroll;
    _selectIndex = 0;
    self.buttonItems = [NSMutableArray array];
    self.redLine = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-2, frame.size.width/items.count, 2)];
    self.redLine.backgroundColor = [UIColor redColor];
    self.itemBgColor = color;
    self.items = items;
    if(!color){
        [self addSubview:self.redLine];
    }else{
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    if(selectIndex>=self.buttonItems.count){
        return;
    }
    _selectIndex = selectIndex;
    for(UIButton *temb in self.buttonItems){
        temb.selected = NO;
        temb.backgroundColor = [UIColor clearColor];
        if(self.itemBgColor){
        temb.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        }
    }
    UIButton *sender = self.buttonItems[selectIndex];
    sender.selected = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.itemBgColor){
            sender.backgroundColor = self.itemBgColor;
            sender.layer.borderColor = [UIColor clearColor].CGColor;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.redLine.frame = CGRectMake(self.redLine.frame.origin.x, self.redLine.frame.origin.y,sender.titleLabel.bounds.size.width+10, self.redLine.bounds.size.height) ;
                self.redLine.center = CGPointMake(sender.center.x,self.redLine.center.y);
            } completion:^(BOOL finished) {
            }];
        }
        CGFloat centx =sender.frame.origin.x-self.bounds.size.width/2+sender.frame.size.width/2;
        if(self.contentSize.width< sender.frame.origin.x+(self.bounds.size.width+sender.frame.size.width)/2){
            centx = self.contentSize.width-self.bounds.size.width;
        }else if(centx<0){
            centx = 0;
        }
        [self setContentOffset:CGPointMake(centx, 0) animated:YES];
        if(self.didSelectBlock){
            self.didSelectBlock(sender.tag);
        }
    });
}
-(void)setItems:(NSArray *)items{
    _items = items;
    for(UIButton *a in self.buttonItems){
        [a removeFromSuperview];
    }
    [self.buttonItems removeAllObjects];
    CGFloat starX = 0;
    for(int i=0;i<items.count;i++){
        NSString *title = items[i];
        CGFloat width = self.frame.size.width/items.count;
        if(_canScroll){
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSFontAttributeName] = self.font;
            CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
            CGSize size = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            width = size.width+20;
        }
        UIButton *a = [[UIButton alloc]initWithFrame:CGRectMake(starX, 0, width, self.frame.size.height)];
        [a setTitle:title forState:UIControlStateNormal];
        a.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        a.titleLabel.font = self.font;
        a.tag = i;
        [a setTitleColor:[UIColor colorWithWhite:0.29 alpha:1] forState:UIControlStateNormal];
        if(self.itemBgColor){
            [a setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            a.layer.borderWidth = 1;
            a.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        }else{
            [a setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        }
        [a addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:a];
        [self.buttonItems addObject:a];
        starX += width;
        if(i==0){
            a.selected = YES;
            NSString *title = items.firstObject;
            if(self.itemBgColor){
                a.backgroundColor = self.itemBgColor;
                a.layer.borderColor = [UIColor clearColor].CGColor;
            }
            self.redLine.frame = CGRectMake(self.redLine.frame.origin.x, self.redLine.frame.origin.y,title.length*20, self.redLine.bounds.size.height);
            self.redLine.center = CGPointMake(a.center.x,self.redLine.center.y);
        }
    }
    self.contentSize = CGSizeMake(starX, 0);
}
-(void)buttonSelected:(UIButton*)sender{
    self.selectIndex = sender.tag;
}
@end
