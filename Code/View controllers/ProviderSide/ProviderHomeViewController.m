//
//  ProviderHomeViewController.m
//  RemedyConnect
//
//  Created by Ravindra Kishan on 08/04/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "ProviderHomeViewController.h"

@interface ProviderHomeViewController ()

@end

@implementation ProviderHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    practiceName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nameOfPratice"];
    self.village = [[UIImageView alloc]init];
    [self.view addSubview:self.village];
    logic = [Logic sharedLogic];
    [self displayImages];

  
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetAction)
                                                 name:kResetPinNotification
                                               object:nil];
}



-(void)resetAction
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"screatKey"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPath];
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)displayImages
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *unzipPath = [path stringByAppendingPathComponent:@"unzipPath"];
    NSString *imageFilePath = [unzipPath stringByAppendingPathComponent:@"background.png"];
    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
    UIImage *img = [UIImage imageWithData:imageData];
    
    NSString *logoimageFilePath = [unzipPath stringByAppendingPathComponent:@"menulogo.png"];
    NSData *logoimageData = [NSData dataWithContentsOfFile:logoimageFilePath options:0 error:nil];
    UIImage *logoimg = [UIImage imageWithData:logoimageData];
    
    NSString *menuFilePath = [unzipPath stringByAppendingPathComponent:@"button.9.png"];
    NSData *menuimageData = [NSData dataWithContentsOfFile:menuFilePath options:0 error:nil];
    UIImage *menuimg = [UIImage imageWithData:menuimageData];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.imageView.image = img;
                       //self.imageView.contentMode = UIViewContentModeCenter;
                       
                       self.logoImage.image = logoimg;
                       self.logoImage.contentMode = UIViewContentModeCenter;
                       if ((self.logoImage.bounds.size.width > (logoimg.size.width && self.logoImage.bounds.size.height > logoimg.size.height)))
                       {
                           self.logoImage.contentMode = UIViewContentModeScaleAspectFill;
                       }
                       [self.menuBtn setBackgroundImage:menuimg forState:UIControlStateNormal];
                       
                       UIEdgeInsets insets = UIEdgeInsetsMake(50,25, 50,25);
                       UIImage *stretchableImage = [menuimg resizableImageWithCapInsets:insets];
                       [self.messageBtn  setBackgroundImage:stretchableImage forState:UIControlStateNormal];
                       [self.adminBtn setBackgroundImage:stretchableImage forState:UIControlStateNormal];
                   });
}



- (IBAction)menuBtnTapped:(id)sender
{
    CGPoint point = CGPointMake(self.menuBtn.frame.origin.x + self.menuBtn.frame.size.width / 2,
                                self.menuBtn.frame.origin.y + self.menuBtn.frame.size.height);
    [PopoverView showPopoverAtPoint:point
                             inView:self.view
                    withStringArray:[NSArray arrayWithObjects:@"Update Your Practice Info",
                                     @"Choose Your Practice", @"Terms and Conditions",@"About Us",@"Logout",@"Change application mode",nil]
                           delegate:self];
    [logic setUpdateDownloadStarterDelegate:self];
}



- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSString * praticeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nameOfPratice"];
    NSLog(@"%@",praticeName);
    //NSString  * searchPraticeString =[[RCHelper SharedHelper] getSearchURLByName:praticeName];
    switch (index)
    {
        case 0:
            if ([NetworkViewController SharedWebEngine].NetworkConnectionCheck)
            {
                [logic setUpdateDownloadStarterDelegate:self];
                [logic handleActionWithTag:index shouldProceedToPage:FALSE];
            }
            break;
            
        case 1:
            [RCPracticeHelper SharedHelper].isChangePractice =YES;
            [RCPracticeHelper SharedHelper].isLogout =NO;
            [RCPracticeHelper SharedHelper].isApplicationMode =NO;
            [self LogoutTheUser];
            break;
            
          case 2:
            [self performSegueWithIdentifier:@"Terms" sender:self];
            break;
            
         case 3:
            [self performSegueWithIdentifier:@"AboutUs" sender:self];
            break;
            
         case 4:
            [RCPracticeHelper SharedHelper].isChangePractice =NO;
            [RCPracticeHelper SharedHelper].isLogout =YES;
            [RCPracticeHelper SharedHelper].isApplicationMode =NO;
            [self LogoutTheUser];
            break;
            
         case 5:
            [RCPracticeHelper SharedHelper].isChangePractice =NO;
            [RCPracticeHelper SharedHelper].isLogout =NO;
            [RCPracticeHelper SharedHelper].isApplicationMode = YES;
            [self LogoutTheUser];
            break;
            
         default:
            break;
            
    }
    [popoverView dismiss:TRUE];
}



