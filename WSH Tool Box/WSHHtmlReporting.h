//
//  WSHHtmlReporting.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/15/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSHHtmlReporting <NSObject>

-(BOOL) generateHtml:(NSString *__autoreleasing *)report error:(NSError *__autoreleasing *)err;

@end
