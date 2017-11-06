/**
 @@create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 @return MXWechatSignAdaptor（微信签名工具类）
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MXWechatSignAdaptor : NSObject

@property (nonatomic,strong) NSMutableDictionary *dic;

- (instancetype)initWithWechatAppId:(NSString *)wechatAppId
                        wechatMCHId:(NSString *)wechatMCHId
                            tradeNo:(NSString *)tradeNo
                   wechatPartnerKey:(NSString *)wechatPartnerKey
                           payTitle:(NSString *)payTitle
                           orderNo :(NSString *)orderNo
                           totalFee:(NSString *)totalFee
                           deviceIp:(NSString *)deviceIp
                          notifyUrl:(NSString *)notifyUrl
                          tradeType:(NSString *)tradeType;

///创建发起支付时的SIGN签名(二次签名)
- (NSString *)createMD5SingForPay:(NSString *)appid_key
                        partnerid:(NSString *)partnerid_key
                         prepayid:(NSString *)prepayid_key
                          package:(NSString *)package_key
                         noncestr:(NSString *)noncestr_key
                        timestamp:(UInt32)timestamp_key;

//自己写的QQ钱包接入
-(instancetype)initWithQQWalletappid:(NSString *)appid
                              mch_id:(NSString *)mch_id
                           nonce_str:(NSString *)nonce_str
                                body:(NSString *)body
                        out_trade_no:(NSString *)out_trade_no
                           fee_type :(NSString *)fee_type
                           total_fee:(NSString *)total_fee
                    spbill_create_ip:(NSString *)spbill_create_ip
                          trade_type:(NSString *)trade_type
                          notify_url:(NSString *)notify_url
                              appkey:(NSString*)appkey;
@end
