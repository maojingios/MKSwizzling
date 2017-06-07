//
//  UIImage+Util.m
//  MKSwizzling
//
//  Created by gw on 2017/6/7.
//  Copyright © 2017年 VS. All rights reserved.
//

#import "UIImage+Util.h"
#import <objc/runtime.h>

@implementation UIImage (Util)

+(void)load{

    Method oriMethod = class_getClassMethod(self, @selector(imageNamed:));
    Method newMethod = class_getClassMethod(self, @selector(mkImageNamed:));
    method_exchangeImplementations(oriMethod, newMethod);
    
}

+(instancetype)mkImageNamed:(NSString *)name{

    UIImage * image = [self mkImageNamed:name];//方法已交换，实际调用imageNamed
    if (!image) {
        NSLog(@"加载空图片");
    }
    return image;
}
@end
