//
//  TestRun.h
//  objc
//
//  Created by EaseMob on 2017/8/17.
//
//

#import <Foundation/Foundation.h>

@interface TestRun : NSObject

+ (TestRun*)shareInstance;

- (void)run;

@end
