//
//  ContactMainViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ContactMainViewController.h"
#import "SPKitExample.h"
#import "SPContactRequestListController.h"
#import "SPUtil.h"
#import "AppDelegate.h"
#import "SPTribeInfoEditViewController.h"
#import "SPContactCell.h"
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWIndicator.h>
#import "GFTribeListViewController.h"
#import "GFAddContactViewController.h"
#import "SPSearchTribeViewController.h"
#import "SPContactRequestListController.h"


@interface ContactMainViewController ()

@end

@implementation ContactMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeView];
}

-(void)makeView{
    
    _contactTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _contactTableView.delegate=self;
    _contactTableView.dataSource=self;
    _contactTableView.tableFooterView=[[UIView alloc]init];
    _contactTableView.rowHeight=64.0f;
    [_contactTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
            forCellReuseIdentifier:@"ContactCell"];
    
    [self.view addSubview:_contactTableView];

    self.navigationItem.title = @"联系人";
    if (self.mode == SPContactListModeNormal) {
        if (sectionOneArray==nil) {
            sectionOneArray=[[NSArray alloc]initWithObjects:@"新朋友请求",@"群组", nil];
        }
        addBar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"添加"]style:UIBarButtonItemStylePlain target:self action:@selector(addBarClick:)];
        self.navigationItem.rightBarButtonItem=addBar;
        
    }
    else {
        self.navigationItem.title = @"选择联系人";
        
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(doneBarButtonItemPressed:)];

        
        self.navigationItem.rightBarButtonItem = doneButtonItem;
        [_contactTableView setEditing:YES animated:NO];
    }
    
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.presentingViewController) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonItemPressed:)];
        
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    
    [_contactTableView deselectRowAtIndexPath:_contactTableView.indexPathForSelectedRow animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (po&&po.delegate) {
        po.delegate=nil;
    }
}

#pragma mark-addBarClick

-(void)addBarClick:(UIBarButtonItem *)sender{
    
    if (po) {
        po=nil;
    }
    po=[[PopViewController alloc]init];
    po.modalPresentationStyle=UIModalPresentationPopover;
    //设置依附的按钮
    po.popoverPresentationController.barButtonItem=self.navigationItem.rightBarButtonItem;
    //可以指示小箭头的颜色
    po.popoverPresentationController.backgroundColor=[UIColor whiteColor];
    po.preferredContentSize=CGSizeMake(400, 200);
    po.delegate=self;
    po.popoverPresentationController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    po.popoverPresentationController.delegate=self;
    
    [self presentViewController:po animated:YES completion:nil];
 
}


#pragma mark - Data
- (void)cancelBarButtonItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doneBarButtonItemPressed:(id)sender {
    NSMutableArray *selectedIDs = [NSMutableArray array];
    NSArray *indexPathsForSelectedRows = [_contactTableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in indexPathsForSelectedRows) {
        YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSString *personId = person.personId;
        if (personId) {
            [selectedIDs addObject:personId];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(contactListController:didSelectPersonIDs:)]) {
        [self.delegate contactListController:self didSelectPersonIDs:[selectedIDs copy]];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark-UIPopoverPresentationControllerDelegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

#pragma mrak-MyPopViewControllerDelegate
-(void)didCellSelected:(NSInteger)row viewController:(UIViewController *)vc{
    [vc dismissViewControllerAnimated:YES completion:nil];
    //添加好友
    if (row==0) {
        GFAddContactViewController *addcvc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"GFAddContactViewController"];
        [self.navigationController pushViewController:addcvc animated:YES
         ];
        
        
    }
    //创建群
    else if (row==1) {
        SPTribeInfoEditViewController *controller = [[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"SPTribeInfoEditViewController"];
        controller.mode=SPTribeInfoEditModeCreateNormal;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        SPSearchTribeViewController *searchvc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"SPSearchTribeViewController"];
        [self.navigationController pushViewController:searchvc animated:YES];
    }
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.mode==SPContactListModeNormal) {
         return self.fetchedResultsController.sections.count+1;
    }
    else{
        return self.fetchedResultsController.sections.count;
    }
}


#pragma mark-UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.mode==SPContactListModeNormal) {
        if (section==0) {
            return 2;
        }
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section-1];
        return [sectionInfo numberOfObjects];
    }
    else
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.mode==SPContactListModeNormal) {
        if (indexPath.section==0) {
            
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"createTribeCell"];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"createTribeCell"];
            }
            cell.imageView.image=[UIImage imageNamed:[sectionOneArray objectAtIndex:indexPath.row]];
