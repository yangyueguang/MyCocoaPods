
//  BaseScrollView.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/13.
//  Copyright © 2016年 薛超. All rights reserved.
#import "BaseScrollView.h"
#import <objc/runtime.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface UIGestureRecognizer (BaseScroll)
- (instancetype)initWithActionBlock:(void (^)(id sender))block;
- (void)addActionBlock:(void (^)(id sender))block;
- (void)removeAllActionBlocks;
@end
static const int block_key;
@interface BaseScrollRBlock : NSObject
@property (nonatomic, copy) void (^block)(id sender);
- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;
@end
@implementation BaseScrollRBlock
- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }return self;
}
- (void)invoke:(id)sender {
    if (_block) _block(sender);
}
@end
@implementation UIGestureRecognizer (BaseScroll)
- (instancetype)initWithActionBlock:(void (^)(id sender))block {
    self = [self init];
    [self addActionBlock:block];
    return self;
}
- (void)addActionBlock:(void (^)(id sender))block {
    BaseScrollRBlock *target = [[BaseScrollRBlock alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _yy_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}
- (void)removeAllActionBlocks{
    NSMutableArray *targets = [self _yy_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}
- (NSMutableArray *)_yy_allUIGestureRecognizerBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
@end

#define APPW              [UIScreen mainScreen].bounds.size.width
#define APPH              [UIScreen mainScreen].bounds.size.height
#define Font(x)           [UIFont systemFontOfSize:x]
#define W(obj)            (!obj?0:(obj).frame.size.width)
#define H(obj)            (!obj?0:(obj).frame.size.height)
#define X(obj)            (!obj?0:(obj).frame.origin.x)
#define Y(obj)            (!obj?0:(obj).frame.origin.y)
#define XW(obj)           (X(obj)+W(obj))
#define YH(obj)           (Y(obj)+H(obj))
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
@interface BaseScrollView(){
    NSInteger count;
    NSInteger index;
    UIPageControl *pagecontroller;
    BOOL _round;//小项目滑动的图标要不要圆
    CGSize _size;//小项目滑动的图标尺寸大小
    NSInteger _hang;//小项目滑动的图标行数
    
}
@end
@implementation BaseScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        index = 0;
        self.frame = frame;
    } return self;
}

- (NSMutableArray *)contentViews{
    if (_contentViews == nil) {
        _contentViews = [NSMutableArray array];
    }
    return _contentViews;
}
//FIXME:分类平分展示视图
+(BaseScrollView *)sharedSegmentWithFrame:(CGRect)frame Titles:(NSArray*)titles{
    BaseScrollView *segment = [[self alloc]initWithFrame:frame];
    [segment setSegmentWithTitles:titles];
    return segment;
}
-(void)setSegmentWithTitles:(NSArray*)titles{
    self.tag = MyScrollTypeSegment;
    self.titles = titles;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, 0, W(self)/titles.count, H(self));
        button.titleLabel.font = Font(16);
        button.tag = 10+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGBACOLOR(33, 34, 35, 1) forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = RGBACOLOR(224, 225, 226, 1);
        [self addSubview:button];
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(XW(button), Y(button), 1, H(button))];
        line1.backgroundColor = RGBACOLOR(210, 210, 210,1);
        [self addSubview:line1];
        starx = XW(line1);
        if (i == titles.count - 1) {
            line1.backgroundColor = [UIColor clearColor];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, H(button) - 1, W(button), 1)];
        line.tag = button.tag  + 20;
        [button addSubview:line];
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
            line.backgroundColor = [UIColor redColor];
        }
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
}
//FIXME:标题滑动，自适应文字宽度
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles{
    BaseScrollView *titleScroll = [[self alloc]initWithFrame:frame];
    [titleScroll setTitleScrollWithTitles:titles];
    return titleScroll;
}
-(void)setTitleScrollWithTitles:(NSArray*)titles{
    self.titles = titles;
    self.tag = MyScrollTypeTitleScroll;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary  *mdic=[NSMutableDictionary dictionary];
        [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        [mdic setObject:Font(16) forKey:NSFontAttributeName];
       CGSize size = [titles[i] boundingRectWithSize:CGSizeMake(APPW, H(self)) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:mdic context:nil].size;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, 0, size.width+30, H(self));
        button.titleLabel.font = Font(16);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGBACOLOR(33, 34, 35, 1) forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor grayColor];
        [self addSubview:button];
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(XW(button), Y(button), 1, H(button))];
        line1.backgroundColor = RGBACOLOR(210, 210, 210,1);
        [self addSubview:line1];
        starx = XW(line1);
        if (i == self.titles.count - 1) {
            line1.backgroundColor = [UIColor clearColor];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, H(button) - 1, W(button), 1)];
        line.tag = button.tag  + 20;
        [button addSubview:line];
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
            line.backgroundColor = [UIColor redColor];
        }
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
}
//FIXME:标题滑动，有文字和图标的
+(BaseScrollView *)sharedTitleIconScrollWithFrame:(CGRect)frame Titles:(NSArray *)titles icons:(NSArray *)icons{
    BaseScrollView *titleScroll = [[self alloc]initWithFrame:frame];
    [titleScroll setTitleIconScrollWithTitles:titles icons:icons];
    return titleScroll;
}
-(void)setTitleIconScrollWithTitles:(NSArray*)titles icons:(NSArray*)icons{
    self.titles = titles;self.icons = icons;
    self.tag = MyScrollTypeTitleIconScroll;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(starx, 0, W(self)/titles.count, H(self))];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        button.titleLabel.font = Font(16);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGBACOLOR(33, 34, 35, 1) forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGFloat heightSpace = 10.f;
        [button setImageEdgeInsets:UIEdgeInsetsMake(1, 10, 30, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30, -W(button), 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(heightSpace,0.0,H(button)-H(button.imageView) - heightSpace, - W(button.titleLabel))];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(H(button.imageView)+heightSpace, -W(button.imageView), 0.0, 0.0)];
        [self addSubview:button];
        starx += W(button);
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
        }
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
}
//FIXME:内容小项目滑动，一般在主页
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round{
    BaseScrollView *baseItem = [[self alloc]initWithFrame:frame];
    [baseItem setBaseItemWithIcons:icons titles:titles size:size round:round];
    return baseItem;
}
-(void)setBaseItemWithIcons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round{
    self.titles = titles;self.icons = icons;_size = size;_round = round;
    self.tag = MyScrollTypeBaseItem;
    CGFloat starx = 0;
    CGFloat stary = 0;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, stary, size.width, size.height);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        starx = XW(button);
        if (starx>W(self)) {//一行放不下的时候换行
            starx = 0;
            stary = YH(button);
            button.frame = CGRectMake(starx, stary, size.width, size.height);
            starx = XW(button);
        }
        [self addSubview:button];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width-20,size.height-30)];
        imageview.center = CGPointMake(button.frame.size.width/2, button.frame.size.height/2-15);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        if(round){
            imageview.layer.cornerRadius = imageview.frame.size.width/2;
        }
        imageview.clipsToBounds = YES;
        imageview.image =[UIImage imageNamed:icons[i]];
        [button addSubview:imageview];
        
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(imageview)+8, W(button), 20)];
        namelable.font = Font(13);
        namelable.textColor = RGBACOLOR(33, 34, 35, 1);
        namelable.text = titles[i];
        namelable.textAlignment = NSTextAlignmentCenter;
        [button addSubview:namelable];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,stary+size.height);
    NSLog(@"最终的frameY是：%lf",YH(self));
}
//FIXME:内容小项目滑动，一般在主页并且有分页的
+(BaseScrollView *)sharedScrollItemWithFrame:(CGRect)frame icons:(NSArray *)icons titles:(NSArray *)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round{
    BaseScrollView *baseItem = [[self alloc]initWithFrame:frame];
    [baseItem setBaseItemWithIcons:icons titles:titles size:size hang:hang round:round];
    return baseItem;
}
-(void)setBaseItemWithIcons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round{
    self.titles = titles;self.icons = icons;_size = size;_round = round;
    self.tag = MyScrollTypeScrollItem;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    NSInteger lie = W(self)/size.width;
    NSInteger qnum = (NSInteger)hang * lie;
    CGFloat starx = 0;
    CGFloat stary = 0;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, stary, size.width, size.height);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        starx = XW(button);
        if((i+1) % lie == 0) {//一行放不下的时候换行
            starx -= W(self);
            stary = YH(button);
        }
        if(stary/H(button)>=hang){//行数够了，翻页显示
            starx = W(self) * (i+1)/qnum;
            stary = 0;
        }
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.height-30,size.height-30)];
        imageview.center = CGPointMake(button.frame.size.width/2, button.frame.size.height/2-10);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        if(round){
            imageview.layer.cornerRadius = imageview.frame.size.width/2;
        }
        imageview.clipsToBounds = YES;
        imageview.image =[UIImage imageNamed:icons[i]];
        [button addSubview:imageview];
        
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(imageview)+5, W(button), 20)];
        namelable.font = Font(13);
        namelable.textColor = RGBACOLOR(33, 34, 35, 1);
        namelable.text = titles[i];
        namelable.textAlignment = NSTextAlignmentCenter;
        [button addSubview:namelable];
        [self addSubview:button];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,size.height * hang);
    self.contentSize = CGSizeMake(W(self)*(titles.count/qnum + (titles.count%qnum?1:0)), self.frame.size.height);
    NSLog(@"最终的frameY是：%lf",H(self));
}
//FIXME:内容视图滑动，如新闻类
+(BaseScrollView *)sharedContentViewWithFrame:(CGRect)frame controllers:(NSArray*)controllers inViewController:(UIViewController *)NVC{
    BaseScrollView *contentView = [[self alloc]initWithFrame:frame];
    [contentView setContentViewWithControllers:controllers inViewController:NVC];
    contentView.pushDelegateVC = NVC;
    return contentView;
}
-(void)setContentViewWithControllers:(NSArray*)controllers inViewController:(UIViewController*)NVC{
    self.delegate = self;count = controllers.count;
    self.contentSize = CGSizeMake(APPW * count, 0);
    self.tag = MyScrollTypeContentView;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    for (int i = 0; i<count; i++) {
        UIViewController *vc = [[NSClassFromString(controllers[i]) alloc]init];
        [NVC addChildViewController:vc];
    }
    UIViewController *vc = NVC.childViewControllers[0];
    vc.view.frame = CGRectMake(0, 0, APPW, H(self));
    [self addSubview:vc.view];
//    for(int i=0;i<count;i++){
//        UIViewController * vc = self.controllers[i];
//        if (vc.view.superview) {return;}
//        vc.view.frame = CGRectMake(i*APPW, 0, APPW, H(self));
//        [self addSubview:vc.view];
//    }
}
//FIXME:内容视图滑动，如新闻类，同时自带标题的滑动
+(BaseScrollView *)sharedContentTitleViewWithFrame:(CGRect)frame titles:(NSArray *)titles controllers:(NSArray *)controllers inViewController:(UIViewController *)NVC{
    BaseScrollView *contentView = [[self alloc]initWithFrame:frame];
    contentView.tag = MyScrollTypeContentTitleView;
    contentView.titleScrollView = [BaseScrollView sharedSegmentWithFrame:CGRectMake(frame.origin.x, frame.origin.y, W(contentView), 40) Titles:titles];
    contentView.contentScrollView = [BaseScrollView sharedContentViewWithFrame:CGRectMake(X(contentView),YH(contentView.titleScrollView), W(contentView), H(contentView)-H(contentView.titleScrollView)) controllers:controllers inViewController:NVC];
    contentView.pushDelegateVC = NVC;
    __weak __typeof(BaseScrollView*)weakSelf = contentView;
    contentView.titleScrollView.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        weakSelf.selectBlock(index,dict);
//        CGFloat offset = weakSelf.titleScrollView.contentOffset.x;
//        //定义一个两个变量控制左右按钮的渐变
//        NSInteger left = offset/APPW;
//        NSInteger right = 1 + left;
//        UIButton * leftButton = (UIButton *)[weakSelf.titleScrollView viewWithTag:10 + left];
//        UIButton * rightButton = nil;
//        if (right < weakSelf.titleScrollView.titles.count) {rightButton = (UIButton *)[weakSelf.titleScrollView viewWithTag:10 +right];}
//        //切换左右按钮
//        CGFloat scaleR = offset/APPW - left;
//        CGFloat scaleL = 1 - scaleR;
//        CGFloat tranScale = 1.2 - 1 ;//左右按钮的缩放比例
//        //宽和高的缩放(渐变)
//        leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
//        rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
//        //颜色的渐变
//        UIColor * rightColor = [UIColor colorWithRed:scaleR green:250 blue:250 alpha:1];
//        UIColor * leftColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1];
//        [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
//        [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
        UIViewController * vc = NVC.childViewControllers[index];
        if (vc.view.superview) {weakSelf.contentScrollView.contentOffset = CGPointMake(APPW * index, 0);return;}
        vc.view.frame = CGRectMake(APPW * index , 0, APPW, H(contentView) - YH(contentView.titleScrollView));
        [weakSelf.contentScrollView addSubview:vc.view];
        weakSelf.contentScrollView.contentOffset = CGPointMake(APPW * index, 0);
    };
    contentView.contentScrollView.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        weakSelf.selectBlock(index,dict);
        for (int i = 0; i < weakSelf.titleScrollView.titles.count; i++) {
            UIButton *button = (UIButton *)[weakSelf.titleScrollView viewWithTag:10 + i];
            [button setTitleColor:RGBACOLOR(33, 34, 35, 1) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor lightGrayColor];
            button.transform = CGAffineTransformMakeScale(1, 1);
            UIView *line = (UIView *)[weakSelf.titleScrollView viewWithTag:button.tag + 20];
            line.backgroundColor = [UIColor clearColor];
        }
        
        UIButton *button = (UIButton *)[weakSelf.titleScrollView viewWithTag:10 + index];
        button.transform = CGAffineTransformIdentity;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];//文字变红
        button.backgroundColor = [UIColor whiteColor];
