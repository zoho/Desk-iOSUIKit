//
//  CacheExtension.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 28/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit

internal class ZDCacheManager {
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    static let shared = ZDCacheManager()
    
    open func save(_ record: ZDCacheRecord) {
        self.cache.setObject(record, forKey: record.key as AnyObject);
    }
    
    open func saveObject(_ object: AnyObject?,forKey key: String, forMinutes minutes: Int) {
        let record = ZDCacheRecord(object: object, key: key, minutes: minutes);
        self.save(record);
    }
    
    open func fetchObject<T>(forKey key: String) -> T? {
        return self.fetch(forKey: key)?.object as? T;
    }
    
    open func fetch(forKey key: String) -> ZDCacheRecord? {
        
        guard let record = self.cache.object(forKey: key as AnyObject) as? ZDCacheRecord else {
            return nil;
        }
        if record.cachedDateTime.addMinutes(record.cacheMinutes).isGreaterThanDate(Date()) {
            return record;
        }
        else {
            self.cache.removeObject(forKey: key as AnyObject);
            return nil;
        }
    }
}

internal class ZDCacheRecord {
    open var key: String!;
    open var object: AnyObject? = nil;
    fileprivate var cachedDateTime: Date!;
    open var cacheMinutes: Int = 30;
    
    convenience init(object: AnyObject?,key: String,minutes: Int) {
        self.init();
        self.object = object;
        self.key = key;
        self.cacheMinutes = minutes;
    }
    
    init() {
        self.cachedDateTime = Date();
    }
}
