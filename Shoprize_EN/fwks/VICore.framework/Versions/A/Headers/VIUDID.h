//
//  OpenUDID.h
//  openudid
//
//  initiated by Yann Lechelle (cofounder @Appsfire) on 8/28/11.
//  Copyright 2011 OpenUDID.org
//
//  Main branches
//      iOS code: https://github.com/ylechelle/OpenUDID
//

/*
 *    !!! IMPORTANT !!!
 *
 *    IF YOU ARE GOING TO INTEGRATE OpenUDID INSIDE A (STATIC) LIBRARY,
 *    PLEASE MAKE SURE YOU REFACTOR THE OpenUDID CLASS WITH A PREFIX OF YOUR OWN,
 *    E.G. ACME_OpenUDID. THIS WILL AVOID CONFUSION BY DEVELOPERS WHO ARE ALSO
 *    USING OpenUDID IN THEIR OWN CODE.
 *
 *    !!! IMPORTANT !!!
 *
 */

/*
 *   http://en.wikipedia.org/wiki/Zlib_License
 *
 *   This software is provided 'as-is', without any express or implied
 *   warranty. In no event will the authors be held liable for any damages
 *   arising from the use of this software.
 *
 *   Permission is granted to anyone to use this software for any purpose,
 *   including commercial applications, and to alter it and redistribute it
 *   freely, subject to the following restrictions:
 *
 *   1. The origin of this software must not be misrepresented; you must not
 *   claim that you wrote the original software. If you use this software
 *   in a product, an acknowledgment in the product documentation would be
 *   appreciated but is not required.
 *
 *   2. Altered source versions must be plainly marked as such, and must not be
 *   misrepresented as being the original software.
 *
 *   3. This notice may not be removed or altered from any source
 *   distribution.
 */

#import <Foundation/Foundation.h>
#import <VICore/VIExtra.h>

#define kOpenUDIDErrorNone			0
#define kOpenUDIDErrorOptedOut		1
#define kOpenUDIDErrorCompromised	2

@interface VIUDID : NSObject {}

/**
 *    获得设备的唯一ID号
 *    @returns 返回设备的UUID信息,这个是带有 - 格式的
 */
+ (NSString *)value;

/**
 *    获得没有 “-”格式的设备ID号
 *    @returns 获得设备的信息ID号
 */
+ (NSString *)valueNo_;

/**
 *    传入带Error的参数信息
 *    @param error 传入的ID信息
 *    @returns 返回常规的UUID信息
 */
+ (NSString *)valueWithError:(NSError **)error;

/**
 *    是否带参输出
 *    @param optOutValue 类型
 */
+ (void)setOptOut:(BOOL)optOutValue;

@end

