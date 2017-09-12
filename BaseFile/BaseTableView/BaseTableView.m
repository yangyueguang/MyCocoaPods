//
//  BaseTableView.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/9.
//  Copyright © 2016年 薛超. All rights reserved.
//
#import "BaseTableView.h"
#import <MJRefresh/MJRefresh.h>
#import <NSString_expanded/NSString+expanded.h>
#import <AFNetworking/AFNetworking.h>

@interface BaseTableView(){
    UIView *bgView;
    UIControl *closeC;
    UILabel *labelNull;
    UIImage *imageNull;
    BOOL boolNull;//什么数据都没有
    BOOL canLoadmore;
    BOOL canRefresh;
}
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end
@implementation BaseTableView
#pragma mark 初始化
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _progressHUDMask = SVProgressHUDMaskTypeClear;
    }return self;
}
- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        canRefresh = canLoadmore = YES;
        _progressHUDMask = SVProgressHUDMaskTypeClear;
    }return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    _footLoadView.frameY = self.contentSize.height + (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));
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
    self.bd_data = nil;
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
    //离线、刷新、加载更多数据加载完成处理。
    void(^block)(NSArray* array, BOOL isCache) = ^(NSArray* array, BOOL isCache){
        NSLog(@"\n%@:\n%@\n",isCache?@"Cache":@"Sever",array);
        if (array.count || _curPage==1) {
            if (masktype != SVProgressHUDMaskTypeNone) {
                [SVProgressHUD dismiss];
            }
            if (_curPage <= 1) {
                self.dataArray = [NSMutableArray arrayWithArray:array];
            }else{
                [self.dataArray addObjectsFromArray:array];
            }
        }else{
            if (_curPage > 2&& isCache) {
                _curPage --;
            }
            if (_curPage <= 1) {
                [self.dataArray removeAllObjects];
            }
            if(masktype){
                if (masktype != SVProgressHUDMaskTypeNone) {
                    if(_curPage>1){
                        [SVProgressHUD showImage:nil status:self.strNullTitle?self.strNullTitle:@"亲！没有更多数据了"];
                    }else{
                        [SVProgressHUD showImage:nil status:self.strNullTitle?self.strNullTitle:@"暂无数据"];
                    }
                    
                }
            }
        }
        if (self.dataArray.count==0) {
            self.backgroundView = [self tipsView:boolNull];
        }else{
            self.backgroundView=nil;
            closeC.userInteractionEnabled=NO;
        }
        canLoadmore = self.dataArray.count>=10;
        //数据加载成功
        if (self.data_loaded) {
            self.data_loaded(self.dataArray,isCache);
        }
        [self reloadData];
        [self stopLoadmore];
        isCache?nil:[self stopRefresh];
    };
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]&&self.bd_offline) {//离线状态
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSArray *array =self.bd_offline(_curPage);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(array,YES);
            });
        });
        return;
    }
    //数据加载器：离线、同步（例如：hessian）、异步、test
    if (self.bd_data) {//存在本地数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSArray *array = ![[AFNetworkReachabilityManager sharedManager] isReachable]?(self.bd_offline?self.bd_offline(_curPage):nil):self.bd_data(_curPage);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(array,YES);
            });
        });
    }else if(self.urlString.length){//网络请求
        self.task = [[AFHTTPSessionManager manager] GET:self.urlString parameters:self.paramsDict progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"\n%@",responseObject);
            self.strNullTitle=[responseObject valueForKey:@"info"];
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"200"]) {
                boolNull=NO;
//                self.backgroundView=nil;
                //数据成功
                self.dataDic=[NSMutableDictionary dictionaryWithDictionary:[responseObject valueForKey:@"data"]];
               
                block([self.dataDic valueForKey:@"list"],NO);
            }else{
                boolNull=YES;
                block([NSArray array],NO);
                if (masktype != SVProgressHUDMaskTypeNone) {
                    [SVProgressHUD showImage:nil status:[[responseObject valueForKey:@"info"] notEmptyOrNull]?[responseObject valueForKey:@"info"]:@"网络错误，请稍后重试"];
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            boolNull=YES;
            block([NSArray array],NO);
            NSLog(@"%@",[NSString stringWithFormat:@"%@",error]);
            if (masktype != SVProgressHUDMaskTypeNone) {
                [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后重试"];
            }
 
        }];
    }else{
        block([NSArray array],YES);
    }
}
#pragma mark 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [[self.dataArray[indexPath.row] allValues] componentsJoinedByString:@","];
    return cell;
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
- (void)loadBlock:(BaseTableDataBlock)data_bk{
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:nil withParam:nil data:data_bk offline:nil loaded:nil];
}
- (void)loadBlock:(BaseTableDataBlock)data_bk offline:(BaseTableDataOfflineBlock)offline_bk withMask:(SVProgressHUDMaskType)mask{
    self.progressHUDMask = mask;
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:nil withParam:nil data:data_bk offline:offline_bk loaded:nil];
}
- (void)loadBlock:(BaseTableDataBlock)data_bk withMask:(SVProgressHUDMaskType)mask{
    self.progressHUDMask = mask;
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:nil withParam:nil data:data_bk offline:nil loaded:nil];
}
-(void)canRefresh:(BOOL)refresh LoadMore:(BOOL)loadmore{
    canRefresh = refresh;canLoadmore = loadmore;
}
- (void)loadWithRefresh:(BOOL)showRefresh withLoadmore:(BOOL)showLoadmore withMask:(SVProgressHUDMaskType)mask Url:(NSString*)url withParam:(NSDictionary*)params data:(BaseTableDataBlock)data_bk offline:(BaseTableDataOfflineBlock)offline_bk loaded:(BaseTableLoadedDataBlock)loaded_bk{
    [self canRefresh:showRefresh LoadMore:showLoadmore];
    self.progressHUDMask = mask;
    self.urlString  = url;
    self.paramsDict = params;
    self.bd_data    = data_bk;
    self.bd_offline = offline_bk;
    self.data_loaded = loaded_bk;
    [self refresh];
}

- (UIView*)tipsView:(BOOL)refreshBool;{// 背景view
    if (!bgView) {
        bgView = [[UIView alloc] initWithFrame:self.bounds];
        closeC=[[UIControl alloc]initWithFrame:self.bounds];
        [closeC addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeC];
        labelNull = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.bounds.size.height-20)/2, self.frame.size.width-20,20)];
        labelNull.font = [UIFont systemFontOfSize:15];
        labelNull.textColor = [UIColor lightGrayColor];
        labelNull.backgroundColor = [UIColor clearColor];
        labelNull.textAlignment = NSTextAlignmentCenter;
        labelNull.numberOfLines = 0;
        [bgView addSubview:labelNull];
    }
    closeC.userInteractionEnabled=refreshBool;
    NSString *strTitle=self.strNullTitle?self.strNullTitle:@"暂无数据";
    strTitle=self.isHiddenNullTitle?@"":strTitle;
    labelNull.text = refreshBool?@"数据获取失败，请点击屏幕重新获取数据":strTitle;
    return bgView;
}
- (void)dealloc{
    [self cancelDownload];
}
@end
