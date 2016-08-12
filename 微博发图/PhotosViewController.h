//
//  PhotosViewController.h
//  微博发图
//
//  Created by LLQ on 16/7/7.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DataBlock)(NSMutableDictionary *data);

@interface PhotosViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *selectDataDic; //存储选中图片的字典

@property(nonatomic,copy)DataBlock dataBlock; //回传照片的block

- (void)setDataBlock:(DataBlock)dataBlock;

@end
