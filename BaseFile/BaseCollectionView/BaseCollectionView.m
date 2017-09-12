//
//  BaseCollectionView.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseCollectionView.h"
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <NSString_expanded/NSString+expanded.h>

#import <SVProgressHUD/SVProgressHUD.h>


@interface BaseCollectionView(){
    UIView *bgView;
    UIControl *closeC;
    UILabel *labelNull;
    UIImage *imageNull;
    BOOL boolNull;
    BOOL canRefresh;
    BOOL canLoadmore;
}
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end
@implementation BaseCollectionView
#pragma mark 初始化
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initComponents];
    }return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initComponents];
    }return self;
}
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self=[super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initComponents];
    }return self;
}
- (void)initComponents{
    self.alwaysBounceVertical = YES;canRefresh = canLoadmore = YES;
    self.progressHUDMask = SVProgressHUDMaskTypeClear;
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    loadMoreFrame.origin.y = self.contentSize.height +  (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));
}
#pragma mark 刷新与加载
- (void)refresh{
    if(!canRefresh)return;
    [self stopLoadmore];
    [self loadData:1];
}
- (void)loadmore{
    if(!canLoadmore)return;
    _curPage ++;
    [self stopRefresh];
    [self loadData:_curPage];
}
- (void)stopRefresh{
    [self.mj_header endRefreshing];
}
- (void)stopLoadmore{
    [self.mj_footer endRefreshing];
}
- (void)cancelDownload{
    self.bk_data = nil;
    [self.task cancel];
    [SVProgressHUD dismiss];
}
- (void)loadData:(NSInteger)page{
    _curPage = page;
    SVProgressHUDMaskType masktype = self.progressHUDMask;
    if(masktype){
        if (masktype != SVProgressHUDMaskTypeNone) {
            [SVProgressHUD showWithStatus:@"正在加载..." maskType:masktype];
        }
    }
    self.strNullTitle=nil;
    //离线、刷新、加载更多数据加载完成处理。
    void(^block)(NSArray* array, BOOL isCache) = ^(NSArray* array, BOOL isCache){
        NSLog(@"\n\n%@:\n%@\n\n",isCache?@"Cache":@"Sever",array);
        if (array.count || _curPage==1) {
            if (masktype != SVProgressHUDMaskTypeNone) {[SVProgressHUD dismiss];}
            if (_curPage <= 1) {
                self.dataArray = [NSMutableArray arrayWithArray:array];
            }else{
                [self.dataArray addObjectsFromArray:array];
            }
        }else{
            if (_curPage > 2&&!isCache)_curPage --;
            if (_curPage <= 1)[self.dataArray removeAllObjects];
            if(masktype){
                if (masktype != SVProgressHUDMaskTypeNone) {
                    if(_curPage>1)[SVProgressHUD showImage:nil status:self.strNullTitle?self.strNullTitle:@"亲！没有更多数据了"];
                    else [SVProgressHUD showImage:nil status:self.strNullTitle?self.strNullTitle:@"暂无数据"];
                }
            }
        }
        bgView.hidden=YES;
        if (self.dataArray.count==0) {
            self.backgroundView=[self tipsView:boolNull];
            closeC.userInteractionEnabled=boolNull;
        }else{
            self.backgroundView=nil;
            closeC.userInteractionEnabled=NO;
        }
        
        if (self.dataArray.count >= 10)[self loadmore];
        else [self stopLoadmore];
        //数据加载成功
        if (self.bk_loaded)self.bk_loaded(self.dataArray,isCache);
        [self reloadData];
        [self stopLoadmore];
        isCache?nil:[self stopRefresh];
    };
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]&&self.bk_offline) {//离线状态
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSArray *array =self.bk_offline(_curPage);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(array,YES);
            });
        });
        return;
    }
    //数据加载器：离线、同步（例如：hessian）、异步（NKNetwork）、test
    if (self.bk_data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSArray *array = ![[AFNetworkReachabilityManager sharedManager] isReachable]?(self.bk_offline?self.bk_offline(_curPage):nil):self.bk_data(_curPage);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(array,YES);
            });
        });
    }else if(self.urlString.length){
                 self.task=[[AFHTTPSessionManager manager] GET:self.urlString parameters:self.postParams progress:^(NSProgress * _Nonnull downloadProgress) {
                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"responseObject:%@",responseObject);
                     self.backgroundView=nil;
                     self.strNullTitle=[responseObject valueForKey:@"info"];
                     if ([[responseObject valueForKey:@"status"] isEqualToString:@"200"]) {
                         boolNull=NO;
                         //数据成功
                         self.dataDic=[NSMutableDictionary dictionaryWithDictionary:[responseObject valueForKey:@"data"]];
                         block([[responseObject valueForKey:@"data"] valueForKey:@"list"],NO);
                     }else{
                         boolNull=YES;
                         block([NSArray array],YES);
                         if (masktype != SVProgressHUDMaskTypeNone) {
                             [SVProgressHUD showImage:nil status:[[responseObject valueForKey:@"info"] notEmptyOrNull]?[responseObject valueForKey:@"info"]:@"网络错误，请稍后重试"];
                         }
                     }

                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     boolNull=YES;
                     block([NSArray array],NO);
                     self.strNullTitle=nil;
                     if (masktype != SVProgressHUDMaskTypeNone) {
                         [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后重试"];
                     }
                 }];
    }else{
        //JUST for test
        block([NSArray array],YES);
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate];
    }
}
#pragma mark - Extends
- (void)loadUrl:(NSString*)url{
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:url withParam:nil data:nil offline:nil loaded:nil];
}
- (void)loadUrl:(NSString*)url withMask:(SVProgressHUDMaskType)mask{
    self.progressHUDMask = mask;
    [self loadWithRefresh:YES withLoadmore:YES withMask:mask Url:url withParam:nil data:nil offline:nil loaded:nil];
}
- (void)loadBlock:(BaseCollectionDataBlock)data_bk{
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:nil withParam:nil data:data_bk offline:nil loaded:nil];
}
- (void)loadBlock:(BaseCollectionDataBlock)data_bk offline:(BaseCollectionDataOfflineBlock)offline_bk withMask:(SVProgressHUDMaskType)mask{
    self.progressHUDMask = mask;
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:nil withParam:nil data:data_bk offline:offline_bk loaded:nil];
}
- (void)loadBlock:(BaseCollectionDataBlock)data_bk withMask:(SVProgressHUDMaskType)mask{
    self.progressHUDMask = mask;
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:nil withParam:nil data:data_bk offline:nil loaded:nil];
}
- (void)showRefresh:(BOOL)showRefresh LoadMore:(BOOL)showLoadmore{
    canRefresh = showRefresh;
    canLoadmore = showLoadmore;
}
/**
 @method
 @abstract 表格数据加载模型
 @discussion 通过url 以及参数 params
 @param url 数据来源  params 参数列表
 @result JSON数组
 */
