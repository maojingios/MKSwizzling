# MKSwizzling

>Because Objc is a dynamic language, it always manages to postpone some decision work from compile connections to run time. That is, only the compiler is not enough, and a runtime system (runtime, system) is required to execute the compiled code. This is the meaning of the Objective-C Runtime system, which is a cornerstone of the overall Objc runtime framework.
OC is the runtime mechanism, the most important of which is the message mechanism. For the C language, the call to the function determines which function to call when compiling. For OC functions, the dynamic call process, at compile time, can not decide which function is actually called. Only when the function is actually running is the call corresponding to the function name called.

#### 1.Get Ivars

    -(void)getIvars{

        unsigned int count = 0;

        Ivar * ivars = class_copyIvarList([MKPerson class], &count);

        for (NSInteger i =0; i <count; i++) {

            Ivar var = ivars[i];

            NSLog(@"ivar-%@",[NSString stringWithUTF8String:ivar_getName(var)]);

            NSLog(@"ivar-%@",[NSString stringWithUTF8String:ivar_getTypeEncoding(var)]);

        }

    }


#### 2.Get Property

    -(void)getProperties{

        unsigned int count = 0;

        objc_property_t * ivars = class_copyPropertyList([MKPerson class], &count);

        for (NSInteger i =0; i < count; i++) {

            objc_property_t property = ivars[i];

            NSLog(@"%@",[NSString stringWithUTF8String:property_getName(property)]);

        }

    }

#### 3.Get Methods

    -(void)getMethods{

        unsigned int count = 0;

        Method * methods = class_copyMethodList([MKPerson class], &count);

        for (NSInteger i = 0; i<count; i++) {

            Method  method = methods[i];

            SEL sel = method_getName(method);

            NSLog(@"%@",[NSString stringWithUTF8String:sel_getName(sel)]);

        }

    }
    
#### 4.send msg

    -(void)sendMessage{
    /*
        MKPerson * mkp1 = [[MKPerson alloc] init];
        [mkp1 eat];
     */
        Class mkClass = objc_getClass("MKPerson");
        
        MKPerson * mkp = objc_msgSend(mkClass, @selector(alloc));
        
        mkp = objc_msgSend(mkp, @selector(init));
        
        objc_msgSend(mkp, @selector(eat));
        
    }

    tips:	1. don not forget “#import <objc/message.h>”
    
          2. click “target” -> search “objc” -> set “enble strict checking of objc_msgSend calls” ->No
          

### case 1

 when we use "imageNamed",if image is nil , it will notice "image is nill".

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


### case 2

>We will use runtime mechanisms to handle common problems such as array cross boundary, null value insertion, and so on.
please download “NSObject+MKSwizzling.m” and add to your project.

# Summary

> Generally speaking, understanding the runtime mechanism can not only help us better understand the underlying operations, but also provide us with a new way to solve the problem.

