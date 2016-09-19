//
//  GFEditeMyTrideNameViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/9.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GFEditeMyTrideNameViewControllerDelegate <NSObject>

-(void)modityMyTribeName:(NSString *)textname;

@end

@interface GFEditeMyTrideNameViewController : UIViewController<UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *tribeNameField;
}

@property(nonatomic,retain)NSString *name;
@property(nonatomic,assign)id<GFEditeMyTrideNameViewControllerDelegate> delegate;
@end
