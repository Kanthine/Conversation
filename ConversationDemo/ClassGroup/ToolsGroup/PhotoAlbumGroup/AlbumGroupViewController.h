//
//  AlbumGroupViewController.h
//  MyYummy
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosManager.h"

/* 相薄列表
 */
@interface AlbumGroupViewController : UIViewController

@property (nonatomic ,copy) void(^selectedImagesHanlder)(NSMutableArray<PHAsset *> *selectedArray);//选中的照片列表
@property (nonatomic ,strong) NSMutableArray<PHAsset *> *selestedArray;

@end
