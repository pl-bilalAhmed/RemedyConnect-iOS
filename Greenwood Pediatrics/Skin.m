//
//  Skin.m
//  Your Practice
//
//  Created by Adamek Zoltán on 2013.11.20..
//  Copyright (c) 2013 NewPush LLC. All rights reserved.
//

#import "Skin.h"
#import "FileHandling.h"

@implementation Skin

+(void)applyFile:(NSString *)fileName onImageView:(UIImageView *)imageView {
    NSString *splashPath = [FileHandling getSkinFilePathWithComponent:fileName];
    if (nil != splashPath) {
        UIImage *image = [UIImage imageWithContentsOfFile:splashPath];
        [imageView setImage:image];
    }
}

+(void)applySplashOnImageView:(UIImageView *)imageView {
    [self applyFile:@"splashscreen.png" onImageView:imageView];
}

+(void)applyMainMenuBGOnImageView:(UIImageView *)imageView {
    [self applyFile:@"background.png" onImageView:imageView];
}

+(void)applyMainLogoOnImageView:(UIImageView *)imageView {
    [self applyFile:@"menulogo.png" onImageView:imageView];
}

+(void)applySubLogoOnImageView:(UIImageView *)imageView {
    [self applyFile:@"logo.png" onImageView:imageView];
}

+(void)applyBackgroundOnButton:(UIButton *)button {
    NSString *buttonPath = [FileHandling getSkinFilePathWithComponent:@"button.9.png"];
    if (nil != buttonPath) {
        UIImage *image = [UIImage imageWithContentsOfFile:buttonPath];
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
}

+(void)applySubMenuBGOnView:(UITableView *)view {
    NSString *bgPath = [FileHandling getSkinFilePathWithComponent:@"background_main.png"];
    if (nil != bgPath) {
        UIImage *image = [UIImage imageWithContentsOfFile:bgPath];
        UIImageView *bg = [[UIImageView alloc] initWithImage:image];
        bg.contentMode = UIViewContentModeScaleAspectFill;
        [view setBackgroundView:bg];
    }
}

+(void)applyPageBGOnWebView:(UIWebView *)webView inViewController:(UIViewController *)viewController {
    NSString *bgPath = [FileHandling getSkinFilePathWithComponent:@"background_main.png"];
    if (nil != bgPath) {
        UIImage *image = [UIImage imageWithContentsOfFile:bgPath];
        UIImageView *bg = [[UIImageView alloc] initWithImage:image];
        [viewController.view insertSubview:bg belowSubview:webView];
        bg.contentMode = UIViewContentModeScaleAspectFill;
        bg.frame = viewController.view.bounds;
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setOpaque:NO];
    }
}

@end