//            if (!cell.imageView.image) {
//                cell.imageView.image=[UIImage imageNamed:@"头像90"];
//            }
            cell.textLabel.text=[sectionOneArray objectAtIndex:indexPath.row];
            return cell;
        }
    }
    
    SPContactCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                                         forIndexPath:indexPath];
    
    NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if (self.mode==SPContactListModeNormal) {
        newIndexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];

    }
    
    YWPerson *person = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    cell.identifier = person.personId;
    
    __block NSString *displayName = nil;
    __block UIImage *avatar = nil;
    //  SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实APP中一般都需要替换为你真实的实现。
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
        displayName = aDisplayName;
        avatar = aAvatarImage;
    }];
    
    if (!displayName || avatar == nil ) {
        displayName = person.personId;
        
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(cell) weakCell = cell;
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.contactTableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.contactTableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.contactTableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.contactTableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  }];
    }
    
    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }
    
    [cell configureWithAvatar:avatar title:displayName subtitle:nil];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.mode==SPContactListModeNormal) {
        if (section==0) {
            return @" ";
        }
        if (section >= [[self.fetchedResultsController sectionIndexTitles] count]+1) {
            return nil;
        }
        return [self.fetchedResultsController sectionIndexTitles][(NSUInteger)section-1];
    }
    else{
        if (section >= [[self.fetchedResultsController sectionIndexTitles] count]) {
            return nil;
        }
        return [self.fetchedResultsController sectionIndexTitles][(NSUInteger)section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (titleArray==nil) {
        titleArray=[[NSMutableArray alloc]init];
        
        if (self.mode==SPContactListModeNormal) {
            [titleArray addObject:@" "];
            [titleArray addObjectsFromArray:[self.fetchedResultsController sectionIndexTitles]];
        }
        else{
            [titleArray addObjectsFromArray:[self.fetchedResultsController sectionIndexTitles]];
        }
    }
    
    return titleArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mode==SPContactListModeNormal)
    {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                SPContactRequestListController *vc=[[SPContactRequestListController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                GFTribeListViewController *vc=[[GFTribeListViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else{
            NSIndexPath *newpath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
            YWPerson *person = [self.fetchedResultsController objectAtIndexPath:newpath];
            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
        }

    }
    else if(self.mode == SPContactListModeMultipleSelection) {
        return;
    }

    else {
        // 取消选中之前已选中的 cell
        NSMutableArray *selectedRows = [[tableView indexPathsForSelectedRows] mutableCopy];
        [selectedRows removeObject:indexPath];
        for (NSIndexPath *indexPath in selectedRows) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode==SPContactListModeNormal) {
        if (indexPath.section==0) {
            return NO;
        }
    }
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.mode == SPContactListModeMultipleSelection || self.mode == SPContactListModeSingleSelection) {
            return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
        }
        else{
            if (indexPath.section==0) {
                return UITableViewCellEditingStyleNone;
            }
        }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.mode == SPContactListModeNormal) {
    YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] removeContact:person withResultBlock:^(NSError *error, NSArray *personArray) {
        if (error == nil) {
            [YWIndicator showTopToastTitle:nil content:@"删除好友成功" userInfo:nil withTimeToDisplay:1.5f andClickBlock:nil];
            [weakSelf.contactTableView reloadData];
        } else {
            [YWIndicator showTopToastTitle:nil content:@"删除好友失败" userInfo:nil withTimeToDisplay:1.5f andClickBlock:nil];
        }
    }];
        }
}

#pragma mark-搜索
- (void)searchBarButtonItemPressed:(id)sender {
    //    SPSearchContactViewController *controller = [[SPSearchContactViewController alloc] init];
    //    [self.navigationController pushViewController:controller
    //                                         animated:YES];
}



#pragma mark - FRC
- (YWFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        YWIMCore *imcore = [SPKitExample sharedInstance].ywIMKit.IMCore;
        _fetchedResultsController = [[imcore getContactService] fetchedResultsControllerWithListMode:YWContactListModeAlphabetic imCore:imcore];
        
        __weak typeof(self) weakSelf = self;
        [_fetchedResultsController setDidChangeContentBlock:^{
            [weakSelf.contactTableView reloadData];
        }];
        
        [_fetchedResultsController setDidResetContentBlock:^{
            [weakSelf.contactTableView reloadData];
        }];
    }
    return _fetchedResultsController;
}

@end