-(void)LogoutTheUser
{
    if ([RCPracticeHelper SharedHelper].isLogout)
    {
        [self hasStartedDownloading:@"Logging Out..."];
    }
    [RCSessionEngine SharedWebEngine].delegate = self;
    [[RCSessionEngine SharedWebEngine] LogoutTheUser];
}


- (void)hasStartedDownloading:(NSString *)processString
{
    if (nil != statusHUD)
    {
        [statusHUD hide:TRUE];
    }
    statusHUD = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [statusHUD setDelegate:self];
    [statusHUD setDimBackground:TRUE];
    [statusHUD show:YES];
    [statusHUD setLabelText:processString];
    [self.view bringSubviewToFront:statusHUD];
}


-(void)clearData
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"screatKey"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPath];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)sendRequest:(NSString *)searchPraticeString
{
    [FileDownloader SharedInstance].delegate = self;
    [[FileDownloader SharedInstance] downloadFileAndParseFrom:searchPraticeString];
}


#pragma mark - HUD handling
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [statusHUD removeFromSuperview];
    statusHUD = nil;
}

#pragma mark - DownloaderUIDelegate
- (void)hasStartedDownloading
{
    statusHUD = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [statusHUD setDelegate:self];
    [statusHUD setDimBackground:TRUE];
    [statusHUD setLabelText:@"Starting download..."];
}

- (void)switchToIndeterminate
{
    [statusHUD setMode:MBProgressHUDModeIndeterminate];
}

- (void)didReceiveResponseForAFileSwitchToDeterminate:(DownloadStatus *)status
{
    [statusHUD setLabelText:@"Downloading..."];
}

- (void)updateProgress:(DownloadStatus *)status
{
    if ([status expectedLength] > 0)
    {
        statusHUD.progress = [status currentLength] / (float)[status expectedLength];
    }
}

- (void)didFinish {
    [statusHUD setMode:MBProgressHUDModeText];
    [statusHUD setLabelText:@"Finished!"];
    [statusHUD hide:YES afterDelay:2];
    // We have to reload the data:
    [logic resetAfterUpdate];
    [self viewDidLoad];
}

- (void)hasFailed {
    [statusHUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to download files"
                                                    message:@"Please check your internet connection and try again."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [logic resetAfterUpdate];
}


-(void)successfullyParsedFiles:(NSMutableArray *)practiceInfo modelData:(Practice *)practice
{
    [statusHUD hide:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AboutUs"])
    {
        AboutUsViewController *aboutController = [segue destinationViewController];
        aboutController.self.Text = @"About";
    }
    if ([segue.identifier isEqualToString:@"Terms"])
    {
        AboutUsViewController *termsController = [segue destinationViewController];
        termsController.self.Text = @"Terms and Conditions";
    }
}

#pragma connectin Manager Delegate
-(void)connectionManagerDidReceiveResponse:(NSDictionary *)pResultDict
{
    [[UIApplication sharedApplication].delegate performSelector:@selector(stopActivity)];
}

-(void)connectionManagerDidFailWithError:(NSError *)error
{
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(stopActivity)];
    UIAlertView *lAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ Please try later", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [lAlert show];
}


#pragma mark - SessionManager delegate
-(void)SessionManagerDidReceiveResponse:(NSDictionary*)pResultDict
{
    [statusHUD hide:YES afterDelay:2];
    if ([[pResultDict objectForKey:@"success"]boolValue])
    {
        if ([RCPracticeHelper SharedHelper].isChangePractice)
        {
            [self clearData];
            [self performSegueWithIdentifier:@"MoveBackToSelectPractice" sender:self];
        }
        else if ([RCPracticeHelper SharedHelper].isLogout)
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"screatKey"];
            NSArray *array = [self.navigationController viewControllers];
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
        }
        else if ([RCPracticeHelper SharedHelper].isApplicationMode)
        {
            [self clearData];
            NSArray *array = [self.navigationController viewControllers];
            [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
        }
    }
}

-(void)SessionManagerDidFailWithError:(NSError *)error
{
    [statusHUD hide:YES afterDelay:2];
    
    UIAlertView *lAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ Please try later", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [lAlert show];
}


@end
