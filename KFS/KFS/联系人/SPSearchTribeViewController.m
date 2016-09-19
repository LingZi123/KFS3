//
//  SPSearchTribeViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPSearchTribeViewController.h"
#import "SPTribeProfileViewController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "SPQRCodeReaderViewController.h"

@interface SPSearchTribeViewController ()<UITextFieldDelegate, SPQRCodeReaderViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (assign, nonatomic) BOOL shouldAutoBeginSearch;
@end

@implementation SPSearchTribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if ([SPQRCodeReaderViewController isAvailable]) {
        UIBarButtonItem *qrCodeReaderItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qrcode_scan_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentQRCodeReaderViewController:)];
        self.navigationItem.rightBarButtonItem = qrCodeReaderItem;
    }

    if (self.searchText.length) {
        self.searchTextField.text = self.searchText;
        [self onSearch:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.shouldAutoBeginSearch) {
        self.shouldAutoBeginSearch = NO;
        [self onSearch:nil];
    }
    else {
        if ([self.searchTextField canBecomeFirstResponder]) {
            [self.searchTextField becomeFirstResponder];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.presentingViewController && self.navigationController.viewControllers.firstObject == self) {
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                          style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController:)];
        self.navigationItem.leftBarButtonItem = dismissButton;
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.searchTextField endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchTextField endEditing:YES];
}

#pragma mark - Actions
- (IBAction)onSearch:(id)sender {
    if( [self.searchTextField.text length] == 0 ){
        return;
    }
    
    __weak typeof (self) weakSelf = self;

    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:self.description];
    [self.ywTribeService requestTribeFromServer:self.searchTextField.text completion:^(YWTribe *tribe, NSError *error) {
        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
        if(!error) {
            [weakSelf.searchTextField endEditing:YES];
            [weakSelf presentTribeProfileViewControllerWithTribe:tribe];
        }
        else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:@"未找到该群，请确认群帐号后重试"
                                                             subtitle:nil
                                                                 type:SPMessageNotificationTypeError];
        }
    }];
}

- (void)presentTribeProfileViewControllerWithTribe:(YWTribe *)tribe {
    if (!tribe) {
        return ;
    }
    SPTribeProfileViewController *controller =[self.storyboard instantiateViewControllerWithIdentifier:@"SPTribeProfileViewController"];
    controller.tribe = tribe;

    [self.navigationController setViewControllers:@[controller] animated:YES];
}

- (void)presentQRCodeReaderViewController:(id)sender {
    SPQRCodeReaderViewController *qrCodeReaderViewController = [[SPQRCodeReaderViewController alloc] init];
    qrCodeReaderViewController.delegate = self;
    [self.navigationController pushViewController:qrCodeReaderViewController animated:YES];
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextField) {
        [self onSearch:nil];
    }
    return YES;
}

#pragma mark - SPQRCodeReaderViewControllerDelegate
- (void)qrcodeReaderViewController:(SPQRCodeReaderViewController *)controller didGetResult:(NSString *)result {
    NSURL *url = [NSURL URLWithString:result];

    if ([url.scheme isEqualToString:@"openimdemo"]) {
        if ([url.path isEqualToString:@"/searchTribe"]) {
            NSString *query = [url.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [query componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts lastObject] forKey:[elts firstObject]];
            }
            if ([params[@"tribeId"] length]) {
                [self.navigationController popToViewController:self animated:YES];
                self.searchTextField.text = params[@"tribeId"];
                self.shouldAutoBeginSearch = YES;
            }
        }
    }
}

#pragma makr - 
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}
@end
