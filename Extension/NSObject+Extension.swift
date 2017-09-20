
//
//  NSObject+Extension.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation

// MARK: - NSObject
extension NSObject
{
    
    
    func performSelectorOnMainThread(selector aSelector: Selector,withObject object:AnyObject! ,waitUntilDone wait:Bool)
    {
        if self.responds(to: aSelector)
        {
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
            
            if wait
            {
                let ret = RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Foundation.Date.distantFuture )
                while (!continuego && ret)
                {
                    
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
            
        }catch
        {
            return nil
        }
    }
    
    fileprivate class func dataToJson(_ data: Data) -> AnyObject? {
        
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return json as AnyObject?
            
        }
        catch
        {
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

    
}


