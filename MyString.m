//
//  MyString.m
//  objc
//
//  Created by EaseMob on 2017/8/17.
//
//

#import "MyString.h"

#import <objc/runtime.h>

@implementation NSString (AutoRelease)

- (NSString*)description
{
    return [NSString stringWithFormat:@"hello%d",self.intValue];
}

@end

@interface MyString2 : NSString

@end

@implementation MyString2

- (void)MissMethod2
{
    NSLog(@"MissMethod2");
}

- (void)MissMethod3
{
    NSLog(@"MissMethod3");
}

@end

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@" >> dynamicMethodIMP");
}

@interface MyString ()
{
    MyString2 *_str2;
}

@end

@implementation MyString

- (instancetype)init
{
    self = [super init];
    if (self) {
        _str2 = [[MyString2 alloc] init];
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)name
{
    NSLog(@" >> Instance resolving %@", NSStringFromSelector(name));
    
    NSString *selName = NSStringFromSelector(name);
    
    if ([selName hasPrefix:@"MissMethod"]) {
        if (name == @selector(MissMethod)) {
            class_addMethod([self class], name, (IMP)dynamicMethodIMP, "v@:");
            return YES;
        } else {
            return NO;
        }
    }
    
    return [super resolveInstanceMethod:name];
}

- (id)forwardingTargetForSelector:(SEL)sel {
    if(sel == @selector(MissMethod2)){
        return _str2;
    }
    return [super forwardingTargetForSelector:sel];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    NSMethodSignature *sig;
    sig = [_str2 methodSignatureForSelector:sel];
    if (sig) {
        return sig;
    }
    return [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    id target = nil;
    if ([_str2 methodSignatureForSelector:[invocation selector]] ) {
        target = _str2;
        [invocation invokeWithTarget:target];
    }
}

@end
