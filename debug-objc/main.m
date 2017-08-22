
//  main.m
//  debug-objc
//
//  Created by closure on 2/24/16.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "TestRun.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        [[TestRun shareInstance] run];
//        void (^block)();
//        block = ^{
//            
//        };
//        block();
//        
//        
//        void (^block2)();
//        
//        __block int b = 0;
//        block2 = ^ {
//            b = 1;
//        };
//        block2();
    }
    return 0;
}
