//
//  BaseScrollView.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/13.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseScrollView.h"
#import "UIImageView+AFNetworking.h"

@interface BaseScrollView(){
    NSInteger count;
    NSInteger index;
    UIPageControl *pagecontroller;
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
#pragma mark 分类平分展示视图
+(BaseScrollView *)sharedSegmentWithFrame:(CGRect)frame Titles:(NSArray*)titles{
    BaseScrollView *segment = [[self alloc]initWithFrame:frame];
    [segment setSegmentWithTitles:titles];
    return segment;
}
-(void)setSegmentWithTitles:(NSArray*)titles{
    self.tag = MyScrollSegmentType;
    self.titles = titles;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, 0, self.frame.size.width/titles.count, self.frame.size.height);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 10+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithRed:33 green:34 blue:35 alpha:1] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:button];
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width, button.frame.origin.y, 1, button.frame.size.height)];
        line1.backgroundColor = [UIColor colorWithRed:210 green:210 blue:210 alpha:1];
        [self addSubview:line1];
        starx = line1.frame.origin.x+line1.frame.size.width;
        if (i == titles.count - 1) {
            line1.backgroundColor = [UIColor clearColor];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height - 1, button.frame.size.width, 1)];
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
#pragma mark 标题滑动，自适应文字宽度
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles{
    BaseScrollView *titleScroll = [[self alloc]initWithFrame:frame];
    [titleScroll setTitleScrollWithTitles:titles];
    return titleScroll;
}
-(void)setTitleScrollWithTitles:(NSArray*)titles{
    self.titles = titles;
    self.tag = MyScrollTitleScrollType;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        CGSize maxSize = CGSizeMake([UIApplication sharedApplication].keyWindow.bounds.size.width, self.frame.size.height);
        CGSize size = [titles[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, 0, size.width+30, self.frame.size.height);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithRed:33 green:34 blue:35 alpha:1] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:button];
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width, button.frame.origin.y, 1,button.frame.size.height)];
        line1.backgroundColor = [UIColor colorWithRed:210 green:210 blue:210 alpha:1];
        [self addSubview:line1];
        starx = line1.frame.origin.x+line1.frame.size.width;
        if (i == self.titles.count - 1) {
            line1.backgroundColor = [UIColor clearColor];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height - 1, button.frame.size.width, 1)];
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
#pragma mark 标题滑动，有文字和图标的
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles icons:(NSArray*)icons{
    BaseScrollView *titleScroll = [[self alloc]initWithFrame:frame];
    [titleScroll setTitleScrollWithTitles:titles];
    return titleScroll;
}
-(void)setTitleScrollWithTitles:(NSArray*)titles icons:(NSArray*)icons{
    self.titles = titles;//item的长宽比为4/3
    self.icons = icons;
    self.tag = MyScrollTitleIconScrollType;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(starx, 0, self.frame.size.height*0.75, self.frame.size.height)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 30, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30, -10, 0, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithRed:33 green:34 blue:35 alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:button];
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
        }
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
    
}
#pragma mark 内容小项目滑动，一般在主页
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round{
    BaseScrollView *baseItem = [[self alloc]initWithFrame:frame];
    [baseItem setBaseItemWithIcons:icons titles:titles size:size round:round];
    return baseItem;
}
-(void)setBaseItemWithIcons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round{
    self.titles = titles;self.icons = icons;self.size = size;self.round = round;
    self.tag = MyScrollBaseItemType;
    CGFloat starx = 0;
    CGFloat stary = 0;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, stary, size.width, size.height);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        starx = button.frame.origin.x+button.frame.size.width;
        if (starx>self.frame.size.width-button.frame.size.width) {//一行放不下的时候换行
            starx = 0;
            stary = button.frame.size.height+button.frame.origin.y;
            button.frame = CGRectMake(starx, stary, size.width, size.height);
            starx = button.frame.origin.x+button.frame.size.width;
        }
        [self addSubview:button];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.height-30,size.height-30)];
        imageview.center = CGPointMake(button.frame.size.width/2, button.frame.origin.y/2-15);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        if(round){
            imageview.layer.cornerRadius = imageview.frame.size.width/2;
        }
        imageview.clipsToBounds = YES;
        imageview.image =[UIImage imageNamed:icons[i]];
        [button addSubview:imageview];
        
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.frame.origin.y+imageview.frame.size.height+8, button.frame.size.width, 20)];
        namelable.font = [UIFont systemFontOfSize:13];
        namelable.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
        namelable.text = titles[i];
        namelable.textAlignment = NSTextAlignmentCenter;
        [button addSubview:namelable];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, stary+size.height);
    NSLog(@"最终的frameY是：%lf",self.frame.origin.y+self.frame.size.height);
}
#pragma mark 内容小项目滑动，一般在主页并且有分页的
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round{
    BaseScrollView *baseItem = [[self alloc]initWithFrame:frame];
    [baseItem setBaseItemWithIcons:icons titles:titles size:size hang:hang round:round];
    return baseItem;
}
-(void)setBaseItemWithIcons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round{
    self.titles = titles;self.icons = icons;self.size = size;self.round = round;
    self.tag = MyScrollScrollItemType;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    NSInteger qnum = (NSInteger)hang * self.frame.size.width/size.width;
    self.contentSize = CGSizeMake(self.frame.size.width*(titles.count/qnum + 1), size.height*hang);
    CGFloat starx = 0;
    CGFloat stary = 0;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, stary, size.width, size.height);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        starx = button.frame.origin.x+button.frame.size.width;
        if(i % (int)self.frame.size.width/button.frame.size.width) {//一行放不下的时候换行
            starx -= self.frame.size.width;
            stary = button.frame.size.height+button.frame.origin.y;
            button.frame = CGRectMake(starx, stary, size.width, size.height);
            starx = button.frame.origin.x+button.frame.size.width;
        }
        if(stary/button.frame.size.height>=hang){//行数够了，翻页显示
            starx = self.frame.size.width * (i+1)/qnum;
            stary = 0;
            button.frame = CGRectMake(starx, stary, size.width, size.height);
            starx = button.frame.origin.x+button.frame.size.width;
        }
        [self addSubview:button];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.height-30,size.height-30)];
        imageview.center = CGPointMake(button.frame.size.width/2, button.frame.origin.y/2-15);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        if(round){
            imageview.layer.cornerRadius = imageview.frame.size.width/2;
        }
        imageview.clipsToBounds = YES;
        imageview.image =[UIImage imageNamed:icons[i]];
        [button addSubview:imageview];
        
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.frame.size.height+imageview.frame.origin.y+8, button.frame.size.width, 20)];
        namelable.font = [UIFont systemFontOfSize:13];
        namelable.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
        namelable.text = titles[i];
        namelable.textAlignment = NSTextAlignmentCenter;
        [button addSubview:namelable];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height * hang);
    NSLog(@"最终的frameY是：%lf",self.frame.size.height+self.frame.origin.y);
}
#pragma mark 内容视图滑动，如新闻类，同时自带标题的滑动
+(BaseScrollView *)sharedContentViewWithFrame:(CGRect)frame titles:(NSArray*)titles controllers:(NSArray*)controllers{
    BaseScrollView *contentView = [[self alloc]initWithFrame:frame];
    [contentView setContentViewWithTitles:titles controllers:controllers];
    return contentView;
}
-(void)setContentViewWithTitles:(NSArray*)titles controllers:(NSArray*)controllers{
    count = self.titles.count;self.titles = titles;self.controllers = controllers;
    self.tag = MyScrollContentViewType;
    self.contentSize = CGSizeMake(controllers.count * [UIApplication sharedApplication].keyWindow.bounds.size.width, 0);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    for (int i = 0; i<count; i++) {
        UIViewController *vc =[[NSClassFromString(_controllers[i]) alloc]initWithFrame: CGRectMake(i * [UIApplication sharedApplication].keyWindow.bounds.size.width, 0, [UIApplication sharedApplication].keyWindow.bounds.size.width, self.frame.size.height)];
        [self addSubview:vc.view];
    }
    
}
#pragma mark 横着的滚动视图一般见推荐或广告
+(BaseScrollView *)sharedBannerWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *banner = [[self alloc]initWithFrame:frame];
    [banner setBannerWithicons:icons];
    return banner;
}
-(void)setBannerWithicons:(NSArray*)icons{            //仅支持网址访问图片//pagecontroll在右下角
    self.tag = MyScrollBanner;
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    pagecontroller = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width-110, self.frame.size.height - 20,100, 20)];
    pagecontroller.backgroundColor = [UIColor clearColor];
    pagecontroller.currentPageIndicatorTintColor = [UIColor redColor];
    pagecontroller.pageIndicatorTintColor = [UIColor lightGrayColor];
    pagecontroller.currentPage = index;
    [self addSubview:pagecontroller];
    count = icons.count + 2;
    pagecontroller.numberOfPages = icons.count;
    self.contentSize = CGSizeMake(self.frame.size.width * (icons.count + 2), 0);
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [imageview setImageWithURL:[NSURL URLWithString:[icons lastObject]]];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [self addSubview:imageview];
    for (int i = 0; i < icons.count; i++) {
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width + i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [imgv setImageWithURL:[NSURL URLWithString:icons[i]]];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        [self addSubview:imgv];
    }
    UIImageView *lastimage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*(icons.count + 1), 0, self.frame.size.width, self.frame.size.height)];
    [lastimage setImageWithURL:[NSURL URLWithString:[icons firstObject]]];
    lastimage.contentMode = UIViewContentModeScaleAspectFill;
    lastimage.clipsToBounds = YES;
    [self addSubview:lastimage];
    _time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(bannerTimeAction) userInfo:nil repeats:YES];
    [_time setFireDate:[NSDate date]];
    
    _selectBlock(3,nil);
}
#pragma mark 竖着动态播放的视图或广告
+(BaseScrollView *)sharedVerticallyBannerWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *banner = [[self alloc]initWithFrame:frame];
    [banner setBannerWithicons:icons];
    return banner;
}
-(void)setVerticallyBannerWithicons:(NSArray*)icons{
    self.tag = MyScrollVerticallyBanner;
    self.contentOffset = CGPointMake(0,self.frame.size.height);
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    count = icons.count + 2;
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    self.contentSize = CGSizeMake(0,self.frame.size.height * (icons.count + 2));
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfW, self.frame.size.height)];
    [imageview setImageWithURL:[NSURL URLWithString:icons.lastObject]];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [self addSubview:imageview];
    for (int i = 0; i < icons.count; i++) {
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0,selfH + i*selfH,selfW, selfH)];
        [imgv setImageWithURL:[NSURL URLWithString:icons[i]]];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        [self addSubview:imgv];
    }
    UIImageView *lastimage = [[UIImageView alloc]initWithFrame:CGRectMake(0,selfH*(icons.count + 1),selfW, selfH)];
    [lastimage setImageWithURL:[NSURL URLWithString:icons.firstObject]];
    lastimage.contentMode = UIViewContentModeScaleAspectFill;
    lastimage.clipsToBounds = YES;
    [self addSubview:lastimage];
    _time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(VerticallbannerTimeAction) userInfo:nil repeats:YES];
    [_time setFireDate:[NSDate date]];
    
}
#pragma mark 欢迎界面
+(BaseScrollView *)sharedWelcomWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *welcom = [[self alloc]initWithFrame:frame];
    [welcom setWelcomWithIcons:icons];
    return welcom;
}
-(void)setWelcomWithIcons:(NSArray*)icons{
    self.icons = icons;self.tag = MyScrollWelcom;
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
    [self setContentSize:CGSizeMake(self.frame.size.width*icons.count, self.frame.size.height)];
}
#pragma mark 集合配置
+(BaseScrollView *)sharedWithFrame:(CGRect)frame Titles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block{
    BaseScrollView *ref = [[self alloc]initWithFrame:frame];
    [ref setWithTitles:titles icons:icons round:round size:size type:type controllers:controllers selectIndex:block];
    return ref;
}
-(void)setWithTitles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block{
    self.titles = titles;
    self.icons = icons;
    self.controllers = controllers;
    self.selectBlock = block;
    switch (type) {
        case MyScrollSegmentType:{
            [self setSegmentWithTitles:titles];
        }break;
        case MyScrollTitleScrollType:{
            [self setTitleScrollWithTitles:titles];
        }break;
        case MyScrollTitleIconScrollType:{
            [self setTitleScrollWithTitles:titles icons:icons];
        }break;
        case MyScrollBaseItemType:{
            [self setBaseItemWithIcons:icons titles:titles size:size round:round];
        }break;
        case MyScrollScrollItemType:{
            [self setBaseItemWithIcons:icons titles:titles size:size hang:2 round:round];
        }break;
        case MyScrollContentViewType:{
            [self setContentViewWithTitles:titles controllers:controllers];
        }break;
        case MyScrollBanner:{
            [self setBannerWithicons:icons];
        }break;
        case MyScrollVerticallyBanner:{
            [self setVerticallyBannerWithicons:icons];
        }break;
        case MyScrollWelcom:{
            [self setWelcomWithIcons:icons];
        }break;
        default:{
            
        }break;
    }
}
#pragma mark Actions
-(void)selectThePage:(NSInteger)page{
    UIButton *button = (UIButton *)[self viewWithTag:page+10];
    [self buttonAction:button];
}
-(void)buttonAction:(UIButton *)btn{
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:10 + i];
        button.backgroundColor = [UIColor lightGrayColor];
        UIView *line = (UIView *)[self viewWithTag:button.tag + 20];
        line.backgroundColor = [UIColor clearColor];
    }
    btn.backgroundColor = [UIColor whiteColor];
    UIView *line = (UIView *)[self viewWithTag:btn.tag + 20];
    line.backgroundColor = [UIColor redColor];
    //////////////
    //    btn.transform = CGAffineTransformIdentity;
    //    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    //文字变红
    //    btn.transform = CGAffineTransformMakeScale(1.5, 1.5);    //放大的效果,放大1.5倍
    //数据回传=================================
    self.selectBlock(btn.tag-10,nil);
    CGFloat appW = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat centx =btn.frame.origin.x-appW/2+btn.frame.size.width/2;
    if(self.contentSize.width< btn.frame.origin.x+(appW+btn.frame.size.width)/2){
        centx = self.contentSize.width-appW+29;
    }else if(centx<0){
        centx = 0;
    }
    [self setContentOffset:CGPointMake(centx, 0) animated:YES];
}
#pragma mark Others
-(void)bannerTimeAction{
    pagecontroller.currentPage = index++;
    CGFloat selfW = self.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = CGPointMake(selfW*index, 0);
    } completion:^(BOOL finished) {
        if (self.contentOffset.x > selfW*(count - 2)) {
            self.contentOffset = CGPointMake(selfW, 0);
            index = 0;
        }
        if (self.contentOffset.x < selfW) {
            self.contentOffset = CGPointMake(selfW*(count - 2), 0);
            index = count - 2;
        }
    }];
}
-(void)VerticallbannerTimeAction{
    CGFloat selfH = self.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = CGPointMake(0,selfH*index);
    } completion:^(BOOL finished) {
        if (self.contentOffset.y > selfH*(count - 2)) {
            self.contentOffset = CGPointMake(0,selfH);
            index = 0;
        }
        if (self.contentOffset.y < selfH) {
            self.contentOffset = CGPointMake(0,selfH*(count - 2));
            index = count - 2;
        }
    }];
}

