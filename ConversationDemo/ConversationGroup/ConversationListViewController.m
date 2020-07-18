//
//  ConversationListViewController.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/18.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define CellIdentifer @"MessageCenterTableCell"

#import "ConversationListViewController.h"
#import "UserManager.h"
#import <UIImageView+WebCache.h>


@interface MessageCenterTableCell : UITableViewCell
- (void)reloadDatas:(UserManager *)user;
@property (nonatomic ,strong) UIImageView *portraitImageView;
@property (nonatomic ,strong) UILabel *nameLable;
@property (nonatomic ,strong) UILabel *contentLable;
@property (nonatomic ,strong) UILabel *timeLable;
@end

@implementation MessageCenterTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 12);
        [self.contentView addSubview:self.portraitImageView];
        [self.contentView addSubview:self.nameLable];
        [self.contentView addSubview:self.timeLable];
        [self.contentView addSubview:self.contentLable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat y = 20;
    self.portraitImageView.frame = CGRectMake(12, y, 42, 42);
    self.timeLable.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 50 - 12, y, 50, 16);
    CGFloat x = CGRectGetMaxX(self.portraitImageView.frame) + 10;
    self.nameLable.frame = CGRectMake(x, y, self.timeLable.frame.origin.x - x - 10, 16);
    self.contentLable.frame = CGRectMake(x, CGRectGetMaxY(self.nameLable.frame) + 8, CGRectGetWidth(self.nameLable.frame), 14);
}

#pragma mark - public method

- (void)reloadDatas:(UserManager *)object{
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2938503827,2763092737&fm=26&gp=0.jpg"]];
    self.nameLable.text = @"官方号";
    self.timeLable.text = @"2019.12";
    self.contentLable.text = @"通知内容";
}

#pragma mark - getter and setter

- (UIImageView *)portraitImageView{
    if (_portraitImageView == nil) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 42, 42)];
        _portraitImageView.layer.cornerRadius = 21;
        _portraitImageView.clipsToBounds = YES;
    }
    return _portraitImageView;
}

- (UILabel *)nameLable{
    if (_nameLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.blackColor;
        _nameLable = label;
    }
    return _nameLable;
}

- (UILabel *)timeLable{
    if (_timeLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        _timeLable = label;
    }
    return _timeLable;
}

- (UILabel *)contentLable{
    if (_contentLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        label.numberOfLines = 0;
        _contentLable = label;
    }
    return _contentLable;
}

@end





@interface ConversationListViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray<UserManager *> *usersArray;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation ConversationListViewController

#pragma mark - life cycle

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"会话列表";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Notification

- (void)playingWindowNotification:(NSNotification *)notification{
    [self viewWillLayoutSubviews];
}

#pragma mark - response click

- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.usersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    [cell reloadDatas:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - network

- (void)loadNetWorkRequest{
//    NSInteger currentPage = self.tableView.currentPage;
//    [HttpManagerTool requestPostWithPath:kURL_Message_List params:@{kHttpsPageKey:@(currentPage),kHttpsPageSizeKey:@"20"} completionBlock:^(NSDictionary *dataDict) {
//        NSMutableArray *resultArray = [MessageListModel parserArray:dataDict[@"msgColumns"]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (currentPage == 1) {
//                self.dataArray = resultArray;
//                [self.tableView endRequestIsHeader:YES isMore:!(resultArray.count < 20)];
//            }else{
//                [self.dataArray addObjectsFromArray:resultArray];
//                [self.tableView endRequestIsHeader:NO isMore:!(resultArray.count < 20)];
//            }
//            [self.tableView reloadData];
//        });
//    } failure:^(NSString *error) {
//        [self.tableView reloadData];
//    }];
}

#pragma mark - setter and getters

- (UITableView *)tableView{
    if (_tableView == nil){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),CGRectGetHeight(UIScreen.mainScreen.bounds)) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        tableView.rowHeight = 70;
        tableView.sectionFooterHeight = 0.1f;
        [tableView registerClass:MessageCenterTableCell.class forCellReuseIdentifier:CellIdentifer];
        _tableView = tableView;
    }
    return _tableView;
}

@end