//        button.transform = CGAffineTransformMakeScale(1.5, 1.5);//放大的效果,放大1.5倍
    };
    [NVC.view addSubview:contentView.titleScrollView];[NVC.view addSubview:contentView.contentScrollView];
    return contentView;
}
//FIXME:内容视图滑动，如新闻类，同时自带拥有图标的标题的滑动
+(BaseScrollView *)sharedContentIconViewWithFrame:(CGRect)frame titles:(NSArray *)titles icons:(NSArray *)icons controllers:(NSArray *)controllers inViewController:(UIViewController *)NVC{
    BaseScrollView *contentView = [[self alloc]initWithFrame:frame];
    contentView.tag = MyScrollTypeContentIconView;
    contentView.titleScrollView = [BaseScrollView sharedTitleIconScrollWithFrame:CGRectMake(frame.origin.x, frame.origin.y, W(contentView), 60)  Titles:titles icons:icons];
    contentView.contentScrollView = [BaseScrollView sharedContentViewWithFrame:CGRectMake(X(contentView),YH(contentView.titleScrollView), W(contentView), H(contentView)-H(contentView.titleScrollView)) controllers:controllers inViewController:NVC];
    contentView.pushDelegateVC = NVC;
    __weak __typeof(BaseScrollView*)weakSelf = contentView;
    contentView.titleScrollView.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        weakSelf.selectBlock(index,dict);
        UIViewController * vc = NVC.childViewControllers[index];
        if (vc.view.superview) {weakSelf.contentScrollView.contentOffset = CGPointMake(APPW * index, 0);return;}
        vc.view.frame = CGRectMake(APPW * index , 0, APPW, H(contentView) - YH(contentView.titleScrollView));
        [weakSelf.contentScrollView addSubview:vc.view];
        weakSelf.contentScrollView.contentOffset = CGPointMake(APPW * index, 0);
    };
    contentView.contentScrollView.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        weakSelf.selectBlock(index,dict);
        for (int i = 0; i < weakSelf.titleScrollView.titles.count; i++) {
            UIButton *button = (UIButton *)[weakSelf.titleScrollView viewWithTag:10 + i];
            button.backgroundColor = [UIColor lightGrayColor];
        }
        UIButton *button = (UIButton *)[weakSelf.titleScrollView viewWithTag:10 + index];
        button.backgroundColor = [UIColor whiteColor];
    };
    [NVC.view addSubview:contentView.titleScrollView];[NVC.view addSubview:contentView.contentScrollView];
    return contentView;
}
//FIXME:横着的滚动视图一般见推荐或广告
+(BaseScrollView *)sharedBannerWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *banner = [[self alloc]initWithFrame:frame];
    [banner setBannerWithicons:icons];
    return banner;
}
-(void)setBannerWithicons:(NSArray*)icons{            //仅支持网址访问图片//pagecontroll在右下角
    self.tag = MyScrollTypeBanner;
    self.scrollType = MyScrollTypeBanner;
    self.delegate = self;
    self.contentOffset = CGPointMake(W(self), 0);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    pagecontroller = [[UIPageControl alloc]initWithFrame:CGRectMake(W(self)-110, H(self) - 20,100, 20)];
    pagecontroller.backgroundColor = [UIColor clearColor];
    pagecontroller.currentPageIndicatorTintColor = [UIColor redColor];
    pagecontroller.pageIndicatorTintColor = [UIColor lightGrayColor];
    pagecontroller.currentPage = index;
    [self addSubview:pagecontroller];
    count = icons.count + 2;
    pagecontroller.numberOfPages = icons.count;
    self.contentSize = CGSizeMake(W(self) * (icons.count + 2), 0);
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self),H(self))];
    [imageview sd_setImageWithURL:[NSURL URLWithString:icons.lastObject]];
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.clipsToBounds = YES;
    [self addSubview:imageview];
    for (int i = 0; i < icons.count; i++) {
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(W(self) + i*W(self), 0, W(self), H(self))];
        [imgv sd_setImageWithURL:[NSURL URLWithString:icons[i]]];
        imgv.contentMode = UIViewContentModeScaleToFill;
        imgv.clipsToBounds = YES;
        imgv.userInteractionEnabled = YES;
        imgv.tag = i;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            if(self.selectBlock){
                _selectBlock(imgv.tag,nil);
            }
        }];
        [imgv addGestureRecognizer:gesture];
        [self addSubview:imgv];
    }
    UIImageView *lastimage = [[UIImageView alloc]initWithFrame:CGRectMake(W(self)*(icons.count + 1), 0, W(self), H(self))];
    [lastimage sd_setImageWithURL:[NSURL URLWithString:[icons firstObject]]];
    lastimage.contentMode = UIViewContentModeScaleToFill;
    lastimage.clipsToBounds = YES;
    [self addSubview:lastimage];
    _time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(bannerTimeAction) userInfo:nil repeats:YES];
    [_time setFireDate:[NSDate date]];
}
//FIXME:竖着动态播放的视图或广告
+(BaseScrollView *)sharedVerticallyBannerWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *banner = [[self alloc]initWithFrame:frame];
    [banner setBannerWithicons:icons];
    return banner;
}
-(void)setVerticallyBannerWithicons:(NSArray*)icons{
    self.tag = MyScrollTypeVerticallyBanner;
    self.delegate = self;
    self.contentOffset = CGPointMake(0,H(self));
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    count = icons.count + 2;
    self.contentSize = CGSizeMake(0,H(self) * (icons.count + 2));
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self), H(self))];
    [imageview sd_setImageWithURL:[NSURL URLWithString:icons.lastObject]];
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.clipsToBounds = YES;
    [self addSubview:imageview];
    for (int i = 0; i < icons.count; i++) {
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0,H(self) + i*H(self), W(self), H(self))];
        [imgv sd_setImageWithURL:[NSURL URLWithString:icons[i]]];
        imgv.contentMode = UIViewContentModeScaleToFill;
        imgv.clipsToBounds = YES;
        imgv.userInteractionEnabled = YES;
        imgv.tag = i;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            if(self.selectBlock){
                _selectBlock(imgv.tag,nil);
            }
        }];
        [imgv addGestureRecognizer:gesture];
        [self addSubview:imgv];
    }
    UIImageView *lastimage = [[UIImageView alloc]initWithFrame:CGRectMake(0,H(self)*(icons.count + 1), W(self), H(self))];
    [lastimage sd_setImageWithURL:[NSURL URLWithString:icons.firstObject]];
    lastimage.contentMode = UIViewContentModeScaleToFill;
    lastimage.clipsToBounds = YES;
    [self addSubview:lastimage];
    _time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(bannerTimeAction) userInfo:nil repeats:YES];
    [_time setFireDate:[NSDate date]];
    
}
//FIXME:欢迎界面
+(BaseScrollView *)sharedWelcomWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *welcom = [[self alloc]initWithFrame:frame];
    [welcom setWelcomWithIcons:icons];
    return welcom;
}
-(void)setWelcomWithIcons:(NSArray*)icons{
    self.icons = icons;self.tag = MyScrollTypeWelcom;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    for (int i=0; i<icons.count; i++) {
        UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(i * self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        imageV.image = [UIImage imageNamed:icons[i]];
        imageV.contentMode=UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds=YES;
        [self addSubview:imageV];
        if (i==icons.count-1) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
            [imageV setUserInteractionEnabled:YES];
            [imageV addGestureRecognizer:tap];
        }
    }
    [self setContentSize:CGSizeMake(W(self)*icons.count, H(self))];
}

