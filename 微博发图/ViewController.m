//
//  ViewController.m
//  微博发图
//
//  Created by LLQ on 16/7/6.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "ViewController.h"

#import "PhotosView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PhotosView *photosView = [[PhotosView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    
    [self.view addSubview:photosView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
