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
    
//    private static let ThreadLocalRandom RANDOM = ThreadLocalRandom.current()
    
    @objc public static func generateWorkOfOperation(hash:String ,handler:@escaping ((String) -> Void)) {
        var workResult = ""
        let count = 1
        let queue = OperationQueue()
        for i in 0..<count {
            let operation = BlockOperation(block: { [weak queue] in
                print(Date(),"work\(i) = 开始")
                workResult = WorkUtil.generateWorkOfSingle(hash: hash, startWork: UInt64(i), offsetWork: UInt64(count))
                queue?.cancelAllOperations()
                if workResult.count > 0 {
                    handler(workResult)
                }
            })
            queue.addOperation(operation)
        }
//        let operation1 = BlockOperation(block: { [weak queue] in
//            print(Date(),"work0 = 开始")
//            workResult = WorkUtil.generateWorkOfSingle(hash: hash, startWork: 0, offsetWork: 2)
//            queue?.cancelAllOperations()
//            if workResult.count > 0 {
//                handler(workResult)
//            }
//        })
//        queue.addOperation(operation1)
//        let operation2 = BlockOperation(block: { [weak queue] in
//            print(Date(),"work1 = 开始")
//            workResult = WorkUtil.generateWorkOfSingle(hash: hash, startWork: 1, offsetWork: 2)
//            queue?.cancelAllOperations()
//            if workResult.count > 0 {
//                handler(workResult)
//            }
//        })
//        queue.addOperation(operation2)
        
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
//            let workB = work.uint64ToBytes
//            let workUInt64 = workB.bytesToUInt64
            let workB = work.toBytes
            source.append(contentsOf: workB)
            let hashB = hash.hex2Bytes
            source.append(contentsOf: hashB)
            let valueB = Blake2b.hash(outLength: WorkSize, in: source) ?? Bytes(count:WorkSize)
            let valueBReverse = QLCUtil.reverse(bytes: valueB)
//            let value = valueBReverse.bytesToUInt64
            let value = valueBReverse.bytesToUInt64_big
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
        print(Date(),"startWork:",startWork,"offsetWork:",offsetWork,"work:",work)
        
//        let workB = work.uint64ToBytes
        let workB = work.toBytes
        let workBReverse = QLCUtil.reverse(bytes: workB)
        return workBReverse.toHexString()
    }
//    public static func generateWorkOneThread(hash:Bytes) -> String {
//    final byte[] pow = new byte[8], zero = new byte[8];
//    Arrays.fill(zero, (byte) 0x00);
//    Arrays.fill(pow, (byte) 0x00);
//
//    Blake2b blake2b = new Blake2b(null, 8, null, null);
//    byte[] output = new byte[8];
//    while (isEqual(pow, zero)) {
//    byte[] bytes = new byte[8];
//    RANDOM.nextBytes(bytes);
//    for (byte b = -128; b < 127; b++) {
//    bytes[7] = b;
//    blake2b.reset();
//    blake2b.update(bytes, 0, bytes.length);
//    blake2b.update(hash, 0, hash.length);
//    blake2b.digest(output, 0);
//    byte[] digest = Helper.reverse(output);
//    if (overThreshold(digest)) {
//    System.arraycopy(Helper.reverse(bytes), 0, pow, 0, 8);
//    break;
//    }
//    }
//    }
//
//    return Helper.byteToHexString(pow);
//    }
//
//    public static func generateWork(hash:Bytes) -> String {
//        final byte[] pow = new byte[8], zero = new byte[8];
//        Arrays.fill(zero, (byte) 0x00);
//        Arrays.fill(pow, (byte) 0x00);
//
//        Thread[] threads = new Thread[4];
//        for (int i=0; i<4; i++) {
//        Thread powFinder = new Thread() {
//        @Override
//        public void run() {
//        Blake2b blake2b = new Blake2b(null, 8, null, null);
//        byte[] output = new byte[8];
//        while (isEqual(pow, zero)) {
//        byte[] bytes = new byte[8];
//        RANDOM.nextBytes(bytes);
//        for (byte b = -128; b < 127; b++) {
//        bytes[7] = b;
//        blake2b.reset();
//        blake2b.update(bytes, 0, bytes.length);
//        blake2b.update(hash, 0, hash.length);
//        blake2b.digest(output, 0);
//        byte[] digest = Helper.reverse(output);
//        if (overThreshold(digest)) {
//        System.arraycopy(Helper.reverse(bytes), 0, pow, 0, 8);
//        break;
//        }
//        }
//        }
//        }
//        };
//        threads[i] = powFinder;
//        powFinder.start();
//    }
//
//    while (isEqual(pow, zero)) {
//    try {
//    Thread.sleep(5);
//    } catch (Exception e) {
//    e.printStackTrace();
//    }
//    }
//
//    return Helper.byteToHexString(pow);
//    }
//
//    private static boolean isEqual(byte[] b0, byte[] b1) {
//    for (int i = 0; i < b0.length; i++) {
//    if (b0[i] != b1[i])
//    return false;
//    }
//    return true;
//    }
//
//    private static boolean overThreshold(byte[] bytes) {
//    long result = 0; //faster than ByteBuffer apparently:
//    for (int i = 0; i < 8; i++) {
//    result <<= 8;
//    result |= (bytes[i] & 0xFF);
//    }
//    return Long.compareUnsigned(result, THRESHOLD) > 0; //wew java 8!
//    }
    
}
