//
//  MKPerson.m
//  MKSwizzling
//
//  Created by gw on 2017/6/7.
//  Copyright © 2017年 VS. All rights reserved.
//

#import "MKPerson.h"
#import <objc/runtime.h>

@implementation MKPerson

-(instancetype)init{

    if (self=[super init]) {
        
    }
    return self;
}

+(void)load{

    Method oriMethod = class_getInstanceMethod(self, @selector(eat));
    Method newMethod = class_getInstanceMethod(self, @selector(newEat));
    method_exchangeImplementations(oriMethod, newMethod);
    
}

+(void)run{ NSLog(@"run");}

-(void)eat{ NSLog(@"eat");}

-(void)newEat{ NSLog(@"newEat");};
@end
