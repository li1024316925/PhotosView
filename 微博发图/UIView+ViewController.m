//
//  UIView+ViewController.m
//  05响应者链nextResponder
//
//  Created by CORYIL on 16/3/16.
//  Copyright © 2016年 徐锐. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)


- (UIViewController *)viewController{

    //获取下一响应者
    UIResponder *next = self.nextResponder;
    
    //响应者存在的情况下进行判断
    while (next) {
        
//        NSLog(@"%@",next);
        
        //当响应者类型为控制器时 返回控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        
        //如果不是控制器时
        next = next.nextResponder;
        
    }

    return nil;
}

@end
