//
//  GFAddContactViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFAddContactViewController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "SPContactCell.h"
#import "SPContactManager.h"
#import "MBProgressHUD.h"

@interface GFAddContactViewController ()

@end

@implementation GFAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加好友";
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
         forCellReuseIdentifier:@"ContactCell"];
    _mytableView.tableFooterView = [[UIView alloc] init];
    _mytableView.tableFooterView.backgroundColor = [UIColor clearColor];
    
    
    self.cachedAvatars = [NSMutableDictionary dictionary];
    self.cachedDisplayNames = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_searchTextField becomeFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_searchTextField resignFirstResponder];
}

- (IBAction)searchBtnClick:(id)sender {
    
    if( [_searchTextField.text length] == 0 ){
        return;
    }
    [_searchTextField resignFirstResponder];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    YWPerson *person = [[YWPerson alloc] initWithPersonId:_searchTextField.text];
    __weak __typeof(self) weakSelf = self;
    
    [[[self ywIMCore]getContactService] asyncGetProfileFromServerForPerson:person withTribe:nil withProgress:nil andCompletionBlock:^(BOOL aIsSuccess, YWProfileItem *item) {
        if (aIsSuccess && item.person) {
            
            [hud hideAnimated:YES];
            if (item.displayName) {
                weakSelf.cachedDisplayNames[item.person.personId] =item.displayName;
            }
            if (item.avatar) {
                weakSelf.cachedAvatars[item.person.personId] = item.avatar;
            }
            weakSelf.results = @[item.person];
            [weakSelf.mytableView reloadData];
        }
        else {
            
            hud.label.text=@"未找到该用户，请确认帐号后重试";
            [hud hideAnimated:YES afterDelay:3.f];
        }
    } ];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextField) {
        [self searchBtnClick:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.results = nil;
    [self.mytableView reloadData];
    
    return YES;
}

#pragma mark - UITableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    
    NSString *name = nil;
    UIImage *avatar = nil;
    
    // 使用服务端的资料
    name = self.cachedDisplayNames[person.personId];
    if (!name) {
        name = person.personId;
    }
    avatar = self.cachedAvatars[person.personId];
    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }
    
    SPContactCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                                         forIndexPath:indexPath];
    [cell configureWithAvatar:avatar title:name subtitle:nil];
    
    cell.backgroundColor=[UIColor clearColor];
    BOOL isMe = [person.personId isEqualToString:[[[self ywIMCore] getLoginService] currentLoginedUserId]];
    BOOL isFriend = [[[self ywIMCore] getContactService] ifPersonIsFriend:person];
    
    if (isMe || isFriend) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        cell.accessoryView = label;
        if (isMe) {
            label.text = @"自己";
        }
        else {
            label.text = @"好友";
        }
        [label sizeToFit];
    }
    else {
        cell.accessoryView = nil;
        CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect accessoryViewFrame = CGRectMake(windowWidth - 100, (cell.frame.size.height - 30)/2, 80, 30);
        UIButton *button = [[UIButton alloc] initWithFrame:accessoryViewFrame];
        [button setTitle:@"添加好友" forState:UIControlStateNormal];
        UIColor *color = [UIColor colorWithRed:0 green:180./255 blue:1.0 alpha:1.0];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.layer.borderColor = color.CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 4.0f;
        button.backgroundColor = [UIColor clearColor];
        button.clipsToBounds = YES;
        [button addTarget:self
                   action:@selector(addContactButtonTapped:event:)
         forControlEvents:UIControlEventTouchUpInside];
        //        cell.accessoryView = button;
        [cell.contentView addSubview:button];;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mytableView deselectRowAtIndexPath:indexPath animated:YES];
    YWPerson *person = self.results[indexPath.row];
    
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    BOOL isMe = [person.personId isEqualToString:[[[self ywIMCore] getLoginService] currentLoginedUserId]];
    return !isMe;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    [[SPContactManager defaultManager] addContact:person];
    
    [self.mytableView reloadData];
}

- (void)addContactButtonTapped:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.mytableView];
    NSIndexPath *indexPath = [self.mytableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        [self tableView: self.mytableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}
@end
