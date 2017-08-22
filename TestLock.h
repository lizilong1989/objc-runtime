//
//  TestLock.h
//  objc
//
//  Created by EaseMob on 2017/8/22.
//
//

#import <Foundation/Foundation.h>

@interface TestLock : NSObject

//测试读写锁
+ (void)testReadWriteLock:(TestLock *)lock;

//测试Condition
+ (void)testConditionLock:(TestLock *)lock;

//测试递归锁
+ (void)testRecursiveLock:(TestLock *)lock;

//测试条件锁
+ (void)testConditionLock2:(TestLock *)lock;

@end
