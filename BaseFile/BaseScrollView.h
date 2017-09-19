//
//  BaseScrollView.h
//  薛超APP框架
//  Created by 薛超 on 16/9/13.
//  Copyright © 2016年 薛超. All rights reserved.
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyScrolltype) {
    MyScrollTypeSegment = 1,       //分类平分展示视图
    MyScrollTypeTitleScroll,       //标题滑动，自适应文字宽度
    MyScrollTypeTitleIconScroll,   //标题滑动，有文字和图标的
    MyScrollTypeBaseItem,     //内容小项目滑动，一般在主页
    MyScrollTypeScrollItem,     //内容小项目滑动，一般在主页并且有分页的
    MyScrollTypeContentView,  //内容视图滑动，如新闻类
    MyScrollTypeContentTitleView,  //内容视图滑动，如新闻类，同时自带标题的滑动
    MyScrollTypeContentIconView,  //内容视图滑动，如新闻类，同时自带标题拥有图标的滑动
    MyScrollTypeBanner,           //横着的滚动视图一般见推荐或广告
    MyScrollTypeVerticallyBanner, //竖着动态播放的视图或广告
    MyScrollTypeWelcom            //欢迎界面
};
typedef void(^selectIndexBlock)(NSInteger index,NSDictionary *dict);
typedef UIView* (^viewOfIndexBlock)(NSInteger index);
@interface BaseScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic,strong)NSTimer *time;//计时器
@property (nonatomic,strong)NSArray *icons;//图片内容  由图片视图或视图组成的数组
@property (nonatomic,strong)NSArray *titles;//标题    由文字组成的数组
@property (nonatomic,strong)NSMutableArray *contentViews;//用来盛放视图的
@property (nonatomic,strong)selectIndexBlock selectBlock;//内部反馈选择了第几个块
@property (nonatomic,strong)viewOfIndexBlock viewBlock;//外部协议告知第几个视图是什么样
@property (nonatomic,weak  )UIViewController *pushDelegateVC;//因为当前vc没有导航，所以交给此VCpush
-(void)selectThePage:(NSInteger)page;//外界调用主动选择第几个块
@property (nonatomic,strong)BaseScrollView *titleScrollView;//组合视图中的标题视图
@property (nonatomic,strong)BaseScrollView *contentScrollView;//组合视图中的内容视图
@property (nonatomic,assign)MyScrolltype scrollType;
#pragma mark 初始化完成相应东西的创建与配置
///分类平分展示视图
+(BaseScrollView *)sharedSegmentWithFrame:(CGRect)frame Titles:(NSArray*)titles;
///标题滑动，自适应文字宽度
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles;
///标题滑动，有文字和图标的
+(BaseScrollView *)sharedTitleIconScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles icons:(NSArray*)icons;
///内容小项目滑动，一般在主页
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round;
///内容小项目滑动，一般在主页并且有分页的
+(BaseScrollView *)sharedScrollItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round;
///内容视图滑动，如新闻类
+(BaseScrollView *)sharedContentViewWithFrame:(CGRect)frame controllers:(NSArray*)controllers inViewController:(UIViewController*)NVC;
///内容视图滑动，如新闻类，同时自带标题的滑动
+(BaseScrollView *)sharedContentTitleViewWithFrame:(CGRect)frame titles:(NSArray*)titles controllers:(NSArray*)controllers inViewController:(UIViewController*)NVC;
///内容视图滑动，如新闻类，同时自带拥有图标的标题的滑动
+(BaseScrollView *)sharedContentIconViewWithFrame:(CGRect)frame titles:(NSArray*)titles icons:(NSArray*)icons controllers:(NSArray*)controllers inViewController:(UIViewController*)NVC;
///横着的滚动视图一般见推荐或广告
+(BaseScrollView *)sharedBannerWithFrame:(CGRect)frame icons:(NSArray*)icons;
///竖着动态播放的视图或广告
+(BaseScrollView *)sharedVerticallyBannerWithFrame:(CGRect)frame icons:(NSArray*)icons;
///欢迎界面
+(BaseScrollView *)sharedWelcomWithFrame:(CGRect)frame icons:(NSArray*)icons;
#pragma mark 新增的方法
///分类展示的标题栏
+(BaseScrollView *)sharedViewSegmentWithFrame:(CGRect)frame viewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block;
///内容小项目视图
+(BaseScrollView *)sharedViewItemWithFrame:(CGRect)frame viewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block;
///视图banner兼容内容视图
+(BaseScrollView *)sharedViewBannerWithFrame:(CGRect)frame viewsNumber:(NSInteger)num viewOfIndex:(viewOfIndexBlock)block Vertically:(BOOL)vertical setFire:(BOOL)fire;
#pragma mark 集合配置
///集合配置
+(BaseScrollView *)sharedWithFrame:(CGRect)frame Titles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block;
-(void)setWithTitles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block;

- (void)show;
- (void)hidden;

@end

