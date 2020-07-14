//
//  ConversationViewController.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//
#define Cell_Text_Identifer @"ConversationTableTextCell"
#define Cell_Seats_Identifer @"ConversationTableSeatsCell"

#import "ConversationViewController.h"
#import "ConversationModel.h"
#import "UIScrollView+RefreshManager.h"
#import "ConversationObjectModel.h"
#import "ConversationTableTextCell.h"
#import "ConversationTableSeatsCell.h"
#import "ConversationInputBar.h"
#import "WebSocketClient.h"
#import "UIBarButtonItem+LeftBarItem.h"
#import "GlobalTools.h"

@interface ConversationViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) int currentPage;
@property (nonatomic ,strong) ConversationObjectModel *shopModel;
@property (nonatomic ,strong) NSMutableArray<ConversationModel *> *dataArray;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) ConversationInputBar *inputBar;//输入框
@property (nonatomic ,strong) WebSocketClient *socketClient;
@end

@implementation ConversationViewController

- (instancetype)initWithID:(NSString *)idString{
    self = [super init];
    if (self) {
        self.shopModel.shopNo = idString;
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftBackItemWithTarget:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithImage:[UIImage imageNamed:@"conversation_call_phone"] target:self action:@selector(rightBarButtonItemClick)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputBar];
    [self socketClient];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self loadNetWorkRequest];
}

#pragma mark - response click

- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClick{
    if (self.shopModel.mobile.length > 5) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.shopModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataArray[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationModel *model = self.dataArray[indexPath.row];
    if (model.type == ConversationType_TEXT) {
        ConversationTableTextCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Text_Identifer forIndexPath:indexPath];
        if (model.direction == ConversationDirection_SEND) {
//            [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:LoginTool.shareLogin.headPath] placeholderImage:[UIImage imageNamed:@"login_default_header"]];
        }else{
//            [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.shopModel.shopUserImage] placeholderImage:[UIImage imageNamed:@"login_default_header"]];
        }
        cell.model = model;
        return cell;
    }else if (model.type == ConversationType_Seats){
        ConversationTableSeatsCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Seats_Identifer forIndexPath:indexPath];
        model.seatsInfo.shopName = self.shopModel.shopName;
        cell.model = model;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationModel *model = self.dataArray[indexPath.row];
    if (model.type == ConversationType_TEXT) {
        
    }else if (model.type == ConversationType_Seats){

    }
}

#pragma mark - private methods

- (void)loadNetWorkRequest{
//    NSString *lastMsgDate = self.dataArray.firstObject.sendDate;
//    if (lastMsgDate == nil || self.currentPage == 1) {
//        lastMsgDate = @"";
//    }
//
//    [HttpManagerTool postWithPath:message_privateInfo params:@{@"pageSize":@(20),@"pageNo":@(self.currentPage),@"shopNo":self.shopModel.shopNo, @"lastMsgDate":lastMsgDate} success:^(id JSON) {
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
//        NSMutableArray *resultArray;
//        if ([responseDict[@"code"] isEqualToString:@"SUCCESS"]){
//            [self.shopModel parserObjectWithDictionary:responseDict[@"data"]];
//            NSArray *priList = responseDict[@"data"][@"twoMsg"];
//
//            if (priList && [priList isKindOfClass:[NSArray class]]) {
//                resultArray = [NSMutableArray arrayWithCapacity:priList.count];
//                [priList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    ConversationModel *model = [ConversationModel modelObjectWithDictionary:obj];
//                    [resultArray insertObject:model atIndex:0];
//                }];
//
//                if (self.currentPage > 1) {
//                    [resultArray addObjectsFromArray:self.dataArray];
//                }
//                self.dataArray = resultArray;
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.navigationItem.title = self.shopModel.shopName;
//                    [self.tableView reloadData];
//                    if (self.currentPage == 1) {
//                        [self tableViewScrollToBottom:0.0];
//                    }
//                });
//            }
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
////                kPE(responseDict[@"message"]);
//            });
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (resultArray && resultArray.count < 20 * self.currentPage) {
//                self.tableView.mj_header = nil;
//                self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
//            }
//        });
//
//    } failure:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//        });
//    }];
}

- (void)insertConversationMessage:(NSDictionary *)dict{
    ConversationModel *model = [[ConversationModel alloc] init];
    model.sendDate = dict[@"sendDate"];
    model.sendUserId = dict[@"from"];
    model.receUserId = dict[@"to"];
    model.content = dict[@"text"];
    model.msgId = dict[@"msgId"];
    model.messageType = @"TEXT";
    [model parserExtraInfo];
    NSLog(@"model ==== %@",model);
    [self.dataArray addObject:model];
    [self.tableView reloadData];
    if (model.direction == ConversationDirection_RECEIVE) {
        [self tableViewScrollToBottom:0.0];
    }
}

- (void)tableViewScrollToBottom:(CGFloat)duration{
    if (self.dataArray.count < 1) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];

    if (duration == 0.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - setter and getters

- (NSMutableArray<ConversationModel *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ConversationObjectModel *)shopModel{
    if (_shopModel == nil) {
        _shopModel = [[ConversationObjectModel alloc] init];
        _shopModel.shopNo = @"";
    }
    return _shopModel;
}

- (WebSocketClient *)socketClient{
    if (_socketClient == nil) {
        NSString *url = [NSString stringWithFormat:@"http://route.51mypc.cn/chat/chat.html"];
        _socketClient = [[WebSocketClient alloc] init];
        [_socketClient openSocketWithURL:url heartBeat:@{}];
        __weak typeof(self) weakSelf = self;
        _socketClient.receivedMessage = ^(NSDictionary * _Nonnull dict) {
            [weakSelf insertConversationMessage:dict];
        };
    }
    return _socketClient;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), getPageSafeAreaHeight(YES) - CGRectGetHeight(self.inputBar.frame)) style:UITableViewStylePlain];
        tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 70.0f;
        tableView.sectionFooterHeight = 0.1f;
        [tableView registerClass:ConversationTableTextCell.class forCellReuseIdentifier:Cell_Text_Identifer];
        [tableView registerClass:ConversationTableSeatsCell.class forCellReuseIdentifier:Cell_Seats_Identifer];        
        tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        __weak typeof(self) weakSelf = self;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage ++;
            [weakSelf loadNetWorkRequest];
        }];
        tableView.autoHiddenFooter = YES;
        _tableView = tableView;
    }
    return _tableView;
}

//页面底部键盘输入框
- (ConversationInputBar *)inputBar{
    if (_inputBar == nil) {
        _inputBar = [[ConversationInputBar alloc]init];
        __weak typeof(self) weakSelf = self;
        _inputBar.frameChangeHandle = ^(CGRect frame, CGFloat duration) {
            weakSelf.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),frame.origin.y);
            [weakSelf tableViewScrollToBottom:duration];
        };
        _inputBar.sendCommentHandle = ^(NSString * _Nonnull text) {
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[NSDate.date timeIntervalSince1970]*1000];//时间戳
//            NSDictionary *dict = @{@"from":LoginTool.shareLogin.userId,@"to":weakSelf.shopModel.shopUserId,@"text":text,@"sendDate":timeSp};
//            [weakSelf.socketClient sendData:dict];
//            [weakSelf insertConversationMessage:dict];
        };
    }
    return _inputBar;
}

@end
