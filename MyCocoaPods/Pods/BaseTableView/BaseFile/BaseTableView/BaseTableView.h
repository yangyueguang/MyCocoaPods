//
//  BaseTableView.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/9.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "BaseTableViewCell.h"
typedef id (^BaseTableDataBlock)(NSInteger page);
typedef id (^BaseTableDataOfflineBlock)(NSInteger page);
typedef void (^BaseTableLoadedDataBlock)(NSArray *array,BOOL cache);
@interface BaseTableView : UITableView
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) NSDictionary *paramsDict;
@property (nonatomic, strong) NSString *strNullTitle;//没有数据时候提醒语句
@property (nonatomic, assign) BOOL isHiddenNullTitle;
@property (nonatomic, assign) SVProgressHUDMaskType progressHUDMask;
@property (nonatomic,copy) BaseTableDataBlock bd_data;
@property (nonatomic,copy) BaseTableDataOfflineBlock bd_offline;
@property (nonatomic, copy) BaseTableLoadedDataBlock data_loaded;
#pragma mark tableView属性
@property (nonatomic,assign) BOOL canEditRow;
@property (nonatomic,assign) BOOL canMoveRow;
@property (nonatomic,assign) CGFloat headH;
@property (nonatomic,assign) CGFloat footH;
@property (nonatomic,assign) CGFloat rowH;
@property (nonatomic,assign) NSInteger sectionN;
@property (nonatomic,assign) NSInteger rowN;
@property (nonatomic,strong) BaseTableViewCell *cell;
//@property (nonatomic,strong) UIView *headView;
//@property (nonatomic,strong) UIView *footView;
- (void)refresh;
- (void)loadmore;
- (void)stopRefresh;
- (void)stopLoadmore;
- (void)cancelDownload;
- (void)canRefresh:(BOOL)refresh LoadMore:(BOOL)loadmore;

- (void)loadUrl:(NSString*)url;
- (void)loadBlock:(BaseTableDataBlock)data_bk;
- (void)loadUrl:(NSString*)url withMask:(SVProgressHUDMaskType)mask;
- (void)loadBlock:(BaseTableDataBlock)data_bk withMask:(SVProgressHUDMaskType)mask;
- (void)loadBlock:(BaseTableDataBlock)data_bk offline:(BaseTableDataOfflineBlock)offline_bk withMask:(SVProgressHUDMaskType)mask;
- (void)loadWithRefresh:(BOOL)showRefresh withLoadmore:(BOOL)showLoadmore withMask:(SVProgressHUDMaskType)mask  Url:(NSString*)url withParam:(NSDictionary*)params data:(BaseTableDataBlock)data_bk offline:(BaseTableDataOfflineBlock)offline_bk loaded:(BaseTableLoadedDataBlock)loaded_bk;
@end
