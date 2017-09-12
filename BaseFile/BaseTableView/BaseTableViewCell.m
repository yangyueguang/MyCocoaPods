//
//  BaseTableViewCell.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell
#pragma mark 初始化
///单例初始化，兼容nib创建
+(id) getInstance {
    BaseTableViewCell *instance = nil;
    @try {
        NSString *nibFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.nib",NSStringFromClass(self)]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:nibFilePath]) {
            id o = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
            if ([o isKindOfClass:self]) {
                instance = o;
            } else {
                instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
            }
        } else {
            instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
        }
    }
    @catch (NSException *exception) {
        instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
    }
    return instance;
}
+(NSString*) getTableCellIdentifier {
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)init {
    self = [super init];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(void)loadBaseTableCellSubviews{
    [self registerForKVO];
    [self initUI];
    [self loadSubViews];
}
-(void)loadSubViews {
    if (self.contentView) {
        for (id obj in [self subviews]) {
            if ([@"UITableViewCellScrollView" isEqualToString:NSStringFromClass([obj class])]) {
//                UITableViewCell—>UITableViewCellScrollView—>UITableCellContentView
//                cell.contentView.superview 获得。
                UIScrollView *scrollView = (UIScrollView*)obj;
                [scrollView setDelaysContentTouches:NO];//是否先等待一会儿看scrollview 是否有touch 事件发生
                [scrollView setExclusiveTouch:YES];//避免两个对象同时被触发
                break;
            }
        }
        [self setUserInteractionEnabled:YES];
        [self.contentView setUserInteractionEnabled:YES];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}
#pragma mark KVO
- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}
- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}
#pragma mark 以下子类重写
-(void)initUI{
    self.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.icon =[[UIImageView alloc]init];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]init];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = [UIFont systemFontOfSize:13];
    self.script.textColor = self.title.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
    self.line = [[UIView alloc]init];
//    [self addSubviews:self.icon,self.title,self.script,self.line,nil];
    NSLog(@"请子类重写这个方法");

}
-(void)setDataWithDict:(NSDictionary *)dict{
    NSLog(@"请子类重写这个方法");
}
- (NSArray *)observableKeypaths {
   NSLog(@"请子类重写这个方法"); return nil;
}
- (void)updateUIForKeypath:(NSString *)keyPath {
    NSLog(@"请子类重写这个方法");
}

-(void)prepareForReuse {
    [super prepareForReuse];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)dealloc {
    [self unregisterFromKVO];
    [self deallocTableCell];
}
-(void) deallocTableCell {
    NSLog(@"请子类重写这个方法");
}
@end
