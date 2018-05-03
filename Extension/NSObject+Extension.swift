
//
//  NSObject+Extension.swift
//  project
import Foundation
// MARK: - NSObject
extension NSObject{
    func performSelectorOnMainThread(selector aSelector: Selector,withObject object:AnyObject! ,waitUntilDone wait:Bool){
        if self.responds(to: aSelector){
            var continuego = false
            let group = DispatchGroup()
            let queue = DispatchQueue(label: "com.fsh.dispatch", attributes: [])
            queue.async(group: group,execute: {
                queue.async(execute: {
                    //做了个假的
                    Thread.detachNewThreadSelector(aSelector, toTarget:self, with: object)
                    continuego = true
                })
            })
//            group.wait(timeout: DispatchTime.distantFuture)
            if wait{
                let ret = RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Foundation.Date.distantFuture )
                while (!continuego && ret){
                }
            }
        }
    }
    class func clearCache() {
        let domain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: domain!)
    }
    fileprivate class func jsonToData(_ jsonResponse: AnyObject) -> Data? {
        do{
            let data = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
            return data;
        }catch{
            return nil
        }
    }
    fileprivate class func dataToJson(_ data: Data) -> AnyObject? {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return json as AnyObject?
            
        }catch{
            return nil
        }
    }
    ///将NSArray或者NSDictionary转化为NSString
    func jsonString() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self){
            return String(data: data, encoding: .utf8)!
        }
        return ""
    }
    func tojsonstring() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self) {
            return String(data: data, encoding: String.Encoding.utf8)!
        }
        return ""
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
    @objc
    func printPropertys(object:Any,_ oc:Bool)->Void{
        if oc{
            print("@interface Model : NSObject")
        }else{
            print("@objcMembers\nclass BCustomADMode: RLMObject {///")
        }
        if object is NSArray{
            printArray(object as! [Any], oc: oc)
        }else if object is NSDictionary{
            printDict(object as! [AnyHashable:Any], oc: oc)
        }
        if oc{
            print("@end\n@implementation Model\n@end")
        }else{
            print("}")
        }
    }
    func printDict(_ dict:[AnyHashable:Any],oc:Bool){
        for (key,value) in dict{
            let s = getType(value: value)
            if oc{
                print("@property(nonatomic,copy)\(s) *\(key);")
            }else{
                print("@objc dynamic var \(key):\(s)?///")
            }
            if value is NSDictionary{
                printDict(value as! [AnyHashable:Any], oc: oc)
            }else if value is NSArray{
                printArray(value as! [Any], oc: oc)
            }
        }
    }
    func printArray(_ array:[Any],oc:Bool){
        if let value = array.first{
            let s = getType(value: value)
            if oc{
                print("@property(nonatomic,copy)\(s) *\(value);")
            }else{
                print("@objc dynamic var \(value):\(s)?///")
            }
            if value is NSDictionary{
                printDict(value as! [AnyHashable:Any], oc: oc)
            }else if value is NSArray{
                printArray(value as! [Any], oc: oc)
            }
        }
    }
    func getType(value:Any)->String{
        var s = "unknown"
        switch value{
        case is String:s = "String";break;
        case is NSNumber:s = "NSNumber";break;
        case is Double:s = "Double";break;
        case is Float:s = "Float";break;
        case is Int32:s = "Int32";break;
        case is UInt:s = "UInt";break;
        case is Bool:s = "Bool";break;
        case is NSDictionary:s = "Dictionary";break;
        case is NSArray:s = "Array";break;
        case is NSObject:s = "NSObject";break;
        default:break;
        }
        return s
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
    func notEmptyPercent(_ item:Any)->String{
        if item is NSNumber{
            let decimal = NSDecimalNumber(string: String(format: "%lf",(item as! NSNumber).doubleValue))
            return String(format: "%@%%", decimal)
        }else if item is NSNull{
            return ""
        }else if item is String{
            let ss = item as! String
            if ss == "--" {
                return ss
            }else if ss == ""{
                return "-"
            }else{
                return ss.appending("%")
            }
        }else{
            return String.init(describing: item)
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
}
