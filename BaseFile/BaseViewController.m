
#import "BaseViewController.h"
#include <objc/runtime.h>
#import <AFNetworking/AFNetworking.h>
static BaseViewController *BVC = nil;
@interface BaseViewController ()
@property (nonatomic,strong) UILabel *sizeLabel;
@property (nonatomic,strong) UITextView *sizeTextView;
@end
@implementation BaseViewController
+ (BaseViewController *) sharedViewController{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        BVC = [[BaseViewController alloc] initWithNavStyle:1];
    });
    return BVC;
}
- (id)initWithNavStyle:(NSInteger)style{
    self = [super init];
    if (self) {
        
    }return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.automaticallyAdjustsScrollViewInsets=NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0,[UIApplication sharedApplication].keyWindow.bounds.size.width,64)];
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont boldSystemFontOfSize:18.0f], nil] forKeys:[NSArray arrayWithObjects: NSForegroundColorAttributeName,NSFontAttributeName, nil]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    [self.view setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor lightGrayColor]];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        CGFloat topBarOffset = [[self performSelector:@selector(topLayoutGuide)] length];
        NSLog(@"viewDidLayoutSubviews_topBarOffset:%f",topBarOffset);
    }
    self.automaticallyAdjustsScrollViewInsets=NO;
}
- (UIBarButtonItem*)leftBarButtonItemWithTitle:(NSString*)title Image:(UIImage *)image customView:(UIView*)view style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)sel{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]init];
    leftItem.style = style;
    if(image){
        leftItem.image = image;
    }else if(title){
        leftItem.title = title;
    }else if(view){
        leftItem.customView = view;
    }
    leftItem.target = target;
    leftItem.action = sel;
    self.navigationItem.leftBarButtonItem = leftItem;
    return leftItem;
}
- (UIBarButtonItem*)rightBarButtonItemWithTitle:(NSString*)title Image:(UIImage *)image customView:(UIView*)view style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)sel{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]init];
    rightItem.style = style;
    if(image){
        rightItem.image = image;
    }else if(title){
        rightItem.title = title;
    }else if(view){
        rightItem.customView = view;
    }
    rightItem.target = target;
    rightItem.action = sel;
    self.navigationItem.rightBarButtonItem = rightItem;
    return rightItem;
}

- (void)setTitle:(NSString *)title titleView:(UIView *)titleV backGroundColor:(UIColor *)color backGroundImage:(NSString *)image{
    if(titleV){
        self.navigationItem.titleView = titleV;
    }else{
        self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.bounds.size.width-140, 44)];
    }
    if (title.length) {
        CAGradientLayer* gradientMask = [CAGradientLayer layer];
        gradientMask.bounds = self.navigationItem.titleView.layer.bounds;
        gradientMask.position = CGPointMake([self.navigationItem.titleView bounds].size.width / 2, [self.navigationItem.titleView bounds].size.height / 2);
        NSObject *transparent = (NSObject*) [[UIColor clearColor] CGColor];
        NSObject *opaque = (NSObject*) [[UIColor blackColor] CGColor];
        gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(self.navigationItem.titleView.frame));
        gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(self.navigationItem.titleView.frame));
        float fadePoint = (float)10/self.navigationItem.titleView.frame.size.width;
        [gradientMask setColors: [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil]];
        [gradientMask setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:fadePoint],[NSNumber numberWithFloat:1-fadePoint],[NSNumber numberWithFloat:1.0],nil]];
        self.navigationItem.titleView.layer.mask = gradientMask;

        UILabel *label = [[UILabel alloc] initWithFrame:self.navigationItem.titleView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor  = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0, 0);
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:label];
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        if (label.frame.size.width<size.width) {
            label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, label.frame.size.height);
            [self performSelector:@selector(startScrollAnimateWithLabel:) withObject:label afterDelay:3.0];
        }
    }
    if(image.length){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:image] forBarMetrics:UIBarMetricsDefault];
    }
    if(color){
//         [self.navigationController.navigationBar setBackgroundImage:[[Utility Share]imageFromColor:color size:CGSizeMake(APPW, 64)] forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.backgroundColor = color;
    }
}

