//
//  MKPerson.h
//  MKSwizzling
//
//  Created by gw on 2017/6/7.
//  Copyright © 2017年 VS. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MKPerson : NSObject
{
    NSString * _firstName;
    NSString * _secondName;
}

@property (nonatomic, readwrite, assign) NSInteger age;
@property (nonatomic, readwrite, assign) CGFloat tall;

+(void)run;
-(void)eat;

@end
