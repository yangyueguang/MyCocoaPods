//
//  BaseFillTableViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/11.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseFillTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#define SAPPW              [UIScreen mainScreen].bounds.size.width
#define SAPPH              [UIScreen mainScreen].bounds.size.height
#define SW(obj)            (!obj?0:(obj).frame.size.width)
#define SH(obj)            (!obj?0:(obj).frame.size.height)
@interface selecttypeView : UIView
@property (nonatomic,copy) void (^selectypeveiwblock)(NSDictionary *dict);
-(void)setdatawitharr:(NSArray *)arr withselexttext:(NSString *)tex wihtimage:(NSString *)iamge;
@end
@implementation selecttypeView{
    UIScrollView *scrollView;
    NSArray *dataArr;
    NSString *selecttext;
    NSString *image;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:scrollView];
    }
    return self;
}

-(void)initUI{
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat stary = 0.0;
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        if([dict valueForKey:@"name"]){
            stary = [self createbutton:CGRectMake(0, stary, SW(self), 44) withtitle:[dict valueForKey:@"name"] withtag:i + 10];
        }else{
            stary = [self createbutton:CGRectMake(0, stary, SW(self), 44) withtitle:[dict valueForKey:@"companyname"] withtag:i + 10];
        }
    }
    scrollView.frame = CGRectMake(0, 0, SW(self), SH(self));
    CGFloat height = stary>SH(scrollView) + 1?stary:SH(scrollView) +1;
    scrollView.contentSize = CGSizeMake(0, height);
    
    
}

-(CGFloat)createbutton:(CGRect)frame withtitle:(NSString *)title withtag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    UIImage *img = [UIImage imageNamed:image];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, (SH(button) - 20)/2.0, SW(button) - 20 - img.size.width, 20)];
    titleLable.font = [UIFont systemFontOfSize:15];
    titleLable.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
    titleLable.text = title;
    titleLable.tag = button.tag + 100;
    [button addSubview:titleLable];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(SW(button) - 10 - img.size.width, (SH(button) - img.size.height)/2.0, img.size.width, img.size.height)];
    imageview.hidden = YES;
    imageview.image = img;
    imageview.tag = button.tag + 200;
    [button addSubview:imageview];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, SH(button) - 1, SW(button) - 20, 1)];
    line.image = [UIImage imageNamed:@"userLine"];
    [button addSubview:line];
    
    if ([titleLable.text isEqualToString:selecttext]) {
        titleLable.textColor = [UIColor redColor];
        imageview.hidden = NO;
    }
    
    return SH(button)+button.frame.origin.y;
    
}

-(void)btnAction:(UIButton *)btn
{
    for (int i = 0; i < dataArr.count; i++) {
        UIButton *button = (UIButton *)[scrollView viewWithTag:10 + i];
        UILabel *titlelable = (UILabel *)[button viewWithTag:button.tag + 100];
        titlelable.textColor = [UIColor lightGrayColor];
        UIImageView *imageview = (UIImageView *)[button viewWithTag:button.tag + 200];
        imageview.hidden = YES;
    }
    UILabel *titlelable = (UILabel *)[btn viewWithTag:btn.tag + 100];
    titlelable.textColor = [UIColor redColor];
    UIImageView *imageview = (UIImageView *)[btn viewWithTag:btn.tag + 200];
    _selectypeveiwblock(dataArr[btn.tag - 10]);
    imageview.hidden = NO;
}

-(void)setdatawitharr:(NSArray *)arr withselexttext:(NSString *)tex wihtimage:(NSString *)iamge
{
    selecttext = tex;
    dataArr = arr;
    image = iamge;
    [self initUI];
}


@end

#define kDuration 0.3
@implementation ALocation

@end
@interface AreaPickView (){
    NSArray *provinces, *cities, *areas;
}
@end
@implementation AreaPickView
@synthesize delegate=_delegate;
@synthesize datasource=_datasource;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;

