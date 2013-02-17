//
//  WSHDictionaryTemplate.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface McTemplateRenderer : NSObject

//+(NSString*) stringWithContentsOfResourceFile:(NSString*) path;
+(NSString*) render:(NSDictionary*)dict withTemplate:(NSString*)template;
+(NSString*) render:(NSDictionary*)dict withResourceFileTemplate:(NSString*)path;

@end
