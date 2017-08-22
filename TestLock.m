//
//  TestLock.m
//  objc
//
//  Created by EaseMob on 2017/8/22.
//
//

#import "TestLock.h"

@interface TestLock ()
{
    dispatch_queue_t _read_write_queue;
    NSLock *_lock;
    NSCondition *_condition;
    NSRecursiveLock *_recursiveLock;
}

@property (nonatomic, copy) NSString *lockValue;

@property (nonatomic, copy) NSMutableArray *array;

@end

@implementation TestLock

- (instancetype)init
{
    if (self) {
        _read_write_queue = dispatch_queue_create("com.easemob.zilong.readwrite.queue", DISPATCH_QUEUE_CONCURRENT);
        _lock = [[NSLock alloc] init];
        _condition = [[NSCondition alloc] init];
        _array = [NSMutableArray array];
        _recursiveLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)setLockValue:(NSString*)aLockValue
{
    dispatch_barrier_async(_read_write_queue, ^{
        _lockValue = [aLockValue copy];
    });
}

- (NSString *)getLockValue
{
    __block NSString *temp;
    dispatch_sync(_read_write_queue, ^{
        temp = _lockValue;
    });
    return temp;
}

- (void)addToArray
{
    [_condition lock];
    [_array addObject:@"1"];
    [_condition signal];
    NSLog(@"add-%lu",(unsigned long)_array.count);
    [_condition unlock];
}

- (void)removeFromArray
{
    [_condition lock];
    if (_array.count == 0) {
        [_condition wait];
        NSLog(@"wait-%lu",(unsigned long)_array.count);
    }
    if (_array.count > 0) {
        [_array removeLastObject];
    }
    NSLog(@"remove-%lu",(unsigned long)_array.count);
    [_condition unlock];
}

- (void)testRecursiveLock
{
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc] init];
    __block int value = 3;
    static void (^Block) (int);
    Block = ^(int count){
        [recursiveLock lock];
        if (count > 0) {
            NSLog(@"加锁层数 %d-%@", count,[NSThread currentThread]);
            sleep(1);
            Block(--count);
        }
        [recursiveLock unlock];
    };
    Block(value);
}

- (void)testConditionLock
{
    NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:0];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        for (int i=0;i<3;i++){
//            [conditionLock lock];
//            NSLog(@"线程 0:%d",i);
//            sleep(1);
//            [conditionLock unlockWithCondition:i];
//        }
//    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [conditionLock lock];
        NSLog(@"线程 1");
        sleep(1);
        [conditionLock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [conditionLock lockWhenCondition:0];
        NSLog(@"线程 2");
        sleep(1);
        [conditionLock unlockWithCondition:1];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [conditionLock lockWhenCondition:1];
        NSLog(@"线程 3");
        sleep(1);
        [conditionLock unlockWithCondition:2];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [conditionLock lockWhenCondition:2];
        NSLog(@"线程 4");
        sleep(1);
        [conditionLock unlockWithCondition:0];
    });
}

+ (void)testReadWriteLock:(TestLock *)lock
{
    int index = 10;
    while(index != 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            lock.lockValue = [NSString stringWithFormat:@"%d",index];
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"%@",lock.lockValue);
        });
        index --;
    }
}

+ (void)testConditionLock:(TestLock *)lock
{
    int index = 100;
    __block TestLock *b_lock = lock;
    while(index != 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [b_lock addToArray];
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [b_lock removeFromArray];
        });
        index --;
    }
    
    [NSThread sleepForTimeInterval:20];
}

+ (void)testRecursiveLock:(TestLock *)lock
{
    __block TestLock *b_lock = lock;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [b_lock testRecursiveLock];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [b_lock testRecursiveLock];
    });
    [NSThread sleepForTimeInterval:20];
}

+ (void)testConditionLock2:(TestLock *)lock
{
    [lock testConditionLock];
    [NSThread sleepForTimeInterval:20];
}

@end