-(ALocation *)locate{
    if (_locate == nil) {
        _locate = [[ALocation alloc] init];
    }return _locate;
}
- (id)initWithStyle:(AreaPickerStyle)pickerStyle withDelegate:(id <AreaPickerDelegate>)delegate andDatasource:(id <AreaPickerDatasource>)datasource{
    self = [[AreaPickView alloc]initWithFrame:CGRectMake(0, 0, SAPPW, 300)] ;
    if (self) {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.datasource = datasource;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        provinces = [self.datasource areaPickerData:self] ;
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
        if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            if (areas.count > 0) {
                self.locate.district = [areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
        } else{
            self.locate.city = [cities objectAtIndex:0];
        }
    }
    return self;
}



#pragma mark - PickerView lifecycle
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict)?3:2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:return [provinces count];break;
        case 1:return [cities count];break;
        case 2:if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {return [areas count];break;}
        default:return 0;break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:return [[provinces objectAtIndex:row] objectForKey:@"state"];break;
            case 1:return [[cities objectAtIndex:row] objectForKey:@"city"];break;
            case 2:if([areas count] > 0) {return [areas objectAtIndex:row];break;}
            default:return  @"";break;
        }
    } else{
        switch (component) {
            case 0:return [[provinces objectAtIndex:row] objectForKey:@"state"];break;
            case 1:return [cities objectAtIndex:row];break;
            default:return @"";break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 1:
                areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [cities objectAtIndex:0];
                break;
            case 1:
                self.locate.city = [cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
    
}


#pragma mark - animation
- (void)showInView:(UIView *) view{
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, view.frame.size.width, self.frame.size.height);
    }];
    
}
- (void)cancelPicker{
    [UIView animateWithDuration:0.3 animations:^{self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}
-(NSArray *)areaPickerData:(AreaPickView *)picker{
    NSArray *data;
    if (picker.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
        data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]] ;
    } else{
        data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]] ;
    }
    return data;
}
@end

@implementation SBaseGroup
@end
#pragma mark UITableViewCell
@interface SBaseCell(){
}
@end
@implementation SBaseCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"common";
    SBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = self.selectedBackgroundView = [[UIImageView alloc] init];
        self.imageView.image = nil;
        self.textLabel.text = nil;
        self.detailTextLabel.text = nil;
        self.accessoryView = nil;
        self.cellArray = nil;
        self.isFill = NO;
    }return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];// 调整子标题的x
}
-(void)setIcon:(NSString *)icon{
    _icon = icon;
    self.imageView.image = [UIImage imageNamed:icon];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = title;
}
-(void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",subtitle];
}
-(void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    if(!self.bageView){
        self.bageView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        self.bageView.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.bageView setTitleColor:[UIColor colorWithRed:148 green:148 blue:148 alpha:1] forState:UIControlStateNormal];
        [self.bageView  setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
    }
    [self.bageView  setTitle:badgeValue forState:UIControlStateNormal];
    self.accessoryView = self.bageView;
}
-(void)setRightArrow:(UIImageView *)rightArrow{
    _rightArrow = rightArrow;
    //    self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_right"]];
    self.accessoryView = self.rightArrow = rightArrow;
}
-(void)setRightSwitch:(UISwitch *)rightSwitch{
    _rightSwitch = rightSwitch;
    self.accessoryView = rightSwitch;
}
-(void)setRightLabel:(UILabel *)rightLabel{
    _rightLabel = rightLabel;
    rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = [UIColor lightGrayColor];
    _rightLabel.font = [UIFont systemFontOfSize:13];
    self.accessoryView = _rightLabel;
}
-(void)setValue:(NSString *)value{
    _value = value;
    //    if(!_rightLabel){
    //       self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-self.textLabel.frameWidth, H(self))];
    //    }self.rightLabel.text = value;
    self.subtitle = value;
}
-(void)setIsFill:(BOOL)isFill{
    _isFill = isFill;
    if(isFill){
        UITextField *fill = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SAPPW-self.textLabel.frame.size.width, SH(self))];
        fill.delegate = self;
        [self.contentView addSubview:fill];
    }
}
-(void)setCellArray:(NSArray *)cellArray{
    if(!self.cellArray){
        _cellArray = [NSArray array];
    }
    _cellArray = cellArray;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.value = [textField.text isEqualToString:@""]?self.value:textField.text;
    [textField endEditing:YES];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        if([self.value isEqualToString:@"\"\""]||[self.value isEqualToString:@""]||[self.value isEqualToString:@"''"]||[self.value isEqualToString:@"null"])return;
    }else{
        self.value = textField.text;
    }
    textField.text = @"";
    self.returnTextBlock(self.value,self.indexpath);
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
@end

#pragma mark BaseStaticTableView
@interface BaseFillTableViewController()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger pictype;
    UIImagePickerController *ipc;
    NSMutableArray *pictures;
    selecttypeView *typeView;
}
@end
@implementation BaseFillTableViewController
-(void)viewDidLoad{
    self.areaPickView = [[AreaPickView alloc]init];
    self.values = [NSMutableDictionary dictionaryWithCapacity:5];
    [self.values setObject:@"" forKey:@"info"];
    self.c1 = [SBaseCell cellWithTableView:(UITableView*)self.tableView];
    self.areaPickView.delegate = self;self.areaPickView.datasource = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SAPPW, SAPPH-10) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 5;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
