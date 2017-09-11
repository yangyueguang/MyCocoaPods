//
//  BaseStaticTableView.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/9.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseStaticTableView.h"
@implementation SWCommonItem
+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithTitle:title icon:nil];
}
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon{
    SWCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}
@end
@implementation SWCommonGroup
+ (instancetype)group{
    return [[self alloc] init];
}
@end
#pragma mark UITableViewCell
@interface SWCommonCell()
@property (strong, nonatomic) UIImageView *rightArrow;//箭头
@property (strong, nonatomic) UISwitch *rightSwitch;//开关
@property (strong, nonatomic) UILabel *rightLabel;//标签
@property (strong, nonatomic) UIButton *bageView;//提醒数字
@property (nonatomic, copy) NSString *badgeValue;
@end
@implementation SWCommonCell
- (UIImageView *)rightArrow{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_right"]];
    }return _rightArrow;
}
- (UISwitch *)rightSwitch{
    if (_rightSwitch == nil) {
        self.rightSwitch = [[UISwitch alloc] init];
    }return _rightSwitch;
}
- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
    }return _rightLabel;
}

- (UIButton *)bageView{
    if (_bageView == nil) {
        self.bageView = [[UIButton alloc] init];
        self.bageView.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.bageView setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
    }return _bageView;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"common";
    SWCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SWCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
    }return self;
}
#pragma mark - 调整子控件的位置
- (void)layoutSubviews{
    [super layoutSubviews];
    // 调整子标题的x
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame)+5,self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}
#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
        bgView.image = [UIImage imageNamed:@"white"];
        selectedBgView.image = [UIImage imageNamed:@"gray"];
}
- (void)setItem:(SWCommonItem *)item{
    _item = item;
    // 1.设置基本数据
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    // 2.设置右边的内容
    if (item.badgeValue) { // 紧急情况：右边有提醒数字
        // 按钮的高度就是背景图片的高度
        self.bageView.frame = CGRectMake(self.bageView.frame.origin.x, self.bageView.frame.origin.y, self.bageView.currentBackgroundImage.size.width,self.bageView.currentBackgroundImage.size.height);
        // 设置文字
        [self.bageView setTitle:item.badgeValue forState:UIControlStateNormal];
        self.accessoryView = self.bageView;
    } else if ([item isKindOfClass:[SWCommonItem class]]) {
        self.accessoryView = self.rightArrow;
    } else if ([item isKindOfClass:[UISwitch class]]) {
        self.accessoryView = self.rightSwitch;
    } else if ([item isKindOfClass:[UILabel class]]) {
        self.accessoryView = self.rightLabel;
    } else { // 取消右边的内容
        self.accessoryView = nil;
    }
}
@end
#pragma mark BaseStaticTableView
@interface BaseStaticTableView ()
@property (nonatomic, strong) NSMutableArray *groups;
@end
@implementation BaseStaticTableView
- (NSMutableArray *)groups{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }return _groups;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    self.backgroundColor = [UIColor lightGrayColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sectionFooterHeight = 5;
    self.sectionHeaderHeight = 0;
    self.contentInset = UIEdgeInsetsMake(5 - 35, 0, 0, 0);
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SWCommonGroup *group = self.groups[section];
    return group.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SWCommonCell *cell = [SWCommonCell cellWithTableView:tableView];
    SWCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    // 设置cell所处的行号 和 所处组的总行数
    [cell setIndexPath:indexPath rowsInSection:(int)group.items.count];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    SWCommonGroup *group = self.groups[section];
    return group.footer;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SWCommonGroup *group = self.groups[section];
    return group.header;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.取出这行对应的item模型
    SWCommonGroup *group = self.groups[indexPath.section];
    SWCommonItem *item = group.items[indexPath.row];
    
    // 2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        UIViewController *destVc = [[item.destVcClass alloc] init];
        destVc.title = item.title;
//        [self.navigationController pushViewController:destVc animated:YES];
    }
    // 3.判断有无想执行的操作
    if (item.operation) {
        item.operation();
    }
}
#pragma mark  使用范例
-(void)test{
    // 1.创建组
    SWCommonGroup *group = [SWCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    SWCommonItem *readMdoe = [SWCommonItem itemWithTitle:@"阅读模式"];readMdoe.text = @"有图模式";
    SWCommonItem *readMdoe1 = [SWCommonItem itemWithTitle:@"字号大小"];readMdoe1.text = @"中";
    SWCommonItem *readMdoe2 = [SWCommonItem itemWithTitle:@"显示备注"];readMdoe2.text = @"是";
    group.items = @[readMdoe,readMdoe1,readMdoe2];
}
@end
