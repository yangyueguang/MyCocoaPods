//
//  NSObject+Mirror.swift
//  SOKit
//
//  Created by Chao Xue 薛超 on 2018/10/30.
//  Copyright © 2018年 Xuechao. All rights reserved.
//  给NSObject添加字典模型转换功能的扩展

import Foundation
// 字段类型模型
class NSObjectType {
    var isArray: Bool = false
    var isNSObject:Bool = false
    var isOptional: Bool = false
    var realType: RealType = .Class
    var typeName: String!
    var typeClass: Any.Type!
    var belongType: Any.Type = Any.self
    var propertyMirrorType: Mirror

    init(propertyMirrorType: Mirror, belongType: Any.Type){
        self.propertyMirrorType = propertyMirrorType
        self.belongType = belongType
        parseBegin()
    }
    func parseBegin(){
        typeName = "\(propertyMirrorType.subjectType)".replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
        typeClass = propertyMirrorType.subjectType
        guard propertyMirrorType.displayStyle != nil else { return }
        realType = RealType.getTypeFromTypeName(typeName)
        isArray = typeName.contains("Array")
        let sdkTypes = ["__NSCFNumber", "NSNumber", "_NSContiguousString", "UIImage", "_NSZeroData"]
        isNSObject = RealType.Class == realType && !sdkTypes.contains(typeName)
        isOptional = propertyMirrorType.displayStyle == Mirror.DisplayStyle.optional
    }

    enum RealType: String{
        case Int = "Int"
        case Bool = "Bool"
        case Float = "Float"
        case Double = "Double"
        case String = "String"
        case NSNumber = "NSNumber"
        case Class = "Class"
        static func getTypeFromTypeName(_ name:String) -> RealType {
            var realType = RealType.Class
            if name.contains("Int") {realType = RealType.Int}
            else if name.contains("Bool") {realType = RealType.Bool}
            else if name.contains("Float") {realType = RealType.Float}
            else if name.contains("Double") {realType = RealType.Double}
            else if name.contains("String") {realType = RealType.String}
            else if name.contains("NSNumber") {realType = RealType.NSNumber}
            return realType
        }
    }
}

extension NSObject{
    // 解析结束
    @objc func parseOver(){}
    // 字段替换
    @objc func mappingDict() -> [String: String]? {return nil}
    // 解析的时候忽略的字段
    @objc func ignoreProperties() -> [String]? {return nil}
//  func setValue(_ value: Any?, forUndefinedKey key: String) {}

