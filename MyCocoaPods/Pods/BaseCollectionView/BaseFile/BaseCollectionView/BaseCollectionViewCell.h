//
//  BaseCollectionViewCell.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/12.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIImageView *picV;
@property(nonatomic,strong)UIView      *line;
@property(nonatomic,strong)UILabel     *title;
@property(nonatomic,strong)UILabel     *script;
@property(nonatomic,strong)UIView      *cellContentView;
@property(nonatomic,strong)UISwitch    *swich;
+(NSString*) getTableCellIdentifier;
-(void) deallocTableCell;//子类继承
-(NSArray*)observableKeypaths;//子类继承
-(void)updateUIForKeypath:(NSString*) keyPath;//子类继承

-(void)initUI;
-(void)setCollectionDataWithDic:(NSDictionary*)dict;
@end
