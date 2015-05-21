//
//  ProviderLoginViewController.h
//  RemedyConnect
//
//  Created by Ravindra Kishan on 06/04/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "RCWebEngine.h"
#import "NetworkViewController.h"
#import "YourPracticeAppDelegate.h"
#import "RCHelper.h"
#import "PAPasscodeViewController.h"
#import "MBProgressHUD.h"
#import "RCRegisterEngine.h"
#import "CreatePINViewController.h"
#import "SessionTime.h"

@interface ProviderLoginViewController : UIViewController<UITextFieldDelegate,WebEngineDelegate,NetworkDelegate,NSXMLParserDelegate,PAPasscodeViewControllerDelegate,MBProgressHUDDelegate,registerWebDelegate>
{
    RCHelper *helper;
    MBProgressHUD *statusHUD;
    BOOL isPassword,isAnimatedUp;
    UITextField *activeField;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *detaillabel;
@property (strong, nonatomic) IBOutlet UILabel *enterLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UIImageView *whiteBackground;


@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSURL *forgotUrl;
@property (nonatomic, strong) NSString *userNameStr;

@end