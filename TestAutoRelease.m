//
//  TestAutoRelease.m
//  objc
//
//  Created by EaseMob on 2017/8/22.
//
//

#import "TestAutoRelease.h"

__weak NSString *string_weak_ = nil;

@implementation TestAutoRelease

- (void)testAutorelease1
{
    string_weak_ = nil;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *str = [NSString stringWithFormat:@"%d",1];
        string_weak_ = str;
    });
    NSLog(@"string_weak_ %@",string_weak_);
}

- (void)testAutorelease2
{
    @autoreleasepool {
        NSString *str2 = [NSString stringWithFormat:@"%d",2];
        string_weak_ = str2;
    }
    NSLog(@"string_weak_ %@",string_weak_);
}

- (void)testAutorelease3
{
    NSString *str3 = nil;
    @autoreleasepool {
        str3 = [NSString stringWithFormat:@"%d",3];
        string_weak_ = str3;
    }
    NSLog(@"string_weak_ %@",string_weak_);
}

@end