-(void)setTableFootView:(UIView *)tableFootView{
    _tableFootView = tableFootView;
    self.tableView.tableFooterView = tableFootView;
}
- (NSMutableArray *)groups{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }return _groups;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SBaseGroup *group = self.groups[section];
    return group.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SBaseCell *cell = [SBaseCell cellWithTableView:tableView];
    SBaseGroup *group = self.groups[indexPath.section];
    cell = group.items[indexPath.row];
    cell.indexpath = indexPath;
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, SH(cell)-1, SAPPW, 1)];
    line.image = [UIImage imageNamed:@"userLine"];
    [cell addSubview:line];
    if(cell.cellArray){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        __weak __typeof__(SBaseCell)*weakc = cell;
        if (!cell.subtitle) {
            cell.detailTextLabel.text = cell.cellArray[0];
            [self.values setObject:cell.cellArray[0] forKey:[NSString stringWithFormat:@"%ld%ld",cell.indexpath.section,cell.indexpath.row]];
        }
        cell.operation = ^{
            typeView.hidden = !typeView.hidden;
            if(!typeView){
                typeView = [[selecttypeView alloc]init];
                [typeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeViewAction)]];
                typeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
                [self.tableView addSubview:typeView];
            }
            typeView.frame = CGRectMake(0, weakc.frame.size.height*indexPath.row+5*indexPath.section+64+10, SAPPW, weakc.cellArray.count*44);
            [typeView setdatawitharr:weakc.cellArray withselexttext:weakc.cellArray[0] wihtimage:@"icon_gou02"];
            __weak __typeof__(selecttypeView)*weakT = typeView;
            __weak __typeof(self)weakself = self;
            [typeView setSelectypeveiwblock:^(NSDictionary *dict) {
                weakT.hidden = YES;
                weakc.subtitle = dict[@"name"];
                [weakself.values setObject:dict[@"name"] forKey:[NSString stringWithFormat:@"%ld%ld",weakc.indexpath.section,weakc.indexpath.row]];
            }];
        };
    }
    [cell returnText:^(NSString *showText, NSIndexPath *path) {
        [self.values setObject:showText forKey:[NSString stringWithFormat:@"%ld%ld",path.section,path.row]];
    }];
    return cell;
}
-(void)typeViewAction{
    typeView.hidden = YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    SBaseGroup *group = self.groups[section];
    return group.footer;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SBaseGroup *group = self.groups[section];
    return group.header;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.取出这行对应的item模型
    SBaseGroup *group = self.groups[indexPath.section];
    SBaseCell *cell = group.items[indexPath.row];
    // 2.判断有无需要跳转的控制器
    if (cell.destVcClass) {
        UIViewController *vc = [[cell.destVcClass alloc]init];
        vc.title = cell.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 3.判断有无想执行的操作
    if (cell.operation) {
        cell.operation();
    }
}

#pragma mark - Action
-(void)idcardoneAction:(UIButton*)sender{
    pictype = sender.tag;
    if (!ipc) {ipc=[[UIImagePickerController alloc]init];}
    UIAlertController *acVC = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cansel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.allowsEditing = YES;
        ipc.delegate=self;
        [self presentViewController:ipc animated:YES completion:^{if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
            
            self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//            [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
        }}];
    }];
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断当前相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){// 打开相机
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.allowsEditing = YES;
            ipc.delegate=self;
            [self presentViewController:ipc animated:YES completion:^{
            }];
        }else{
            NSLog(@"设备不可用...");
        }

    }];
    [acVC addAction:cansel];
    [acVC addAction:destructive];
    [acVC addAction:other];
    [self presentViewController:acVC animated:YES completion:nil];
}

#pragma mark pickerC
//设备协议
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image1=[info objectForKey:UIImagePickerControllerOriginalImage];
    float t_w=image1.size.width>640?640:image1.size.width;
    float t_h= t_w/image1.size.width * image1.size.height;
    //处理图片
    UIImage *imageTmpeLogo=[self imageWithImageSimple:image1 scaledToSize:CGSizeMake(t_w, t_h)];
    [pictures[pictype] setImage:imageTmpeLogo forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;}
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent; }
    }];
}
//压缩图片
-(UIImage*)imageWithImageSimple:(UIImage*)image1 scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - textfielededelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];typeView.hidden = YES;
    return YES;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   [self.view endEditing:YES];typeView.hidden = YES;
}
-(NSArray *)areaPickerData:(AreaPickView *)picker{
    return nil;
}
#pragma mark  使用范例
-(void)test{
    // 1.创建组
    SBaseGroup *group = [[SBaseGroup alloc]init];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    SBaseCell *readMdoe = [SBaseCell cellWithTableView:self.tableView];
    group.items = @[readMdoe];
}
-(void)fillTheAddress:(NSDictionary *)a :(NSDictionary *)b :(NSDictionary *)c{
    self.province = a;
    self.city = b;
    self.area = c;
    NSArray *aarea = [NSArray arrayWithObjects:a,b,c, nil];
    [self.values setObject:aarea forKey:[NSString stringWithFormat:@"%ld%ld",self.c1.indexpath.section,self.c1.indexpath.row]];
    //    area1.text = [NSString stringWithFormat:@"%@-%@-%@",a[@"name"],b[@"name"],c[@"name"]];
    //    areaValue = area1.text;
}
@end
