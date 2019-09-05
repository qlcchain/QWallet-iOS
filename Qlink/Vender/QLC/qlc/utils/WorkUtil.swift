//
//  WorkUtil.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import TrezorCrytoEd25519

public class WorkUtil : NSObject {
    
    private static let WorkSize:Int = 8
    private static let THRESHOLD:UInt64 = 0xfffffe0000000000
    private static var stopWork = false
    private static var isTimeOut = false
    private static var hasBackResult = false
    private static var startTime:Date?
    private static var endTime:Date?
    
//    private static let ThreadLocalRandom RANDOM = ThreadLocalRandom.current()
    
    /*
    @objc public static func generateWorkOfOperation(hash:String ,handler:@escaping ((String) -> Void)) {
        var workResult = ""
        let count = 2
        let queue = OperationQueue()
        for i in 0..<count {
            print(Date(),"work\(i) = 开始")
            let operation = BlockOperation(block: { [weak queue] in
                workResult = WorkUtil.generateWorkOfSingle(hash: hash, startWork: UInt64(i), offsetWork: UInt64(count))
                if workResult.count > 0 {
                    queue?.cancelAllOperations()
                    handler(workResult)
                }
            })
            queue.addOperation(operation)
        }
        
    }
    
    @objc public static func generateWorkOfSingle(hash:String, startWork:UInt64, offsetWork:UInt64) -> String {
        stopWork = false
        var workIsValid : Bool = false
        var work:UInt64 = startWork
        while !workIsValid {
            if stopWork == true {
                break
            }
            var source = Bytes()
            let workB = work.toBytes_Little
//            let workB = work.toBytes_Big
            source.append(contentsOf: workB)
            let hashB = hash.hex2Bytes
            source.append(contentsOf: hashB)
            let valueB = Blake2b.hash(outLength: WorkSize, in: source) ?? Bytes(count:WorkSize)
            let value = valueB.bytesToUInt64_Little
//            let valueBReverse = QLCUtil.reverse(bytes: valueB)
//            let value = valueBReverse.bytesToUInt64_Big
            workIsValid = value >= THRESHOLD
            if workIsValid {
                break
            }
            work = work + offsetWork
        }
        if stopWork == true {
            return ""
        }
        stopWork = true
        print(Date(),"startWork:",startWork,"offsetWork:",offsetWork,"work:",work, "开始---结束了")
        
        let workB = work.toBytes_Big
        return workB.toHexString()
//        let workBReverse = QLCUtil.reverse(bytes: workB)
//        return workBReverse.toHexString()
    }
 */
    
    @objc static func getRandomNumFromNeg128ToPos126() -> String { // -128~126
        var source = String()
        for _ in 0..<8 {
            var random = (-128 + (Int(arc4random()) % (126 + 128 + 1)))
//            print("\(random)")
            if random < 0 {
                random = 256 + random
//                print("\(random)")
            }
            var hex = String(random,radix:16)
            if hex.count < 2 { // 自动补0
                hex = "0"+hex
            }
            source.append(hex)
        }
//        print(source)
//        print(source.hex2Bytes)
        return source
    }
    
    @objc public static func generateWorkOfOperationRandom(hash:String ,handler:@escaping ((String,Bool) -> Void)) {
        isTimeOut = false
        hasBackResult = false
        startTime = Date()
//        WorkUtil.startTimer()
        var workResult = ""
        let count = 2
        let queue = OperationQueue()
        for i in 0..<count {
            print(Date(),"work\(i) = 开始")
            let operation = BlockOperation(block: { [weak queue] in
                workResult = WorkUtil.generateWorkOfSingleRandom(hash: hash)
                if isTimeOut == true {
//                    print(Date(),"走timeout \(i)")
                    queue?.cancelAllOperations()
                    if hasBackResult == false {
                        hasBackResult = true
                        handler(workResult,true)
                    }
                }
                if workResult.count > 0 {
//                    print(Date(),"走cancel \(i)")
                    queue?.cancelAllOperations()
                    if hasBackResult == false {
                        hasBackResult = true
                        handler(workResult,false)
                    }
                }
            })
            queue.addOperation(operation)
        }
        
    }
    
    @objc public static func generateWorkOfSingleRandom(hash:String) -> String {
        stopWork = false
        var workIsValid : Bool = false
        var workB:Bytes = Bytes(count: 8)
        while !workIsValid {
            endTime = Date()
            let seconds = startTime!.secondsBetweenDate(toDate: endTime!)
            if seconds >= 30 {
                isTimeOut = true
                stopWork = true
            }
            if stopWork == true {
                break
            }
            let workHex = WorkUtil.getRandomNumFromNeg128ToPos126()
            workB = workHex.hex2Bytes
            for i in 0..<254 {
                workB[7] = UInt8(i)
                
                var source = Bytes()
                source.append(contentsOf: workB)
                let hashB = hash.hex2Bytes
                source.append(contentsOf: hashB)
                let valueB = Blake2b.hash(outLength: WorkSize, in: source) ?? Bytes(count:WorkSize)
                let valueBReverse = QLCUtil.reverse(bytes: valueB)
                let value = valueBReverse.bytesToUInt64_Big
//                let value = valueB.bytesToUInt64_Little
                workIsValid = value >= THRESHOLD
                if workIsValid {
                    break
                }
            }
        }
        if stopWork == true {
            return ""
        }
        stopWork = true
        print(Date(),"work:",workB.toHexString(), "开始---结束了")

        let workBReverse = QLCUtil.reverse(bytes: workB)
        return workBReverse.toHexString()
//        return workB.toHexString()
    }
    
//    static func startTimer() {
//        var timeCount = 30
//        // 在global线程里创建一个时间源
//        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//        // 设定这个时间源是每秒循环一次，立即开始
//        timer.schedule(deadline: .now(), repeating: .seconds(1))
//        // 设定时间源的触发事件
//        timer.setEventHandler(handler: {
//            if stopWork == true {
//                timer.cancel()
//            }
//            // 每秒计时一次
//            timeCount = timeCount - 1
//            // 时间到了取消时间源
//            if timeCount <= 0 {
//                isTimeOut = true
//                stopWork = true
//                timer.cancel()
//            }
//            // 返回主线程处理一些事件，更新UI等等
//            DispatchQueue.main.async {
//                print(Date(),"-------%d",timeCount);
//            }
//        })
//        // 启动时间源
//        timer.resume()
//    }
    
}

extension Date {
    func secondsBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.second], from: self, to: toDate)
        return components.second ?? 0
    }
}