#pragma mark 另加的
//FIXME:分类展示的标题栏
+(BaseScrollView *)sharedViewSegmentWithFrame:(CGRect)frame viewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block{
    BaseScrollView *contentView = [[BaseScrollView alloc]initWithFrame:frame];
    contentView.viewBlock = block;
    [contentView setSegmentViewWithViewsNumber:num viewOfIndex:block];
    return contentView;
}
-(void)setSegmentViewWithViewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block{
    self.tag = MyScrollTypeSegment;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < num; i++) {
        UIView *view = block(i);
        view.frame = CGRectMake(starx, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        starx += view.frame.size.width;
        __weak __typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            if(weakSelf.selectBlock){
                weakSelf.selectBlock(i,nil);
            }
        }];
        [view addGestureRecognizer:tap];
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
}
//FIXME:内容小项目视图
+(BaseScrollView *)sharedViewItemWithFrame:(CGRect)frame viewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block{
    BaseScrollView *contentView = [[BaseScrollView alloc]initWithFrame:frame];
    contentView.viewBlock = block;
    [contentView setItemViewWithViewsNumber:num viewOfIndex:block];
    return contentView;
}
-(void)setItemViewWithViewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block{
    self.tag = MyScrollTypeBaseItem;
    CGFloat starx = 0;
    CGFloat stary = 0;
    for (int i = 0; i < num; i++) {
        UIView *view = block(i);
        view.frame = CGRectMake(starx, stary, view.frame.size.width, view.frame.size.height);
        starx =XW(view);
        if(starx>W(self)){//一行放不下的时候
            starx = 0;
            stary = YH(view);
            view.frame = CGRectMake(starx, stary, view.frame.size.width, view.frame.size.height);
            starx = XW(view);
        }
        [self addSubview:view];
        __weak __typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            if(weakSelf.selectBlock){
                weakSelf.selectBlock(i,nil);
            }
        }];
        [view addGestureRecognizer:tap];
        if(i==num-1){
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height>YH(view)?self.frame.size.height:YH(view));
        }
    }
}
//FIXME:视图banner兼容内容视图
+(BaseScrollView *)sharedViewBannerWithFrame:(CGRect)frame viewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block Vertically:(BOOL)vertical setFire:(BOOL)fire{
    BaseScrollView *contentView = [[BaseScrollView alloc]initWithFrame:frame];
    contentView.viewBlock = block;
    [contentView setBannerViewWithViewsNumer:num viewOfIndex:block Vertically:vertical setFire:fire];
    return contentView;
}
-(void)setBannerViewWithViewsNumer:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block Vertically:(BOOL)vertical setFire:(BOOL)fire{
    self.pagingEnabled = YES;count = num+2;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    for(int i=0;i<num+2;i++){
        UIView *view;
        if(i==0){
            view = block(num-1);
        }else if(i==num+1){
            view = block(0);
        }else{
            view = block(i-1);
        }
        [self.contentViews addObject:view];
    }
    float starx=0;
    float stary=0;
    UIView *view1 = self.contentViews[num-1];
    [self addSubview:view1];
    for (int i = 0; i < num+2; i++) {
        UIView *view = self.contentViews[i];
        view.frame = CGRectMake(starx, stary, W(view), H(view));
        if(vertical){
            stary += view.frame.size.height;
        }else{
            starx += view.frame.size.width;
        }
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            if(self.selectBlock){_selectBlock(i,nil);}
        }];
        [view addGestureRecognizer:gesture];
        [self addSubview:view];
    }
    if(vertical){
        self.tag = MyScrollTypeVerticallyBanner;
        self.contentSize = CGSizeMake(W(self), H(self)*(num+2));
        self.contentOffset = CGPointMake(0, H(self));
    }else{
        self.tag = MyScrollTypeBanner;
        self.contentSize = CGSizeMake(W(self) * (num + 2), 0);
        self.contentOffset = CGPointMake(W(self), 0);
    }
    self.delegate = self;
    if(fire){
        _time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(bannerTimeAction) userInfo:nil repeats:YES];
        [_time setFireDate:[NSDate date]];
    }
}
//FIXME:集合配置
+(BaseScrollView *)sharedWithFrame:(CGRect)frame Titles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block{
    BaseScrollView *ref = [[self alloc]initWithFrame:frame];
    [ref setWithTitles:titles icons:icons round:round size:size type:type controllers:controllers selectIndex:block];
    return ref;
}
-(void)setWithTitles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block{
    self.titles = titles;
    self.icons = icons;
    self.selectBlock = block;
    switch (type) {
        case MyScrollTypeSegment:{
            [self setSegmentWithTitles:titles];
        }break;
        case MyScrollTypeTitleScroll:{
            [self setTitleScrollWithTitles:titles];
        }break;
        case MyScrollTypeTitleIconScroll:{
            [self setTitleIconScrollWithTitles:titles icons:icons];
        }break;
        case MyScrollTypeBaseItem:{
            [self setBaseItemWithIcons:icons titles:titles size:size round:round];
        }break;
        case MyScrollTypeScrollItem:{
            [self setBaseItemWithIcons:icons titles:titles size:size hang:2 round:round];
        }break;
        case MyScrollTypeContentView:{
//            [self setContentViewWithControllers:controllers];
#warning TOTO
        }break;
        case MyScrollTypeContentTitleView:{
            NSLog(@"暂不支持");
        }break;
        case MyScrollTypeContentIconView:{
            NSLog(@"暂不支持");
        }break;
        case MyScrollTypeBanner:{
            [self setBannerWithicons:icons];
        }break;
        case MyScrollTypeVerticallyBanner:{
            [self setVerticallyBannerWithicons:icons];
        }break;
        case MyScrollTypeWelcom:{
            [self setWelcomWithIcons:icons];
        }break;
        default:{
            //不用做什么
        }break;
    }
}
//FIXME: Actions===========================================
-(void)selectThePage:(NSInteger)page{
    switch (self.tag) {
        case MyScrollTypeSegment:{
            UIButton *button = (UIButton *)[self viewWithTag:page+10];
            [self buttonAction:button];
        }break;
        case MyScrollTypeTitleScroll:{
            UIButton *button = (UIButton *)[self viewWithTag:page+10];
            [self buttonAction:button];
        }break;
        case MyScrollTypeTitleIconScroll:{
            UIButton *button = (UIButton *)[self viewWithTag:page+10];
            [self buttonAction:button];
        }break;
        case MyScrollTypeBaseItem:{
            UIButton *button = (UIButton *)[self viewWithTag:page+10];
            [self buttonAction:button];
        }break;
        case MyScrollTypeScrollItem:{
            UIButton *button = (UIButton *)[self viewWithTag:page+10];
            [self buttonAction:button];
        }break;
        case MyScrollTypeContentView:{
            [self setContentOffset:CGPointMake(APPW * page, 0) animated:NO];
        }break;
        case MyScrollTypeContentTitleView:{
            self.titleScrollView.selectBlock(page,nil);
        }break;
        case MyScrollTypeContentIconView:{
            for (int i = 0; i < self.titleScrollView.titles.count; i++) {
                UIButton *button = (UIButton *)[self.titleScrollView viewWithTag:10 + i];
                button.backgroundColor = [UIColor lightGrayColor];
                if(i==page){
                    button.backgroundColor = [UIColor whiteColor];
                }
            }
            self.titleScrollView.selectBlock(page,nil);
        }break;
        case MyScrollTypeBanner:{
            pagecontroller.currentPage = index;
            self.contentOffset = CGPointMake(W(self) * page, 0);
        }break;
        case MyScrollTypeVerticallyBanner:{
            self.contentOffset = CGPointMake(0, H(self) * page);
        }break;
        case MyScrollTypeWelcom:{
            self.contentOffset = CGPointMake(W(self) * page, 0);
        }break;
        default:{
            //不用做什么
        }break;
    }
   
}
-(void)buttonAction:(UIButton *)btn{
    if(self.selectBlock){
        self.selectBlock(btn.tag-10,nil);
    }
    switch (self.tag) {
        case MyScrollTypeSegment:{
            for (int i = 0; i < self.titles.count; i++) {
                UIButton *button = (UIButton *)[self viewWithTag:10 + i];
                button.backgroundColor = [UIColor lightGrayColor];
                UIView *line = (UIView *)[self viewWithTag:button.tag + 20];
                line.backgroundColor = [UIColor clearColor];
            }
            btn.backgroundColor = [UIColor whiteColor];
            UIView *line = (UIView *)[self viewWithTag:btn.tag + 20];
            line.backgroundColor = [UIColor redColor];
        }break;
        case MyScrollTypeTitleScroll:{
            CGFloat centx =btn.frame.origin.x-APPW/2+btn.frame.size.width/2;
            if(self.contentSize.width< btn.frame.origin.x+(APPW+btn.frame.size.width)/2){
                centx = self.contentSize.width-APPW+29;
            }else if(centx<0){
                centx = 0;
            }
            [self setContentOffset:CGPointMake(centx, 0) animated:YES];
        }break;
        case MyScrollTypeTitleIconScroll:{
            for (int i = 0; i < self.titles.count; i++) {
                UIButton *button = (UIButton *)[self viewWithTag:10 + i];
                button.backgroundColor = [UIColor lightGrayColor];
            }
            btn.backgroundColor = [UIColor whiteColor];
        }break;
        case MyScrollTypeBaseItem:{
            //不用做什么
        }break;
        case MyScrollTypeScrollItem:{
            //不用做什么
        }break;
        case MyScrollTypeContentView:{
            CGFloat centx =btn.frame.origin.x-APPW/2+btn.frame.size.width/2;
            if(self.contentSize.width< btn.frame.origin.x+(APPW+btn.frame.size.width)/2){
                centx = self.contentSize.width-APPW+29;
            }else if(centx<0){
                centx = 0;
            }
            [self setContentOffset:CGPointMake(centx, 0) animated:YES];
        }break;
        case MyScrollTypeContentTitleView:{
             //不用做什么
        }break;
        case MyScrollTypeContentIconView:{
             //不用做什么
//            CGFloat centx =btn.frameX-APPW/2+btn.frameWidth/2;
//            if(self.contentSize.width< btn.frameX+(APPW+btn.frameWidth)/2){
//                centx = self.contentSize.width-APPW+29;
//            }else if(centx<0){
//                centx = 0;
//            }
//            [self setContentOffset:CGPointMake(centx, 0) animated:YES];
        }break;
        case MyScrollTypeBanner:{
             //不用做什么
        }break;
        case MyScrollTypeVerticallyBanner:{
             //不用做什么
        }break;
        case MyScrollTypeWelcom:{
             //不用做什么
        }break;
        default:{
            
        }break;
    }
    

}
#pragma mark Others
-(void)bannerTimeAction{
    pagecontroller.currentPage = index++;
    if(self.tag==MyScrollTypeBanner){
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(W(self)*index, 0);
        } completion:^(BOOL finished) {
            if (self.contentOffset.x > W(self)*(count - 2)) {
                self.contentOffset = CGPointMake(W(self), 0);
                index = 0;
            }
            if (self.contentOffset.x < W(self)) {
//                [self scrollRectToVisible:CGRectMake(W(self)*(count-2), 0, 1, 1) animated:YES];
                self.contentOffset = CGPointMake(W(self)*(count - 2), 0);
                index = count - 2;
            }
        }];
    }else if(self.tag==MyScrollTypeVerticallyBanner){
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0,H(self)*index);
        } completion:^(BOOL finished) {
            if (self.contentOffset.y > H(self)*(count - 2)) {
                self.contentOffset = CGPointMake(0,H(self));
                index = 0;
            }
            if (self.contentOffset.y < H(self)) {
                self.contentOffset = CGPointMake(0,H(self)*(count - 2));
                index = count - 2;
            }
        }];
    }
    
}


