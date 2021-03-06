//
//  FileHandling.h
//  Greenwood Pediatrics
//
//  Created by Adamek Zoltán on 2013.04.03..
//  Copyright (c) 2013 NewPush LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandling : NSObject

#pragma mark - Methods for interacting with the file system
+(NSString *)getDocumentsPath:(BOOL)temp;
+(NSString *)getFilePathWithComponent:(NSString *)pathComponent inTemp:(BOOL)temp;
+(Boolean)doesIndexExists:(BOOL)temp;
+(void)prepareSkinDirectory:(BOOL)temp;
+(void)prepareTempDirectory;
+(NSString *)getEffectiveSkinDirectory:(BOOL)temp;
+(NSString *)getSkinFilePathWithComponent:(NSString *)pathComponent inTemp:(BOOL)temp;
+(void)emptySandbox:(BOOL)temp;
+(void)unTempFiles;
+(void)unzipFileInPlace:(NSString *)zipPath inTemp:(BOOL)temp;

@end
