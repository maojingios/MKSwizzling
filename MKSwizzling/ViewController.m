
#import "ViewController.h"
#import "MKPerson.h"
#import "UIImage+Util.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@property (nonatomic, readwrite, copy)NSString * name;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicUsage];
    
    
    
}
-(void)basicUsage{
    
    [self getIvars];//获取成员变量
    [self getProperties];//属性
    [self getMethods];//方法
    [self KVCAssign];//kvc赋值
    
    [self sendMessage];//消息机制
    
    [self exchangeIMPImage];//替换imageNamed：方法
    
    [self testMKSwizzling];//测试
    
    
    
}

-(void)getIvars{
    
    NSLog(@"******************Ivars*****************\n");
    
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([MKPerson class], &count);
    
    for (NSInteger i =0; i <count; i++) {
        Ivar var = ivars[i];
        NSLog(@"ivar-%@",[NSString stringWithUTF8String:ivar_getName(var)]);
        NSLog(@"ivar-%@",[NSString stringWithUTF8String:ivar_getTypeEncoding(var)]);
    }
    
}
-(void)getProperties{
    
    NSLog(@"******************property*****************\n");
    
    unsigned int count = 0;
    objc_property_t * ivars = class_copyPropertyList([MKPerson class], &count);
    
    for (NSInteger i =0; i < count; i++) {
        objc_property_t property = ivars[i];
        NSLog(@"%@",[NSString stringWithUTF8String:property_getName(property)]);
    }
}

-(void)getMethods{
    
    NSLog(@"*****************method******************\n");
    
    unsigned int count = 0;
    Method * methods = class_copyMethodList([MKPerson class], &count);
    
    for (NSInteger i = 0; i<count; i++) {
        
        Method  method = methods[i];
        SEL sel = method_getName(method);
        NSLog(@"%@",[NSString stringWithUTF8String:sel_getName(sel)]);
    }
}

-(void)KVCAssign{

    NSLog(@"*****************KVC******************\n");

    [self setValue:@"hello kitty" forKeyPath:@"_name"];
    NSLog(@"%@",self.name);
}

-(void)sendMessage{

    NSLog(@"*****************sendMsg******************\n");
/*
    MKPerson * mkp1 = [[MKPerson alloc] init];
    [mkp1 eat];
 */
    Class mkClass = objc_getClass("MKPerson");
    MKPerson * mkp = objc_msgSend(mkClass, @selector(alloc));
    mkp = objc_msgSend(mkp, @selector(init));
    
    objc_msgSend(mkp, @selector(eat));
}

-(void)exchangeIMPImage{

    NSLog(@"*****************Method exchange******************\n");
    
    UIImage * image = [UIImage imageNamed:@"hello"];

}

-(void)testMKSwizzling{

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:nil forKey:@"name"];

}

@end
