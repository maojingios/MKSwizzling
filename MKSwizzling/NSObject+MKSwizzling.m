//
//  NSObject+MKSwizzling.m
//  MKSwizzling
//
//  Created by gw on 2017/6/7.
//  Copyright © 2017年 VS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@implementation NSObject (MKSwizzling)

/*
 这是数组对象使用array[index]调用，为基类添加此方法，误对非数组对象使用此方法就不会报错，返回nil
 */
- (id)objectAtIndexedSubscript:(NSUInteger)index {
    
    return nil;
}

/*
 为基类增加访问字典value方法，即使不是字典对象调用也不会报错 --> 返回nil
 */
- (id)objectForKeyedSubscript:(id)key {
    
    return nil;
}

@end

@implementation NSArray (MKExtension)

+(void)load{
    
    //deal index out of bounds <__NSArray0 、__NSSingleObjectArrayI 、__NSArrayI>  ''Clusters''
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(mkNSArrayIObjectAtIndex:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(objectAtIndex:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(mkNSSingleObjectArrayIObjectAtIndex:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSArray0"), @selector(objectAtIndex:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArray0"), @selector(mkNSArrayZeroObjectAtIndex:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

/*
 NSArray 越界访问返回nil
 */
-(id)mkNSArrayIObjectAtIndex:(NSInteger)index{
    
    if (index> self.count) {
        NSLog(@"数组越界");
        return nil;
    }
    
    return [self mkNSArrayIObjectAtIndex:index];
}
-(id)mkNSSingleObjectArrayIObjectAtIndex:(NSInteger)index{
    
    if (index> self.count) {
        NSLog(@"数组越界");
        return nil;
    }
    
    return [self mkNSSingleObjectArrayIObjectAtIndex:index];
}
-(id)mkNSArrayZeroObjectAtIndex:(NSInteger)index{
    
    if (index> self.count) {
        NSLog(@"数组越界");
        return nil;
    }
    return [self mkNSArrayZeroObjectAtIndex:index];
}

@end

@implementation NSMutableArray (MKExtension)

+(void)load{

    //deal out of bounds
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(mkObjectAtIndex:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
    //deal insert nil
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(mkInsertObject:atIndex:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
    
}
-(id)mkObjectAtIndex:(NSInteger)index{

    if (index>self.count) {
        NSLog(@"数组越界");
        return nil;
    }
    return [self mkObjectAtIndex:index];
}

-(void)mkInsertObject:(id)object atIndex:(NSInteger)index{

    //out of bound
    if (index>self.count) {
        index = self.count;
    }
    //nil
    if (!object) {
        object = [NSNull null];
    }
    [self mkInsertObject:object atIndex:index];
}
@end

@implementation NSDictionary (MKSwizzling)

+ (void)load {
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSPlaceholderDictionary"), @selector(mkInitWithObjects:forKeys:count:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

/*
 替换创建字典方法key或value为nil时也不会报错 , 替换为NSNull对象占位
 */
- (instancetype)mkInitWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    
    id newObjects[cnt];
    id newKeys[cnt];
    
    for (NSInteger i = 0; i < cnt; i++) {
        
        newObjects[i] = objects[i];
        newKeys[i] = keys[i];
        
        if (!objects[i]) {
            newObjects[i] = [NSNull null];
        }
        if (!keys[i]) {
            newKeys[i] = [NSNull null];
        }
    }
    return [self mkInitWithObjects:newObjects forKeys:newKeys count:cnt];
}

@end


@implementation NSMutableDictionary (MKSwizzling)

+ (void)load {
    //deal the key is nil
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(mkRemoveObjectForKey:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
    //deal key and obj are nil
    {
        Method oriMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(mkSetObject:forKey:));
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

/*
 替换删除key对应value方法 key为nil时也不会报错 --> 什么都不执行
 */
- (void)mkRemoveObjectForKey:(id)aKey {
    
    if (aKey) {
        
        [self mkRemoveObjectForKey:aKey];
    }
}

-(void)mkSetObject:(id)object forKey:(id)key{

    if (!object) {
        NSLog(@"空值");
        object = [NSNull null];
    }
    if (!key) {
        NSLog(@"空值");
        key = [NSNull null];
    }
    [self mkSetObject:object forKey:key];
}

@end
