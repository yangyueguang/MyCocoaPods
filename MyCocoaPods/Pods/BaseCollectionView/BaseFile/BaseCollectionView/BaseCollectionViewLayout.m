//
//  BaseCollectionViewLayout.m
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/6.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "BaseCollectionViewLayout.h"
@implementation BaseCollectionViewLayout
+(instancetype)sharedFlowlayoutWithCellSize:(CGSize)size groupInset:(UIEdgeInsets)insets itemSpace:(CGFloat)itemspace linespace:(CGFloat)linespace{
    BaseCollectionViewLayout *layout = [[BaseCollectionViewLayout alloc]initWithCellSize:size groupInset:insets itemSpace:itemspace linespace:linespace];

    return layout;
}
-(instancetype)initWithCellSize:(CGSize)size groupInset:(UIEdgeInsets)insets itemSpace:(CGFloat)itemspace linespace:(CGFloat)linespace{
    if (self = [super init]) {
        self.itemSize = size;
        self.sectionInset = insets;
        self.minimumInteritemSpacing = itemspace;
        self.minimumLineSpacing = linespace;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        // 设置item的大小
        
        // 设置水平滚动
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置最小行间距和格间距为10
        self.minimumInteritemSpacing = _itemSpace;//格
        self.minimumLineSpacing = _lineSpace;//行
        // 设置内边距
        self.sectionInset = _groupInset;
        
        self.isMinimumContentSizeEnable = YES;
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    CGSize superContentSize = [super collectionViewContentSize];
    
    if (self.isMinimumContentSizeEnable) {
        if (superContentSize.width < self.minimumContentSize.width || superContentSize.height < self.minimumContentSize.height) {
            return self.minimumContentSize;
        }

    }
    
    return superContentSize;
}

@end