-(void)startScrollAnimateWithLabel:(UILabel*)label{
    CGRect frame=label.frame;
    UIView *nBGv=self.navigationItem.titleView;
    [UIView animateWithDuration:5.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        label.frame = CGRectMake(-frame.size.width, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
    } completion:^(BOOL finished) {
        [self EntertainingDiversionsAnimation:10.8 aView:label supView:nBGv];
    }];
}
-(void)EntertainingDiversionsAnimation:(NSTimeInterval)interval aView:(UIView *)av supView:(UIView *)sv{
    CGRect frame =av.frame;
    av.frame=CGRectMake(av.frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    [UIView animateWithDuration:interval delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
         av.frame = frame;
     }completion:^(BOOL finished) {
     }];
}
#pragma mark - Methods
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info{
    return [self pushController:controller withInfo:info withTitle:nil withOther:nil tabBarHidden:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title{
    return [self pushController:controller withInfo:info withTitle:title withOther:nil tabBarHidden:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other{
   return [self pushController:controller withInfo:info withTitle:title withOther:other tabBarHidden:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHidden:(BOOL)abool{
    NSLog(@"\n跳转到 %@ 类",NSStringFromClass(controller));
    return [self pushController:[[controller alloc]init] withInfo:info withTitle:title withOther:other tabBarHid:abool];
}
- (BaseViewController*)pushController:(BaseViewController*)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHid:(BOOL)abool{
    NSLog(@"\n跳转到 %@ 页面\nBase UserInfo:%@\nBase OtherInfo:%@",title,info,other);
    if ([(NSObject*)controller respondsToSelector:@selector(setUserInfo:)]) {
        controller.userInfo = info;
        controller.otherInfo = other;
    }
    controller.title = title;
    controller.hidesBottomBarWhenPushed=abool;
    [self.navigationController pushViewController:controller animated:YES];
    return controller;
}
- (void)popToControllerNamed:(NSString*)controller{
    Class cls = NSClassFromString(controller);
    if ([cls isSubclassOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:(UIViewController*)cls animated:YES];
    }else{
        NSLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popToTheControllerNamed:(id)controller{
    if ([controller isKindOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];
    }else{
        NSLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popToControllerNamed:(NSString*)controllerstr withSel:(SEL)sel withObj:(id)info{
    NSLog(@"\n返回到 %@ 页面",controllerstr);
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSLog(@"\nBase UserInfo:%@",info);
    }
    for (id controller in self.navigationController.viewControllers) {
        if ([NSStringFromClass([controller class]) isEqualToString:controllerstr]) {
            if ([(NSObject*)controller respondsToSelector:sel]) {
                [controller performSelector:sel withObject:info afterDelay:0.01];
            }
            [self popToTheControllerNamed:controller];
            break;
        }
    }
}
/**
 *	根据文字计算Label高度
 *	@param	_width	限制宽度
 *	@param	_font	字体
 *	@param	_text	文字内容
 *	@param	_aLine	文字内容换行行间距
 *	@return	Label高度
 */
- (CGFloat)heightForLabel:(CGFloat)_width font:(UIFont*)_font text:(NSString*)_text lineSpace:(CGFloat)_aLine{
    if (!self.sizeLabel) {
        self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    }
    self.sizeLabel.numberOfLines = 0;
    self.sizeLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    [self.sizeLabel setLineBreakMode:NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping];
    self.sizeLabel.font = _font;
    if (_text) {
        self.sizeLabel.text = _text;
        if (_aLine) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_text];
            NSMutableParagraphStyle *paragraphStyleT = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyleT setLineSpacing:_aLine];//调整行间距
            paragraphStyleT.lineBreakMode = NSLineBreakByWordWrapping;
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleT range:NSMakeRange(0, [_text length])];
            self.sizeLabel.attributedText = attributedString;
        }
        return [self.sizeLabel sizeThatFits:CGSizeMake(_width, MAXFLOAT)].height;
    }else{
        return 0;
    }
}
- (CGFloat)heightForTextView:(CGFloat)_width font:(UIFont*)_font text:(NSString*)_text lineSpace:(CGFloat)_aLine{
    if (!self.sizeTextView) {
        self.sizeTextView = [[UITextView alloc] init];
    }
    [self.sizeTextView setEditable:NO];
    self.sizeTextView.frame=CGRectMake(0,0, _width, 20);
    self.sizeTextView.font = _font;
    if (_text) {
        self.sizeTextView.text = _text;
        if (_aLine) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing = _aLine;
            NSDictionary *attributes = @{ NSFontAttributeName:_font, NSParagraphStyleAttributeName:paragraphStyle};
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            self.sizeTextView.attributedText =[[NSAttributedString alloc]initWithString:_text attributes:attributes];
             if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
                CGSize size = [_text boundingRectWithSize:CGSizeMake(_width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
                NSLog(@"TextView的高度:%f",size.height);
                return  size.height;
            }else{
                return self.sizeTextView.contentSize.height-16;
            }
        }
        return [self.sizeTextView sizeThatFits:CGSizeMake(_width, MAXFLOAT)].height;
    }else{
        return 0;
    }
}
#pragma mark - Actions
- (void)backToHomeViewController{
    NSArray *controllers = [(UITabBarController*)[(UIWindow*)[[UIApplication sharedApplication] windows][0] rootViewController] viewControllers];//首页的controllers
    if([controllers[0] navigationController]){
        [[controllers[0] navigationController]popToRootViewControllerAnimated:YES];//回到首页
    }else{
        [controllers[0] dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)goback{
    [SVProgressHUD dismiss];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark UItableViewDelegagte
- (void)fillTheTableDataWithHeadV:(UIView*)head footV:(UIView*)foot canMove:(BOOL)move canEdit:(BOOL)edit headH:(CGFloat)headH footH:(CGFloat)footH rowH:(CGFloat)rowH sectionN:(NSInteger)sectionN rowN:(NSInteger)rowN cellName:(NSString *)cell{
    self.tableView.tableHeaderView = head;
    self.tableView.tableFooterView = foot;
    self.tableView.canMoveRow = move;
    self.tableView.canEditRow = edit;
    self.tableView.headH = headH;
    self.tableView.footH = footH;
    self.tableView.rowH = rowH;
    self.tableView.sectionN = sectionN;
    self.tableView.rowN = rowN;
    self.tableView.cell = [NSClassFromString(cell) getInstance];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.rowH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.tableView.headH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.tableView.footH;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableView.sectionN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableView.rowN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.tableView.cell){
        self.tableView.cell = [BaseTableViewCell getInstance];
    }
    [self.tableView.cell  setDataWithDict:self.tableView.dataArray[indexPath.row]];
    return self.tableView.cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableView.tableHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.tableView.tableFooterView;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.canEditRow;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.canMoveRow;
}

#pragma mark  子类重写
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"请子类重写这个方法");
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"请子类重写这个方法");return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSLog(@"请子类重写这个方法");return nil;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.tableView.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    // 2 添加一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        [self.tableView.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    topRowAction.backgroundColor = [UIColor lightGrayColor];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction,topRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return UITableViewCellEditingStyleDelete;
    //return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView.dataArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.tableView.dataArray addObject:self.tableView.dataArray[indexPath.row]];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSLog(@"请子类重写这个方法");
    [self.tableView.dataArray removeObjectAtIndex:sourceIndexPath.row];
    [self.tableView.dataArray insertObject:self.tableView.dataArray[sourceIndexPath.row] atIndex:destinationIndexPath.row];
}
#pragma mark UICollectionViewDelegate
-(void)fillTheCollectionViewDataWithCanMove:(BOOL)move sectionN:(NSInteger)sectionN itemN:(NSInteger)itemN itemName:(NSString *)item{
    self.collectionView.canMoveRow = move;
    self.collectionView.sectionN = sectionN;
    self.collectionView.itemN = itemN;
    [self.collectionView registerClass:NSClassFromString(item) forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@Identifier",item]];
    self.collectionReuseId = [NSString stringWithFormat:@"%@Identifier",item];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectionView.sectionN;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionView.itemN;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    self.collectionView.cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.collectionReuseId forIndexPath:indexPath];
    [self.collectionView.cell  setCollectionDataWithDic:self.collectionView.dataArray[indexPath.row]];
    return self.collectionView.cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.collectionView.canMoveRow;
}

//子类重写
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      NSLog(@"请子类重写这个方法");
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
      NSLog(@"请子类重写这个方法");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