    /// 模型转字典
    func toDict() -> [String: Any]{
        var dict: [String: Any] = [:]
        self.properties { (name, type, value) -> Void in
            if type.isNSObject {
                if type.isArray {
                    var dictM: [[String: Any]] = []
                    let modelArr = value as! NSArray
                    for item in  modelArr {
                        let dict = (item as! NSObject).toDict()
                        dictM.append(dict)
                    }
                    dict[name] = dictM
                }else{
                    dict[name] = type.isOptional ? (value as? NSObject)?.toDict() : (value as! NSObject).toDict()
                }
            }else{
                dict[name] = "\(value)".replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: "")
            }
        }
        return dict
    }

    /// 数组转模型对象数组
    class func parses(array: [Any]) -> [NSObject]{
        var models: [NSObject] = []
        for (_ , dict) in array.enumerated(){
            let model = self.parse(dict: dict as! NSDictionary)
            models.append(model)
        }
        return models
    }

    /// 字典转模型
    class func parse(dict: NSDictionary) -> Self{
        let model = self.init()
        let mappingDict = model.mappingDict()
        let ignoreProperties = model.ignoreProperties()
        model.properties { (name, type, value) -> Void in
            let dataDictHasKey = dict[name] != nil
            let mappdictDictHasKey = mappingDict?[name] != nil
            let needIgnore = ignoreProperties == nil ? false : (ignoreProperties!).contains(name)
            if (dataDictHasKey || mappdictDictHasKey) && !needIgnore {
                let key = mappdictDictHasKey ? mappingDict![name]! : name
                if !type.isArray {
                    if type.isNSObject { //这里是模型
                        let dictValue = dict[key]
                        guard dictValue != nil else { return } //保证字典中有模型
                        let modelValue = model.value(forKeyPath: key)
                        if modelValue != nil { //子模型已经初始化
                            model.setValue((type.typeClass as! NSObject.Type).parse(dict: dict[key] as! NSDictionary), forKeyPath: name)
                        }else{ //子模型没有初始化
                            let cls = getObjectWithName(type.typeName ?? "")
                            model.setValue(cls?.parse(dict: dict[key] as? NSDictionary ?? [:]), forKeyPath: name)
                        }
                    }else{
                        switch type.realType {
                        case .Bool:
                            model.setValue((dict[key] as AnyObject).boolValue, forKeyPath: name)
                        case .Int:
                            guard ((dict[key] as? Int) != nil) && !type.isOptional else { return }
                            model.setValue(dict[key], forKeyPath: name)
                        case .Float:
                            guard ((dict[key] as? Float) != nil) && !type.isOptional else { return }
                            model.setValue(dict[key], forKeyPath: name)
                        case .Double:
                            guard ((dict[key] as? Double) != nil) && !type.isOptional else { return }
                            model.setValue(dict[key], forKeyPath: name)
                        case .String:
                            model.setValue("\(dict[key] == nil ? "" : dict[key]!)", forKeyPath: name)
                        default:
                            model.setValue(dict[key], forKeyPath: name)
                        }
                    }
                }else{
                    switch type.realType {
                    case .Int:
                        var arrAggregate: [Int] = []
                        arrAggregate = parseAggregateArray(arrDict: dict[key] as! NSArray)
                        model.setValue(arrAggregate, forKeyPath: name)
                    case .Float:
                        var arrAggregate: [Float] = []
                        arrAggregate = parseAggregateArray(arrDict: dict[key] as! NSArray)
                        model.setValue(arrAggregate, forKeyPath: name)
                    case .Double:
                        var arrAggregate: [Double] = []
                        arrAggregate = parseAggregateArray(arrDict: dict[key] as! NSArray)
                        model.setValue(arrAggregate, forKeyPath: name)
                    case .String:
                        var arrAggregate: [String] = []
                        arrAggregate = parseAggregateArray(arrDict: dict[key] as! NSArray)
                        model.setValue(arrAggregate, forKeyPath: name)
                    case .NSNumber:
                        var arrAggregate: [NSNumber] = []
                        arrAggregate = parseAggregateArray(arrDict: dict[key] as! NSArray)
                        model.setValue(arrAggregate, forKeyPath: name)
                    case .Bool:
                        var arrAggregate: [AnyObject] = []
                        arrAggregate = parseAggregateArray(arrDict: dict[key] as! NSArray)
                        model.setValue(arrAggregate, forKeyPath: name)
                    default:
                        let clsString = type.typeName.replacingOccurrences(of: "Array<", with: "")
                            .replacingOccurrences(of: "Optional<", with: "")
                            .replacingOccurrences(of: ">", with: "")
                            .replacingOccurrences(of: "ImplicitlyUnwrapped", with: "")
                        var cls  = getObjectWithName(clsString)
                        if cls == nil && type.isNSObject {
                            let nameSpaceString = "\(type.belongType).\(clsString)"
                            cls = getObjectWithName(nameSpaceString)
                        }
                        let dictKeyArr = dict[key] as! NSArray
                        var arrM: [NSObject] = []
                        for (_, value) in dictKeyArr.enumerated() {
                            let elementModel = cls?.parse(dict: value as! NSDictionary)
                            arrM.append(elementModel ?? NSObject())
                        }
                        model.setValue(arrM, forKeyPath: name)
                    }
                }
            }
        }
        model.parseOver()
        return model
    }

    var description1: String {
        let pointAddr = NSString(format: "%p",unsafeBitCast(self, to: Int.self)) as String
        var printStr = "\(type(of: self))" + " <\(pointAddr)>: " + "\r{"
        self.properties { (name, type, value) -> Void in
            printStr += type.isArray ? "\r\r['\(name)']: \(value)" : "\r\(name): \(value)"
        }
        printStr += "\r}"
        return printStr
    }
    /// 是否打开点击效果，默认是打开
    private var mirror: Mirror {
        set { }
        get { return {Mirror(reflecting: self)}() }
    }

    // 遍历对象属性
    func properties(property: (_ name: String, _ type: NSObjectType, _ value: Any) -> Void){
        for p in mirror.children {
            let objType = NSObjectType(propertyMirrorType: Mirror(reflecting: p.value), belongType: type(of: self))
            property(p.label!, objType, p.value)
        }
    }

    /// 存储对象
    class func save(obj: NSObject?, name: String, duration: TimeInterval = 7 * 24 * 60 * 60) {
        UserDefaults.standard.set(NSDate().timeIntervalSince1970, forKey: name)
        UserDefaults.standard.set(duration, forKey: name + "Duration")
        let path = NSObject.cachesFolder! + "/" + name + ".arc"
        if obj != nil {
            NSKeyedArchiver.archiveRootObject(obj!.toDict(), toFile: path)
        }else{
            let fm = FileManager.default
            if fm.fileExists(atPath: path) {
                if fm.isDeletableFile(atPath: path){
                    do {
                        try fm.removeItem(atPath: path)
                    }catch {}
                }
            }
        }
    }

    /// 删除缓存中的某个存储
    class func deleteNSObjectModel(name: String){save(obj: nil, name: name, duration: 0)}

    /// 读取缓存中的某个对象
    class func read(name: String) -> NSObject? {
        let time = UserDefaults.standard.double(forKey: name)
        let duration = UserDefaults.standard.double(forKey: name + "Duration")
        let now = NSDate().timeIntervalSince1970
        guard now <= time + duration else { return nil }
        let path = NSObject.cachesFolder! + "/" + name + ".arc"
        let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? NSDictionary
        return self.parse(dict: unarchivedDictionary ?? [:])
    }
    private static var cachesFolder: String? {
        let cacheRootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let cache_NSObject_path = cacheRootPath! + "/" + "NSObject"
        let fm = FileManager.default
        let existed = fm.fileExists(atPath: cache_NSObject_path)
        guard !existed else { return cache_NSObject_path }
        do {
            try fm.createDirectory(atPath: cache_NSObject_path, withIntermediateDirectories: true, attributes: nil)
        }catch {}
        return cache_NSObject_path
    }

    // 范型解析 arrDict 数组源
    class func parseAggregateArray<T>(arrDict: NSArray) -> [T]{
        var intArrM: [T] = []
        if arrDict.count == 0 {return intArrM}
        for (_, value) in arrDict.enumerated() {
            var element: T!
            let v = NSString(string: "\(value)")
            if T.self is Int.Type { element = Int(v.floatValue) as? T }
            else if T.self is Float.Type {element = v.floatValue as? T}
            else if T.self is Double.Type {element = v.doubleValue as? T}
            else if T.self is NSNumber.Type {element = NSNumber(value: v.doubleValue) as? T}
            else if T.self is String.Type {element = v as? T}
            else {element = value as? T}
            intArrM.append(element)
        }
        return intArrM
    }

    private static func getObjectWithName(_ name: String) -> NSObject.Type?{
        guard var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return nil }
        var name = name
        if appName == "" {appName = ((Bundle.main.bundleIdentifier!).characters.split{$0 == "."}.map { String($0) }).last ?? ""}
        if !name.contains("\(appName)."){ name = appName + "." + name }
        let strArr = name.characters.split(whereSeparator: { (element) -> Bool in
            return element == "."
        }).map { String($0) }
        var className = name
        let num = strArr.count
        if num > 2 || strArr.contains(appName) {
            var nameStringM = "_TtC"
            for _ in 0..<num - 2 { nameStringM += "C" }
            for (_, s): (Int, String) in strArr.enumerated(){
                nameStringM += "\(s.count)\(s)"
            }
            className = nameStringM
        }
        return (NSClassFromString(className) as? NSObject.Type)
    }
}
