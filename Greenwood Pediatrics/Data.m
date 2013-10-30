//
//  Data.m
//  Greenwood Pediatrics
//
//  Created by Adamek Zoltán on 2013.07.05..
//  Copyright (c) 2013 NewPush LLC. All rights reserved.
//

#import "Data.h"

NSString* const FEED_ROOT = @"https://cms.pediatricweb.com/mobile-app";

@interface Data ()
@end

@implementation Data

// @TODO: wrap this in a normal property
+(void)saveFeedRoot:(NSString *)feedRoot {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:feedRoot forKey:@"feedRoot"];
    [defaults synchronize];
}

+(NSString *)getFeedRoot {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [defaults objectForKey:@"feedRoot"];
    return result;
}

+(void)saveDesignPackURL:(NSString *)designPackURL {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:designPackURL forKey:@"designPackURL"];
    [defaults synchronize];
}

+(NSString *)getDesignPackURL {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [defaults objectForKey:@"designPackURL"];
    return result;
}

@end