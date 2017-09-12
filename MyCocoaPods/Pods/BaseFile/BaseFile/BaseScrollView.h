//
//  BaseScrollView.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/13.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MyScrolltype) {
    MyScrollSegmentType = 1,       //分类平分展示视图
    MyScrollTitleScrollType,       //标题滑动，自适应文字宽度
    MyScrollTitleIconScrollType,   //标题滑动，有文字和图标的
    MyScrollBaseItemType,     //内容小项目滑动，一般在主页
    MyScrollScrollItemType,     //内容小项目滑动，一般在主页并且有分页的
    MyScrollContentViewType,  //内容视图滑动，如新闻类，同时自带标题的滑动
    MyScrollBanner,           //横着的滚动视图一般见推荐或广告
    MyScrollVerticallyBanner, //竖着动态播放的视图或广告
    MyScrollWelcom            //欢迎界面
    
};
typedef void(^selectIndexBlock)(NSInteger index,NSDictionary *dict);
@interface BaseScrollView : UIScrollView
@property (nonatomic,strong)NSArray *icons;//图片内容  由图片视图或视图组成的数组
@property (nonatomic,strong)NSArray *titles;//标题    由文字组成的数组
@property (nonatomic,strong)NSArray *controllers;//控制器内容视图  由控制器的名字组成的数组
@property (nonatomic,assign)BOOL round;//小项目滑动的图标要不要圆
@property (nonatomic,assign)CGSize size;//小项目滑动的图标尺寸大小
@property (nonatomic,assign)NSInteger hang;//小项目滑动的图标行数
-(void)selectThePage:(NSInteger)page;//外界调用主动选择第几个块
@property (nonatomic,strong)selectIndexBlock selectBlock;//内部反馈选择了第几个块
@property (nonatomic, retain) NSTimer *time;//计时器
#pragma mark 初始化完成相应东西的创建与配置
///分类平分展示视图
+(BaseScrollView *)sharedSegmentWithFrame:(CGRect)frame Titles:(NSArray*)titles;
///标题滑动，自适应文字宽度
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles;
///标题滑动，有文字和图标的
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles icons:(NSArray*)icons;
///内容小项目滑动，一般在主页
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round;
///内容小项目滑动，一般在主页并且有分页的
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round;
///内容视图滑动，如新闻类，同时自带标题的滑动
+(BaseScrollView *)sharedContentViewWithFrame:(CGRect)frame titles:(NSArray*)titles controllers:(NSArray*)controllers;
///横着的滚动视图一般见推荐或广告
+(BaseScrollView *)sharedBannerWithFrame:(CGRect)frame icons:(NSArray*)icons;
///竖着动态播放的视图或广告
+(BaseScrollView *)sharedVerticallyBannerWithFrame:(CGRect)frame icons:(NSArray*)icons;
///欢迎界面
+(BaseScrollView *)sharedWelcomWithFrame:(CGRect)frame icons:(NSArray*)icons;
#pragma mark 集合配置
///集合配置
+(BaseScrollView *)sharedWithFrame:(CGRect)frame Titles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block;
-(void)setWithTitles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block;

- (void)show;
- (void)hidden;

@end

