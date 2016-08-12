//
//  PhotosViewController.m
//  微博发图
//
//  Created by LLQ on 16/7/7.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "PhotosViewController.h"
#import <Photos/Photos.h>

typedef void(^imageBlock)(UIImage *image);

@interface PhotosViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_dataList;
//    NSMutableArray *_selectPhotos;
}
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册";
    
    if (_selectDataDic == nil) {
        //初始化选中图片数组
        _selectDataDic = [[NSMutableDictionary alloc] init];
    }
    
    //添加导航栏按钮
    [self addNavigationItem];
    
    //获取图片资源
    [self getAllPhotos];
    
    //创建集合视图
    [self createCollectionView];
    
}

//视图即将显示
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //显示选中图片
    [self showSelectImg];
    
}

//显示选中图片
- (void)showSelectImg{
    
    NSArray *indexArray = [_selectDataDic allKeys];
    
    if (indexArray != nil) {
        
        for (NSNumber *num in indexArray) {
            
            //解包
            NSInteger index = [num integerValue];
            
            //创建IndexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            //获取选中图片视图
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
            UIImageView *selectImageView = [cell viewWithTag:102];
            selectImageView.hidden = NO;
            
        }
        
    }
    
}

//添加两侧导航栏按钮
- (void)addNavigationItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAct)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAct)];
    
}

//导航栏按钮方法
//返回
- (void)leftBtnAct{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//确定
- (void)rightBtnAct{
    
    //回调Block
    _dataBlock(_selectDataDic);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//获取所有图片资源
- (void)getAllPhotos{
    
    //初始化数据源数组
    _dataList = [[NSMutableArray alloc] init];
    
    //创建筛选查询option
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    //查询后的所有图片
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:options];
    
    //遍历所有资源集合将所有资源添加到数组
    for (PHAsset *asset in result) {
        [_dataList addObject:asset];
    }
    
}

//获取image
- (void)getImageWithAsset:(PHAsset *)asset withBlock:(imageBlock)block{
    
    //通过asset资源获取图片
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       
        //回调block
        block(result);
        
    }];
    
}

//创建collectionView
- (void)createCollectionView{
    
    //布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (self.view.bounds.size.width - 50)/4;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //注册单元格
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];
    
}

#pragma mark ------ UICollectionViewDataSource

//返回每组单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataList.count;
    
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //单元格复用
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //判断当前单元格是否存在imageView控件
    if (![cell.contentView viewWithTag:101]) {
        //创建imageView
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imgView.tag = 101;
        
        [cell.contentView addSubview:imgView];
        
        //添加选中图片
        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 18, 0, 18, 18)];
        selectImgV.tag = 102;
        selectImgV.image = [UIImage imageNamed:@"checkmark"];
        //默认隐藏
        selectImgV.hidden = YES;
        
        [cell.contentView addSubview:selectImgV];
    }
    
    //获取资源并给单元格赋值
    [self getImageWithAsset:_dataList[indexPath.row] withBlock:^(UIImage *image) {
       
        UIImageView *imgV = [cell viewWithTag:101];
        imgV.image = image;
        
    }];
    
    return cell;
    
}

#pragma mark ------ UICollectionViewDelegate

//点击单元格时调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取被点击的单元格
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //获取图标控件
    UIImageView *checkImgV = [cell viewWithTag:102];
    
    //判断当前选中数组中是否已满9个，已满则不允许添加
    if (_selectDataDic.count >= 9 && checkImgV.hidden == YES) {
        NSLog(@"已满9个，不许添加");
        return;
    }
    
    //隐藏属性取反
    checkImgV.hidden = !checkImgV.hidden;
    
    //向数组中添加图像
    if (checkImgV.hidden == NO) {
        //添加
        [self getImageWithAsset:_dataList[indexPath.row] withBlock:^(UIImage *image) {
            
            [_selectDataDic setObject:image forKey:@(indexPath.row)];
            
        }];
    }else{
        //删除
        [self getImageWithAsset:_dataList[indexPath.row] withBlock:^(UIImage *image) {
           
            [_selectDataDic removeObjectForKey:@(indexPath.row)];
            
        }];
    }
    
}

#pragma mark ------ UICollectionViewDelegateFlowLayout

//设置单元格与边缘控件距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