//FIXME: scrollviewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    switch (self.tag) {
        case MyScrollTypeSegment:{
            //不用做什么
        }break;
        case MyScrollTypeTitleScroll:{
            //不用做什么
        }break;
        case MyScrollTypeTitleIconScroll:{
            //不用做什么
        }break;
        case MyScrollTypeBaseItem:{
            //不用做什么
        }break;
        case MyScrollTypeScrollItem:{
            //不用做什么
        }break;
        case MyScrollTypeContentView:{
            
        }break;
        case MyScrollTypeContentTitleView:{
            
        }break;
        case MyScrollTypeContentIconView:{
            
        }break;
        case MyScrollTypeBanner:{
          //不用做什么
        }break;
        case MyScrollTypeVerticallyBanner:{
             //不用做什么
        }break;
        case MyScrollTypeWelcom:{
             //不用做什么
        }break;
        default:{
             //不用做什么
        }break;
    }
//    [_time setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

/// 实现字体颜色大小的渐变
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    switch (self.tag) {
        case MyScrollTypeSegment:{
            //不用做什么
        }break;
        case MyScrollTypeTitleScroll:{
            //不用做什么
        }break;
        case MyScrollTypeTitleIconScroll:{
            //不用做什么
        }break;
        case MyScrollTypeBaseItem:{
            //不用做什么
        }break;
        case MyScrollTypeScrollItem:{
            //不用做什么
        }break;
        case MyScrollTypeContentView:{
        
        }break;
        case MyScrollTypeContentTitleView:{
#warning 这里是内容视图滚动过程中对标题栏的简便控制没有完成。
            CGFloat offset = scrollView.contentOffset.x;
            //定义一个两个变量控制左右按钮的渐变
            NSInteger left = offset/APPW;
            NSInteger right = 1 + left;
            UIButton * leftButton = (UIButton*)[self viewWithTag:left+10];
            UIButton * rightButton = nil;
            if (right < self.titles.count) {
                rightButton = (UIButton*)[self viewWithTag:10+right];
            }
            //切换左右按钮
            CGFloat scaleR = offset/APPW - left;
            CGFloat scaleL = 1 - scaleR;
            //左右按钮的缩放比例
            CGFloat tranScale = 1.2 - 1 ;
            //宽和高的缩放(渐变)
            leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
            rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
            //颜色的渐变
            UIColor * rightColor = [UIColor colorWithRed:scaleR green:250 blue:250 alpha:1];
            UIColor * leftColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1];
            //重新设置颜色
            [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
            [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
        }break;
        case MyScrollTypeContentIconView:{
            CGFloat offset = scrollView.contentOffset.x;
            //定义一个两个变量控制左右按钮的渐变
            NSInteger left = offset/APPW;
            NSInteger right = 1 + left;
            UIButton * leftButton = (UIButton*)[self viewWithTag:left+10];
            UIButton * rightButton = nil;
            if (right < self.titles.count) {
                rightButton = (UIButton*)[self viewWithTag:10+right];
            }
            //切换左右按钮
            CGFloat scaleR = offset/APPW - left;
            CGFloat scaleL = 1 - scaleR;
            //左右按钮的缩放比例
            CGFloat tranScale = 1.2 - 1 ;
            //宽和高的缩放(渐变)
            leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
            rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
            //颜色的渐变
            UIColor * rightColor = [UIColor colorWithRed:scaleR green:250 blue:250 alpha:1];
            UIColor * leftColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1];
            //重新设置颜色
            [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
            [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
        }break;
        case MyScrollTypeBanner:{
             //不用做什么
        }break;
        case MyScrollTypeVerticallyBanner:{
             //不用做什么
        }break;
        case MyScrollTypeWelcom:{
             //不用做什么
        }break;
        default:{
             //不用做什么
        }break;
    }
}
/// 滑动结束的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    switch (self.tag) {
        case MyScrollTypeSegment:{
            //不用做什么
        }break;
        case MyScrollTypeTitleScroll:{
            //不用做什么
        }break;
        case MyScrollTypeTitleIconScroll:{
            //不用做什么
        }break;
        case MyScrollTypeBaseItem:{
            //不用做什么
        }break;
        case MyScrollTypeScrollItem:{
            //不用做什么
        }break;
        case MyScrollTypeContentView:{
            NSUInteger i = self.contentOffset.x / APPW;
            CGFloat x = i * APPW;
            if(self.selectBlock){
                _selectBlock(i,nil);
            }
            UIViewController * vc = self.pushDelegateVC.childViewControllers[i];
            if (vc.view.superview) {return;}
            vc.view.frame = CGRectMake(x, 0, APPW,H(self));
            [self addSubview:vc.view];
        }break;
        case MyScrollTypeContentTitleView:{
            NSUInteger i = self.contentOffset.x / APPW;
            CGFloat x = i * APPW;
            if(self.selectBlock){
                _selectBlock(i,nil);
            }
            UIViewController * vc = self.pushDelegateVC.childViewControllers[i];
            if (vc.view.superview) {return;}
            vc.view.frame = CGRectMake(x, 0, APPW,H(self));
            [self addSubview:vc.view];
        }break;
        case MyScrollTypeContentIconView:{
            NSUInteger i = self.contentOffset.x / APPW;
            CGFloat x = i * APPW;
            if(self.selectBlock){
                _selectBlock(i,nil);
            }
            UIViewController * vc = self.pushDelegateVC.childViewControllers[i];
            if (vc.view.superview) {return;}
            vc.view.frame = CGRectMake(x, 0, APPW,H(self));
            [self addSubview:vc.view];
        }break;
        case MyScrollTypeBanner:{
            if (self.contentOffset.x > W(self)*(count - 2)) {
                self.contentOffset = CGPointMake(W(self), 0);
            }
            if (self.contentOffset.x < W(self)) {
                self.contentOffset = CGPointMake(W(self)*(count - 2), 0);
            }
            index = self.contentOffset.x/W(self);
            if (index > count - 2) {
                index = 0;
            }
            if (index < 0) {
                index = count-2;
            }
            pagecontroller.currentPage = index;
        }break;
        case MyScrollTypeVerticallyBanner:{
            if (self.contentOffset.y > H(self)*(count - 2)) {
                self.contentOffset = CGPointMake(0,H(self));
            }
            if (self.contentOffset.y < H(self)) {
                self.contentOffset = CGPointMake(0,H(self)*(count - 2));
            }
            index = self.contentOffset.y/H(self);
            if (index > count - 2) {
                index = 0;
            }
            if (index < 0) {
                index = count-2;
            }
            pagecontroller.currentPage = index;
        }break;
        case MyScrollTypeWelcom:{
             //不用做什么
        }break;
        default:{
            
        }break;
    }
    
}
#pragma mark welcome的方法
- (void)show{
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    self.hidden = NO;
    self.alpha = 1.0f;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (void)hidden{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self addYindaoWithPictrues:@[@"首页引导"]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前语言是系统默认版本\n如需修改请到个人中心选择语言修改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
}
-(void)addYindaoWithPictrues:(NSArray*)pics{
    for(int i=0;i<pics.count;i++){
        UIImageView *yindao = [[UIImageView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        yindao.image = [UIImage imageNamed:pics[i]];
        [[UIApplication sharedApplication].keyWindow addSubview:yindao];
        yindao.userInteractionEnabled = YES;
        [yindao addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            [yindao removeFromSuperview];
        }]];
    }
    
}
@end
















