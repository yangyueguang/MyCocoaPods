
//
//  NSObject+Extension.swift
//  project
import Foundation
// MARK: - NSObject
public extension NSObject{
    func performSelectorOnMainThread(selector aSelector: Selector,withObject object:AnyObject! ,waitUntilDone wait:Bool = false){
        if self.responds(to: aSelector){
            var continuego = false
            let group = DispatchGroup()
            let queue = DispatchQueue(label: "com.fsh.dispatch", attributes: [])
            queue.async(group: group,execute: {
                queue.async(execute: {
                    Thread.detachNewThreadSelector(aSelector, toTarget:self, with: object)
                    continuego = true
                })
            })
            if wait{
                let ret = RunLoop.current.run(mode: RunLoop.Mode.default, before: Foundation.Date.distantFuture )
                while (!continuego && ret){
                }
            }
        }
    }
    class func clearCache() {
        let domain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: domain!)
    }
    class func jsonToData(_ jsonResponse: AnyObject) -> Data? {
        do{
            let data = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
            return data;
        }catch{
            return nil
        }
    }
    class func dataToJson(_ data: Data) -> AnyObject? {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return json as AnyObject?
            
        }catch{
            return nil
        }
    }
    //  哪个类调用，就返回哪个类的对象数组对应的json数组。
    class func jsonArray(withObjectArray objectArray: [Any]) -> [Any] {
        var jsonObjects = [Any]()
        for model in objectArray {
            let jsonDict: [AnyHashable: Any] = (model as AnyObject).dictionaryRepresentation()
            jsonObjects.append(jsonDict)
        }
        return jsonObjects
    }


    func notEmpty(_ item:Any)->String{
        if item is NSNull{
            return "-"
        }else if item is String{
            var ss = String(describing:item)
            if ss == ""{
                ss = "-"
            }
            return ss
        }else if item is NSNumber{
            return String(describing:item)
        }else{
            return "-"
        }
    }

    func decimalNumber(_ s:Any)->NSDecimalNumber{
        if s is String{
            let ss:NSString = s as! NSString
            let doubleValue = (ss.replacingOccurrences(of:",", with: "") as NSString).doubleValue
            return NSDecimalNumber(value: doubleValue)
        }else if s is NSNumber{
            return NSDecimalNumber(value: (s as! NSNumber).doubleValue)
        }else{
            return NSDecimalNumber(value:0.0)
        }
    }

    /// 打印字典转换的模型
    public func jsonToModelPrint(_ dict:[String:Any], name:String, space: String = ""){
        let getType = {(value:Any) -> String? in
            var s: String?
            switch value{
            case is Bool:s = "Bool"
            case is String:s = "String"
            case is Int:s = "Int"
            case is NSNumber:s = "Double"
            case is NSNull:s = "NSNull"
            default:break
            }
            return s
        }
        let firstUppercase = {(name: String) -> String in
            return name.prefix(1).uppercased() + name.suffix(from: name.index(name.startIndex, offsetBy: 1))
        }

        func printArray(_ value:Any, key: String, space: String) {
            if value is NSDictionary{
                jsonToModelPrint(value as! [String:Any],name:firstUppercase(key), space: space)
            }else if value is NSArray{
                printArray((value as! [Any]).first ?? "", key: firstUppercase(key), space: space)
            }else{
            }
        }

        print("\n\(space)@objcMembers\n\(space)class \(firstUppercase(name)): NSObject {")
        let newspace = space.compactMap({ return "\($0)" }).reduce("\t") { $0 + $1 }
        for (key,value) in dict{
            if value is NSDictionary{
                print("\(newspace)var \(key): \(getType(value) ?? firstUppercase(key))?")
                jsonToModelPrint(value as! [String:Any],name:key, space: newspace + "\t")
            }else if value is NSArray{
                let value = (value as! NSArray).firstObject ?? ""
                print("\(newspace)var \(key): [\(getType(value) ?? firstUppercase(key))] = []")
                printArray(value, key: key, space: newspace + "\t")
            }else{
                print("\(newspace)var \(key): \(getType(value) ?? firstUppercase(key))\(value is NSNumber ? " = 0" : "?")")
            }
        }
        print("\(space)}")
    }


}
