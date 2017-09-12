//
//  BaseStaticTableView.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/9.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SWCommonItem : NSObject
@property (nonatomic, copy) NSString *icon;/** 图标 */
@property (nonatomic, copy) NSString *title;/** 标题 */
@property (nonatomic, copy) NSString *subtitle;/** 子标题 */
@property (nonatomic, copy) NSString *badgeValue;/** 右边显示的数字标记 */
@property (nonatomic, copy) NSString *text;/** 右边label显示的内容 */
@property (nonatomic, assign) Class destVcClass;/** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, copy) void (^operation)();/** 封装点击这行cell想做的事情 */
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
@end
@interface SWCommonGroup : NSObject
@property (nonatomic, copy) NSString *header;/** 组头 */
@property (nonatomic, copy) NSString *footer;/** 组尾 */
@property (nonatomic, strong) NSArray *items;/** 这组的所有行模型*/
+ (instancetype)group;
@end
@interface SWCommonCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;
@property (nonatomic, strong) SWCommonItem *item;/** cell对应的item数据 */
@end
@interface BaseStaticTableView : UITableView
- (NSMutableArray *)groups;
@end