- (void)loadWithRefresh:(BOOL)showRefresh withLoadmore:(BOOL)showLoadmore withMask:(SVProgressHUDMaskType)mask Url:(NSString *)url withParam:(NSDictionary *)params data:(BaseCollectionDataBlock)data_bk offline:(BaseCollectionDataOfflineBlock)offline_bk loaded:(BaseCollectionLoadedDataBlock)loaded_bk{
    [self showRefresh:showRefresh LoadMore:showLoadmore];
    self.progressHUDMask = mask;
    self.urlString = url;
    self.postParams = params;
    self.bk_data = data_bk;
    self.bk_offline = offline_bk;
    self.bk_loaded = loaded_bk;
    [self refresh];
}
//背景view
- (UIView*)tipsView:(BOOL)refreshBool;{
    if (!bgView) {
        bgView = [[UIView alloc] initWithFrame:self.bounds];
        closeC=[[UIControl alloc]initWithFrame:self.bounds];
        [closeC addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeC];
        // imageNull = ;
        // [bgView addSubview:imageview];
        labelNull = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.bounds.size.height-20)/2, self.frame.size.width-20,20)];
        labelNull.font = [UIFont systemFontOfSize:15];
        labelNull.textColor = [UIColor lightGrayColor];
        labelNull.backgroundColor = [UIColor clearColor];
        labelNull.textAlignment = NSTextAlignmentCenter;
        labelNull.numberOfLines = 0;
        [bgView addSubview:labelNull];
    }
    closeC.userInteractionEnabled=refreshBool;
    bgView.hidden=NO;
    NSString *strTitle=self.strNullTitle?self.strNullTitle:@"暂无数据";
    labelNull.text = refreshBool?@"数据获取失败，请点击屏幕重新获取数据":strTitle;
    return bgView;
}
- (void)dealloc{
    self.bk_data = nil;
    [self cancelDownload];
}

@end
