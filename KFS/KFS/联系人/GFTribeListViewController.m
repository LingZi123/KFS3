//
//  GFTribeListViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/7.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFTribeListViewController.h"
#import "SPTribeInfoEditViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import "SPContactCell.h"

@interface GFTribeListViewController ()

@end

@implementation GFTribeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeView{
    
    //    searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 8, CGRectGetWidth(self.frame)-40, 30)];
    //    //    searchBtn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    //    searchBtn.backgroundColor=[UIColor greenColor];
    //    [self addSubview:searchBtn];
    
    _tribeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _tribeTableView.delegate=self;
    _tribeTableView.dataSource=self;
    _tribeTableView.tableFooterView=[[UIView alloc]init];
    _tribeTableView.rowHeight=64.0f;
    [_tribeTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
          forCellReuseIdentifier:@"ContactCell"];
    self.navigationItem.title=@"群组";
    [self.view addSubview:_tribeTableView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
    [self addTribeCallbackBlocks];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeTribeCallbackBlocks];
}

- (void)addTribeCallbackBlocks {
    __weak __typeof(self) weakSelf = self;
    [[self ywTribeService] addDidExpelFromTribeBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
    
    [[self ywTribeService] addMemberDidJoinBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[[weakSelf ywIMCore] getLoginService] currentLoginedUser];
        if ([person isEqualToPerson:me]) {
            [weakSelf insertTribeToTableViewWithTribeID:tribeID];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
    
    
    [[self ywTribeService] addMemberDidExitBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[[weakSelf ywIMCore] getLoginService] currentLoginedUser];
        if ([person isEqualToPerson:me]) {
            [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
    
    
    [[self ywTribeService] addTribeDidDisbandBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

- (void)removeTribeCallbackBlocks {
    [[self ywTribeService] removeDidExpelFromTribeBlockForKey:self.description];
    [[self ywTribeService] removeMemberDidJoinBlockForKey:self.description];
    [[self ywTribeService] removeMemberDidExitBlockForKey:self.description];
    [[self ywTribeService] removeTribeDidDisbandBlockForKey:self.description];
}


- (void)reloadData {
    NSArray *tribes = [self.ywTribeService fetchAllTribes];
    [self configureDataWithTribes:tribes];
    [_tribeTableView reloadData];
}

- (void)requestData {
    if ([[[self ywIMCore] getLoginService] isCurrentLogined]) {
        __weak typeof(self) weakSelf = self;
        [self.ywTribeService requestAllTribesFromServer:^(NSArray *tribes, NSError *error) {
            if( error == nil ) {
                [weakSelf configureDataWithTribes:tribes];
                [weakSelf.tribeTableView reloadData];
            } else {
                [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                    title:@"获取群列表失败"
                                                                 subtitle:nil
                                                                     type:SPMessageNotificationTypeError];
            }
//            [weakSelf.tribeTableView endRefreshing];
        }];
    }
}

- (void)configureDataWithTribes:(NSArray *)tribes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *normalTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeNormal) stringValue]] = normalTribes;
    NSMutableArray *multipleChatTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeMultipleChat) stringValue]] = multipleChatTribes;
    
    for (YWTribe *tribe in tribes) {
        if (tribe.tribeType == YWTribeTypeNormal) {
            [normalTribes addObject:tribe];
        }
        else if (tribe.tribeType == YWTribeTypeMultipleChat) {
            [multipleChatTribes addObject:tribe];
        }
    }
    self.groupedTribes = dictionary;
}

- (void)insertTribeToTableViewWithTribeID:(NSString *)tribeId {
    YWTribe *tribe = [[self ywTribeService] fetchTribe:tribeId];
    if (!tribe) {
        return;
    }
    
    NSInteger section = tribe.tribeType;
    NSMutableArray *tribes = self.groupedTribes[[@(section) stringValue]];
    if (!tribes) {
        return;
    }
    
    NSInteger row = [tribes indexOfObject:tribe];
    if (row != NSNotFound) {
        return;
    }
    
    [tribes addObject:tribe];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tribes.count - 1 inSection:section];
    [self.tribeTableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)deleteTribeFromTableViewWithTribeID:(NSString *)tribeId tribeType:(YWTribeType)tribeType {
    if (!tribeId) {
        return;
    }
    
    NSInteger section = tribeType;
    NSMutableArray *tribes = self.groupedTribes[[@(section) stringValue]];
    if (!tribes) {
        return;
    }
    
    NSInteger row = [tribes indexOfObjectPassingTest:^BOOL(YWTribe *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.tribeId isEqualToString:tribeId]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (row == NSNotFound) {
        return;
    }
    
    [tribes removeObjectAtIndex:row];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tribeTableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedTribes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *groupedTribesKey = @(section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    return tribes.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *groupedTribesKey = @(section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    if (section == 0) {
        return tribes.count ? @"普通群" : nil;
    }
    else if (section == 1) {
        return tribes.count ? @"多聊群" : nil;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithWhite:242./255 alpha:1.0];
    header.textLabel.textColor = [UIColor colorWithWhite:155./255 alpha:1.0];
    header.textLabel.font = [UIFont systemFontOfSize:12.0];
    header.textLabel.shadowColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    
    SPContactCell *cell = nil;
    if( indexPath.row >= [tribes count] ) {
        NSAssert(0, @"数据出错了");
    }
    else {
        YWTribe *tribe = tribes[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                               forIndexPath:indexPath];
        
        UIImage *avatar = [[SPUtil sharedInstance] avatarForTribe:tribe];
        if (!avatar) {
            avatar=[UIImage imageNamed:@"头像120"];
        }
        [cell configureWithAvatar:avatar
                            title:tribe.tribeName
                         subtitle:nil];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSMutableArray *tribes = self.groupedTribes[groupedTribesKey];
    YWTribe *tribe = [tribes objectAtIndex:indexPath.row];
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithTribe:tribe fromNavigationController:self.navigationController];
}


#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}


@end
