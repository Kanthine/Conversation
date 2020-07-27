//
//  AlbumGroupTableCell.m
//  MyYummy
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "AlbumGroupTableCell.h"
#import <Masonry.h>

@interface AlbumGroupTableCell()

@property (nonatomic ,strong) UIImageView *homeImageView;
@property (nonatomic ,strong) UILabel *groupNameLable;
@property (nonatomic ,strong) UILabel *photoCountLable;

@property (nonatomic, strong) UILabel *grayLable;

@end

@implementation AlbumGroupTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.homeImageView];
        [self.contentView addSubview:self.groupNameLable];
        [self.contentView addSubview:self.photoCountLable];
        [self.contentView addSubview:self.grayLable];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    
    return self;
}

- (void)updateConstraints{
    __weak __typeof__(self) weakSelf = self;
        
    [self.homeImageView mas_makeConstraints:^(MASConstraintMaker *make){
         make.top.mas_equalTo(@10);
         make.left.mas_equalTo(@10);
         make.bottom.mas_equalTo(@-10);
         make.width.mas_equalTo(weakSelf.homeImageView.mas_height).multipliedBy(1);
     }];
    
    [self.groupNameLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(-10);
         make.left.equalTo(_homeImageView.mas_right).with.offset(10);
         make.height.mas_equalTo(@20);
         make.right.mas_equalTo(@-60);
     }];
    
    
    [self.photoCountLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_groupNameLable.mas_bottom).with.offset(5);
         make.left.equalTo(_homeImageView.mas_right).with.offset(10);
         make.height.mas_equalTo(@20);
         make.right.mas_equalTo(@-60);
     }];
    
    [self.grayLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(@10);
         make.bottom.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
         make.height.mas_equalTo(@0.5);
     }];
    
    
    
    
    
    [super updateConstraints];
}

- (UIImageView *)homeImageView
{
    if (_homeImageView == nil)
    {
        _homeImageView = [[UIImageView alloc]init];
        _homeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _homeImageView.clipsToBounds = YES;
    }
    
    return _homeImageView;
}

- (UILabel *)groupNameLable
{
    if (_groupNameLable == nil)
    {
        _groupNameLable = [[UILabel alloc]init];
        _groupNameLable.font = [UIFont systemFontOfSize:14];
        _groupNameLable.textColor = [UIColor blackColor];
        _groupNameLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _groupNameLable;
}

- (UILabel *)photoCountLable
{
    if (_photoCountLable == nil)
    {
        _photoCountLable = [[UILabel alloc]init];
        _photoCountLable.font = [UIFont systemFontOfSize:14];
        _photoCountLable.textColor = [UIColor blackColor];
        _photoCountLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _photoCountLable;
}

- (UILabel *)grayLable
{
    if (_grayLable == nil)
    {
        _grayLable = [[UILabel alloc]init];
        _grayLable.backgroundColor =  [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
    }
    
    return _grayLable;
}

- (void)updateCellWithAssetCollection:(PHAssetCollection *)assetCollection
{
    //只加载图片
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    //文件夹的名称
    NSString *title = assetCollection.localizedTitle;
    
    //文件夹中的图片有多少张
    NSUInteger albumCount = albumResult.count;
    self.groupNameLable.text = [NSString stringWithFormat:@"%@",title];
    self.photoCountLable.text   = [NSString stringWithFormat:@"%ld 张照片", (long)albumCount];
    
    //取出文件夹中的第一张图片作为文件夹的显示图片
    PHAsset *firstAsset = [albumResult firstObject];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    [imageManager requestImageForAsset:firstAsset targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
         self.homeImageView.image = result;
     }];
}

@end
