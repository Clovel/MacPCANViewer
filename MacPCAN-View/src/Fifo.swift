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
    
    public init(_ pCapacity: Int) {
        mCapacity = pCapacity
    }
    
    public var isEmpty: Bool {
        return mArray.isEmpty
    }
    
    public var count: Int {
        return mArray.count
    }
    
    /* this function allows the user to take a peak at the first element */
    public var front: T? {
        return mArray.first
    }
    
    public func put(_ pElement: T) -> Bool {
        if(mCapacity == count) {
            return false /* FIFO is full ! */
        } else {
            mArray.append(pElement)
            return true
        }
    }
    
    public func get() -> T? {
        if(isEmpty) {
            return nil
        } else {
            return mArray.removeFirst()
        }
    }
}
