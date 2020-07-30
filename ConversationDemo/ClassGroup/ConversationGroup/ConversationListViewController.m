//
//  ConversationListViewController.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//
#define CellIdentifer @"ConversationListCell"

#import "ConversationListViewController.h"
#import "ConversationListCell.h"
#import "ConversationViewController.h"
#import <Toast.h>

@interface ConversationListViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIButton *offLineButton;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<ConversationUserModel *> *userArray;
@property (nonatomic ,assign) BOOL isOnLine;///是否在线

@end

@implementation ConversationListViewController

#pragma mark - life cycle

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _isOnLine = YES;
    self.navigationItem.title = @"在线人员";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.offLineButton];
    [self.view addSubview:self.tableView];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(socketLinkStateNotification:) name:kSocketLinkStateNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNetWorkRequest];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (_isOnLine) {
        self.tableView.frame = self.view.bounds;
    }else{
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.offLineButton.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44);
    }
}

#pragma mark - Notification

- (void)socketLinkStateNotification:(NSNotification *)notification{
    self.isOnLine = [notification.userInfo[kSocketOnLineInfoKey] boolValue];
}

- (void)offLineButtonClick:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [WebSocketClient.shareClient recoverSocket];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    cell.userModel = self.userArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.userArray[indexPath.row].userId isEqualToString:UserManager.shareUser.userId]) {
        [self.view makeToast:@"不能和自己聊天" duration:3 position:CSToastPositionCenter];
    }else{
        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithTargetUser:self.userArray[indexPath.row]];
        conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

#pragma mark - network

- (void)loadNetWorkRequest{
    [HttpManager requestForGetUrl:@"/api/user/online" success:^(id responseObject) {
        
        NSMutableArray *array = [NSMutableArray array];
        ConversationUserModel *group = [[ConversationUserModel alloc] init];
        group.userId = @"happy_group";
        group.nickName = @"开心聊天群";
        group.isGroup = YES;
        group.headPath = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3526296747,2488805525&fm=26&gp=0.jpg";
        [group asyncGetLastMessage];
        [array addObject:group];
        
        if ([responseObject[@"success"] boolValue]) {
            NSArray<NSDictionary *> *dataArray = responseObject[@"data"];
            if (dataArray && [dataArray isKindOfClass:NSArray.class]) {
                [dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ConversationUserModel *model = [ConversationUserModel modelObjectWithDictionary:obj];
                    [array addObject:model];
                }];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userArray = array;
            [self.tableView reloadData];
        });
    } failure:^(NSString *error) {
        NSLog(@"error ===== %@",error);
    }];
}

#pragma mark - setter and getters

- (void)setIsOnLine:(BOOL)isOnLine{
    _isOnLine = isOnLine;
    self.offLineButton.userInteractionEnabled = YES;
    self.offLineButton.hidden = isOnLine;
    if (_isOnLine) {
        self.tableView.frame = self.view.bounds;
    }else{
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.offLineButton.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44);
    }
}

- (UIButton *)offLineButton{
    if (_offLineButton == nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,0,  CGRectGetWidth(UIScreen.mainScreen.bounds),44);
        button.backgroundColor = [UIColor colorWithRed:254/255.0 green:190/255.0 blue:202/255.0 alpha:1.0];
        [button setTitle:@"当前网络不好，点击重新上线" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(offLineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _offLineButton = button;
    }
    return _offLineButton;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),CGRectGetHeight(UIScreen.mainScreen.bounds)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 72;
        tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:ConversationListCell.class forCellReuseIdentifier:CellIdentifer];
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, isIPhoneNotchScreen() ? 34 : 0, 0);
        }
        _tableView = tableView;
    }
    return _tableView;
}

@end
