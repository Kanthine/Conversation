//
//  UserHomeCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/24.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define CellIdentifer @"BookTableCell"

#import "UserHomeCell.h"
#import <UIImageView+WebCache.h>



@interface BookTableCell : UITableViewCell
@property (nonatomic ,strong) NSString *bookName;
@property (nonatomic ,strong) UIImageView *coverImageView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *describeLabel;
@end

@implementation BookTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 60, 60)];
        _coverImageView.layer.cornerRadius = 3;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:_coverImageView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColor.blackColor;
        [self.contentView addSubview:_titleLabel];
        
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:11];
        _describeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self.contentView addSubview:_describeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat contentView_width = CGRectGetWidth(self.contentView.frame);
    self.coverImageView.frame = CGRectMake(12, 18, 60, 60);
    
    CGFloat start_x = CGRectGetMaxX(self.coverImageView.frame) + 12.0;
    _titleLabel.frame = CGRectMake(start_x, 22, contentView_width - start_x - 40, 16);
    _describeLabel.frame = CGRectMake(start_x, CGRectGetMaxY(_titleLabel.frame) + 8, contentView_width - start_x - 40, 12);
}

- (void)setBookName:(NSString *)bookName{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591872709995&di=4e3a6880183a53aa598d46353a8d3a1d&imgtype=0&src=http%3A%2F%2Fpic.baike.soso.com%2Fp%2F20131122%2F20131122124912-1917471225.jpg"]];
    self.titleLabel.text = bookName;
    self.describeLabel.text = @"见到吾皇，为何不跪";
}

@end



@interface UserHomeTableBookCell ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UILabel *itemLabel;
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation UserHomeTableBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.layer.cornerRadius = 9;
        self.contentView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.itemLabel];
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(12, 12, CGRectGetWidth(self.frame) - 12 * 2.0, CGRectGetHeight(self.frame) - 12);
    self.tableView.frame = CGRectMake(0, 40, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(self.itemLabel.frame));
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.bookName = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - setter and getters

- (void)setDataArray:(NSMutableArray<NSString *> *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (UILabel *)itemLabel{
    if (_itemLabel == nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 18, 100, 16)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.blackColor;
        label.text = @"书架";
        _itemLabel = label;
    }
    return _itemLabel;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),CGRectGetHeight(UIScreen.mainScreen.bounds)) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 72.0f;
        tableView.sectionFooterHeight = 0.1f;
        [tableView registerClass:BookTableCell.class forCellReuseIdentifier:CellIdentifer];
        tableView.scrollEnabled = NO;
        _tableView = tableView;
    }
    return _tableView;
}

@end
