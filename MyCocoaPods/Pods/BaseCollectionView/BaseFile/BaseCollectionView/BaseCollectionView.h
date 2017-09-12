//
//  BaseCollectionView.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "BaseCollectionViewLayout.h"
typedef id (^BaseCollectionDataBlock)(NSInteger page);
typedef id (^BaseCollectionDataOfflineBlock)(NSInteger page);
typedef void (^BaseCollectionLoadedDataBlock)(NSArray *array,BOOL cache);
@interface BaseCollectionView : UICollectionView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) NSDictionary *postParams;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *strNullTitle;//没有数据时候提醒语句
@property (nonatomic, assign) SVProgressHUDMaskType progressHUDMask;
@property (nonatomic,copy) BaseCollectionDataBlock  bk_data;
@property (nonatomic,copy) BaseCollectionLoadedDataBlock bk_loaded;
@property (nonatomic,copy) BaseCollectionDataOfflineBlock bk_offline;
@property (nonatomic, strong)BaseCollectionViewLayout *layout;
@property (nonatomic, strong)BaseCollectionViewCell *cell;
#pragma mark 布局、属性与cell
#pragma mark tableView属性
@property (nonatomic,assign) BOOL canMoveRow;
@property (nonatomic,assign) NSInteger sectionN;
@property (nonatomic,assign) NSInteger itemN;
- (void)refresh;
- (void)loadmore;
- (void)stopRefresh;
- (void)stopLoadmore;
- (void)cancelDownload;
- (void)showRefresh:(BOOL)showRefresh LoadMore:(BOOL)showLoadmore;
- (void)loadUrl:(NSString*)url;
- (void)loadBlock:(BaseCollectionDataBlock)data_bk;
- (void)loadUrl:(NSString*)url withMask:(SVProgressHUDMaskType)mask;
- (void)loadBlock:(BaseCollectionDataBlock)data_bk withMask:(SVProgressHUDMaskType)mask;
- (void)loadBlock:(BaseCollectionDataBlock)data_bk offline:(BaseCollectionDataOfflineBlock)offline_bk withMask:(SVProgressHUDMaskType)mask;
- (void)loadWithRefresh:(BOOL)showRefresh withLoadmore:(BOOL)showLoadmore withMask:(SVProgressHUDMaskType)mask   Url:(NSString*)url withParam:(NSDictionary*)params data:(BaseCollectionDataBlock)data_bk offline:(BaseCollectionDataOfflineBlock)offline_bk loaded:(BaseCollectionLoadedDataBlock)loaded_bk;


@end





