//
//  BaseFillTableViewController.h
//  薛超APP框架
//
//  Created by 薛超 on 16/10/11.
//  Copyright © 2016年 薛超. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef enum {
    AreaPickerWithStateAndCity,
    AreaPickerWithStateAndCityAndDistrict
} AreaPickerStyle;
@interface ALocation : NSObject
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;

@end
@class AreaPickView;

@protocol AreaPickerDatasource <NSObject>
- (NSArray *)areaPickerData:(AreaPickView *)picker;
@end
@protocol AreaPickerDelegate <NSObject>
@optional
- (void)pickerDidChaneStatus:(AreaPickView *)picker;
@end
@interface AreaPickView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (assign, nonatomic) id <AreaPickerDelegate> delegate;
@property (assign, nonatomic) id <AreaPickerDatasource> datasource;
@property (strong, nonatomic) UIPickerView *locatePicker;
@property (strong, nonatomic) ALocation *locate;
@property (nonatomic) AreaPickerStyle pickerStyle;
- (id)initWithStyle:(AreaPickerStyle)pickerStyle withDelegate:(id <AreaPickerDelegate>)delegate andDatasource:(id <AreaPickerDatasource>)datasource;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end



@class SBaseCell;
@interface BaseFillTableViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,AreaPickerDelegate,AreaPickerDatasource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) UIView *tableFootView;
@property (nonatomic, strong)SBaseCell *c1;
@property (nonatomic, strong)NSString *realname;
@property (nonatomic, strong)NSString *phone;

//返回的区域数据
@property (nonatomic ,strong)NSDictionary *province;
@property (nonatomic ,strong)NSDictionary *city;
@property (nonatomic ,strong)NSDictionary *area;

@property (nonatomic ,strong)AreaPickView *areaPickView;
@end
@interface SBaseGroup : NSObject
@property (nonatomic, copy) NSString *header;/** 组头 */
@property (nonatomic, copy) NSString *footer;/** 组尾 */
@property (nonatomic, strong) NSArray *items;/** 这组的所有行模型*/
@end

@interface SBaseCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, copy) NSString *icon;/** 图标 */
@property (nonatomic, copy) NSString *title;/** 标题 */
@property (nonatomic, copy) NSString *subtitle;/** 子标题 */
@property (nonatomic, copy) NSString *badgeValue;/** 右边显示的数字标记 */
@property (nonatomic, copy) NSString *value;/** 右边label显示的内容 */
@property (nonatomic, copy) void (^operation)();/** 封装点击这行cell想做的事情 */
@property (strong,nonatomic) UIImageView *rightArrow;//箭头
@property (strong,nonatomic) UISwitch *rightSwitch;//开关
@property (strong,nonatomic) UILabel *rightLabel;//标签
@property (strong,nonatomic) UIButton *bageView;//提醒数字
@property (strong,nonatomic) NSArray *cellArray;//备选列表
@property (nonatomic,assign) BOOL isFill;//填值的
@property (nonatomic,assign) NSIndexPath *indexpath;//地址
@property (nonatomic,assign) Class destVcClass;/** 点击这行cell，需要调转到哪个控制器 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
typedef void (^ReturnTextBlock)(NSString *showText,NSIndexPath *path);
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end