#pragma mark - scrollviewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_time setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

/// 实现字体颜色大小的渐变
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    switch (self.tag) {
        case MyScrollSegmentType:{
            
        }break;
        case MyScrollTitleScrollType:{
            
        }break;
        case MyScrollBaseItemType:{
            
        }break;
        case MyScrollContentViewType:{
            CGFloat offset = scrollView.contentOffset.x;
            //定义一个两个变量控制左右按钮的渐变
            NSInteger left = offset/[UIApplication sharedApplication].keyWindow.bounds.size.width;
            NSInteger right = 1 + left;
            UIButton * leftButton = (UIButton*)[self viewWithTag:left+10];
            UIButton * rightButton = nil;
            if (right < self.titles.count) {
                rightButton = (UIButton*)[self viewWithTag:10+right];
            }
            //切换左右按钮
            CGFloat scaleR = offset/[UIApplication sharedApplication].keyWindow.bounds.size.width - left;
            CGFloat scaleL = 1 - scaleR;
            //左右按钮的缩放比例
            CGFloat tranScale = 1.2 - 1 ;
            //宽和高的缩放(渐变)
            leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
            rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
            //颜色的渐变
            //    UIColor * rightColor = [UIColor colorWithRed:scaleR green:250 blue:250 alpha:1];
            UIColor * leftColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1];
            //重新设置颜色
            [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
            //    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
        }break;
        case MyScrollBanner:{
            
        }break;
        case MyScrollVerticallyBanner:{
            
        }break;
        case MyScrollWelcom:{
            
        }break;
        default:{
            
        }break;
    }
    
}
/// 滑动结束的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat selfW = self.frame.size.width;
    switch (self.tag) {
        case MyScrollSegmentType:{
            
        }break;
        case MyScrollTitleScrollType:{
            
        }break;
        case MyScrollBaseItemType:{
            
        }break;
        case MyScrollContentViewType:{
            NSUInteger i = self.contentOffset.x / [UIApplication sharedApplication].keyWindow.bounds.size.width;
            //            [self setTitleBtn:self.buttons[i]];
            //            [self setOnchildViewController:i];
        }break;
        case MyScrollBanner:{
            if (self.contentOffset.x > selfW*(count - 2)) {
                self.contentOffset = CGPointMake(selfW, 0);
            }
            if (self.contentOffset.x < selfW) {
                self.contentOffset = CGPointMake(selfW*(count - 2), 0);
            }
            index = self.contentOffset.x/selfW;
            if (index > count - 2) {
                index = 0;
            }
            if (index < 0) {
                index = count-2;
            }
            pagecontroller.currentPage = index;
        }break;
        case MyScrollVerticallyBanner:{
            if (self.contentOffset.y > self.frame.size.height*(count - 2)) {
                self.contentOffset = CGPointMake(0,self.frame.size.height);
            }
            if (self.contentOffset.y < self.frame.size.height) {
                self.contentOffset = CGPointMake(0,self.frame.size.height*(count - 2));
            }
            index = self.contentOffset.y/self.frame.size.height;
            if (index > count - 2) {
                index = 0;
            }
            if (index < 0) {
                index = count-2;
            }
            pagecontroller.currentPage = index;
        }break;
        case MyScrollWelcom:{
            
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
        
    }];
}

@end


