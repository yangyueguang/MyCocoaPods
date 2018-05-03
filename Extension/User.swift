//
//  User.swift
import UIKit
///FIXME:用户信息
class User: NSObject {///账号
    var account:String?///ID
    var Id:String?///用户名
    var name:String?///密码
    var pwd:String?///真实姓名
    var realName:String?///头像
    var logo:String?///口令
    var token:String?///经度
    var longitude:Double?///维度
    var latitude:String?///用户级别
    var type:String?///用户签名
    var sign:String?///用户金额
    var mony:String?///用户状态
    var status:String?///用户银行卡号
    var cards:String?///手机号
    var phone:String?///身份证号
    var idcard:String?///微信号
    var wechartnum:String?///QQ号
    var QQnumber:String?///性别
    var sex:String?///年龄
    var age:String?///账号保护
    var protect:String?///邮箱
    var email:String?///登录设备
    var devices:String?///手机系统
    var system:String?///手机登录的IP地址
    var IP:String?///地址
    var address:String?///国家
    var country:String?///省
    var province:String?///市
    var city:String?///县
    var area:String?///街道
    var street:String?///语言
    var language:String?
    override init() {
        super.init()
    }
    convenience init(name:String,pwd:String="",account:String?,token:String="") {
        self.init()
        self.name = name
        self.pwd = pwd
        self.account = account
    }
}
