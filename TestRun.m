//
//  TestRun.m
//  objc
//
//  Created by EaseMob on 2017/8/17.
//
//

#import "TestRun.h"

#import "MyString.h"
#import "TestAutoRelease.h"
#import "TestLock.h"

@interface TestRun ()
{

}

@end

static TestRun *instance = nil;
@implementation TestRun

+ (TestRun*)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TestRun alloc] init];
    });
    return instance;
}

- (void)run
{
    // 测试消息转发功能
    // [self testForward];
    
    // 测试autorelease
    // [self testAutorelease];
    
    // 测试锁
    [self testLock];
    
}

- (void)testForward
{
    //测试消息转发功能
    MyString *str = [[MyString alloc] init];
    [str performSelector:@selector(MissMethod) withObject:nil];
    [str performSelector:@selector(MissMethod2) withObject:nil];
    [str performSelector:@selector(MissMethod3) withObject:nil];
}

- (void)testAutorelease
{
    TestAutoRelease *test = [[TestAutoRelease alloc] init];
    [test testAutorelease1];
    [test testAutorelease2];
    [test testAutorelease3];
}

- (void)testLock
{
    TestLock *lock = [[TestLock alloc] init];
    [TestLock testConditionLock2:lock];
}

@end
