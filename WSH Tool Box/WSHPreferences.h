//
//  WSHPreferences.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/16/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSHPreferences : NSObject

+(NSString*) defaultUserName;
+(void) setDefaultUserName:(NSString*) defaultUserName;

@end
