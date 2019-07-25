//
//  Fifo.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

/**
 * Note : This is inspired by :
 * https://github.com/raywenderlich/swift-algorithm-club/tree/master/Queue
 */

public class Fifo<T> {
    fileprivate var mArray = [T]()
    fileprivate var mCapacity: Int
    fileprivate var mSerialQueue: DispatchQueue
    
    public init(_ pCapacity: Int, pQoS: DispatchQoS = .default) {
        mCapacity = pCapacity
        mSerialQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".fifo", qos: pQoS, attributes: .concurrent)
    }
    
    public var isEmpty: Bool {
        return mSerialQueue.sync {
            mArray.isEmpty
        }
    }
    
    public var count: Int {
        return mSerialQueue.sync {
            mArray.count
        }
    }
    
    /* this function allows the user to take a peak at the first element */
    public var front: T? {
        return mSerialQueue.sync {
            mArray.first
        }
    }
    
    public func put(_ pElement: T) -> Bool {
        return mSerialQueue.sync(flags: .barrier) {
            if(mCapacity == mArray.count) {
                return false /* FIFO is full ! */
            } else {
                mArray.append(pElement)
                return true
            }
        }
    }
    
    public func get() -> T? {
        return mSerialQueue.sync(flags: .barrier) {
            if(mArray.isEmpty) {
                return nil
            } else {
                return mArray.removeFirst()
            }
        }
    }
}
