//
//  BaseCollectionViewLayout.h
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/6.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewLayout:UICollectionViewFlowLayout
//@property (nonatomic, assign)CGSize cellSize;已经有了
@property (nonatomic, assign)UIEdgeInsets groupInset;
@property (nonatomic, assign)CGFloat itemSpace;
@property (nonatomic, assign)CGFloat lineSpace;
@property (nonatomic, assign) BOOL isMinimumContentSizeEnable;
+(instancetype)sharedFlowlayoutWithCellSize:(CGSize)size groupInset:(UIEdgeInsets)insets itemSpace:(CGFloat)itemspace linespace:(CGFloat)linespace;
-(instancetype)initWithCellSize:(CGSize)size groupInset:(UIEdgeInsets)insets itemSpace:(CGFloat)itemspace linespace:(CGFloat)linespace;

@property (nonatomic, assign) CGSize minimumContentSize;
@end
