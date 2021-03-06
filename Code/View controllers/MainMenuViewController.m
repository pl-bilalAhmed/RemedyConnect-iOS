//
//  MainMenuViewController.m
//  MyPractice
//
//  Created by Adamek Zoltán on 2013.10.17..
//  Copyright (c) 2013 NewPush LLC. All rights reserved.
//

#import "MainMenuViewController.h"
#import "Logic.h"
#import "Skin.h"
#import "PopoverView.h"
#import "PracticeSearchViewController.h"
#import "AboutTermsController.h"
#import "MainMenuButtonCell.h"
#import "TestFlight.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

Logic *logic;
NSArray *menu;


- (void)viewDidLoad {
    [self setMenuHeightInOrientation:[UIApplication sharedApplication].statusBarOrientation beforeRotation:NO];
    logic = [Logic sharedLogic];
    [Skin applyMainMenuBGOnImageView:_backgroundImage];
    [Skin applyMainLogoOnImageView:_logoImageView];
    [Skin applyBackgroundOnButton:_menuButton];
    menu = [logic getDataToDisplayForMainMenu];
}

- (void)setMenuHeightInOrientation:(UIInterfaceOrientation)interfaceOrientation
                    beforeRotation:(BOOL)beforeRotation {
    
    CGFloat maxHeight = 360;
    CGFloat minHeight = 150;
    CGFloat screenSizingRatioLandscape = 3.5;
    CGFloat screenSizingRatioPortrait = 2;
    CGFloat height = 0;
    CGFloat screenRatioHeight = 0;
    CGFloat screenSizingRatio = 0;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        screenSizingRatio = screenSizingRatioLandscape;
    }
    else {
        screenSizingRatio = screenSizingRatioPortrait;
    }
    if (beforeRotation) {
        screenRatioHeight = self.view.frame.size.width / screenSizingRatio;
    }
    else {
        screenRatioHeight = self.view.frame.size.height / screenSizingRatio;
    }
    
    height = MAX(minHeight, MIN(screenRatioHeight, maxHeight));
    [self menuHeightConstraint].constant = height;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((UIInterfaceOrientationIsLandscape(currentOrientation) &&
                UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) ||
                (UIInterfaceOrientationIsPortrait(currentOrientation) &&
                 UIInterfaceOrientationIsLandscape(toInterfaceOrientation))) {

        [self setMenuHeightInOrientation:toInterfaceOrientation beforeRotation:YES];
    }
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [menu count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainMenuButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuButtonCell" forIndexPath:indexPath];
    [cell.button setTitle:[[menu objectAtIndex:indexPath.row] objectForKey:@"name"] forState:UIControlStateNormal];
    [[cell button] addTarget:self action:@selector(menuClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [Skin applyBackgroundOnButton:cell.button];
    return cell;
}

- (IBAction)menuClick:(id)sender event:(id)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint currentTouchPos = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:currentTouchPos];
    [logic setMainMenuDelegate:self];
    [logic handleActionWithTag:indexPath.row shouldProceedToPage:FALSE];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect wrapperFrame = collectionView.frame;
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        wrapperFrame.size.width /= 3;
        wrapperFrame.size.height /= 2;
    }
    else {
        wrapperFrame.size.width /= 2;
        wrapperFrame.size.height /= 3;
    }
    wrapperFrame.size.width -= 20;
    wrapperFrame.size.height -= 20;
    CGSize retval = wrapperFrame.size;
    return retval;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (IBAction)menuButtonPressed:(id)sender {
    CGPoint point = CGPointMake(_menuButton.frame.origin.x + _menuButton.frame.size.width / 2,
                                _menuButton.frame.origin.y + _menuButton.frame.size.height);
    [PopoverView showPopoverAtPoint:point
                             inView:self.view
                    withStringArray:[NSArray arrayWithObjects:@"Update Your Practice Info",
                                     @"Choose Your Practice", @"Terms and Conditions", @"About", nil]
                           delegate:self];
}

- (void)
popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [logic setUpdateDownloadStarterDelegate:self];
            [logic handleActionWithTag:0 shouldProceedToPage:FALSE];
            break;
        case 1:
            [logic resetBeforeSelection];
            [self performSegueWithIdentifier:@"BackToPracticeSearch" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"toTerms" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"toAbout" sender:self];
            break;
    }
    [popoverView dismiss:TRUE];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAbout"]) {
        AboutTermsController *aboutController = [segue destinationViewController];
        [aboutController setWebTitle: @"About"];
        [aboutController setWebText: [logic getAboutHTML]];
    }
    if ([segue.identifier isEqualToString:@"toTerms"]) {
        AboutTermsController *termsController = [segue destinationViewController];
        [termsController setWebTitle: @"Terms and Conditions"];
        [termsController setWebText: [logic getTermsHTML]];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [self setMenuHeightInOrientation:[UIApplication sharedApplication].statusBarOrientation beforeRotation:NO];
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:TRUE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:FALSE animated:TRUE];
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:TRUE];
}

#pragma mark - HUD handling
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[statusHUD removeFromSuperview];
	statusHUD = nil;
}

#pragma mark - DownloaderUIDelegate
- (void)hasStartedDownloading {
    statusHUD = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [statusHUD setDelegate:self];
    [statusHUD setDimBackground:TRUE];
    [statusHUD setLabelText:@"Starting download..."];
}

- (void)switchToIndeterminate {
    [statusHUD setMode:MBProgressHUDModeIndeterminate];
}

- (void)didReceiveResponseForAFileSwitchToDeterminate:(DownloadStatus *)status {
    [statusHUD setLabelText:@"Downloading..."];
}

- (void)updateProgress:(DownloadStatus *)status {
    if ([status expectedLength] > 0) {
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

- (IBAction)resetToHere:(UIStoryboardSegue *)segue {
    [logic unwind];
}

@end
