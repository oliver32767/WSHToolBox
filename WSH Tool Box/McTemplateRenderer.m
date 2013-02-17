//
//  McTemplateRenderer.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright 2013 Oliver Bartley - http://brtly.net
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
//  file except in compliance with the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under
//  the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
//  ANY KIND, either express or implied. See the License for the specific language governing
//  permissions and limitations under the License.
//



#import "McTemplateRenderer.h"

@implementation McTemplateRenderer

+(NSString*) stringWithContentsOfResourceFile:(NSString*) path
{
    NSString* fn = [NSString stringWithFormat:@"%@/%@", [[ NSBundle mainBundle ] resourcePath ], path];
    NSError* err = nil;
    NSString* rv = [NSString stringWithContentsOfFile:fn encoding:NSUTF8StringEncoding error:&err];
    if (err) {
        NSLog(@"Error loading resource %@\n%@", fn, [err description]);
    }
    return rv;
}

+(NSString*) render:(NSDictionary*)dict withResourceFileTemplate:(NSString*)path
{
    return [McTemplateRenderer render:dict withTemplate:[McTemplateRenderer stringWithContentsOfResourceFile:path]];
}

+(NSString*) render:(NSDictionary*)dict withTemplate:(NSString*)template
{
    NSLog(@"Rendering template");
    NSMutableString* result = [[NSMutableString alloc] initWithString:template];
    
    NSString* tokenizePattern = @"\\{\\{(?:\\s)*([\\w]+)(?:\\s)*(?:\\|\\|)??([\\w\\s]*?)\\}\\}";
    NSString* replacePattern = @"\\{\\{(\\s)*%@(\\s)*(\\|\\|)??[\\w\\s]*?\\}\\}";
    
    NSError* regexError = nil;
    
    NSMutableArray* unknownKeys = [[NSMutableArray alloc] init];
    NSMutableArray* unusedKeys = [[NSMutableArray alloc] initWithArray:[dict allKeys]];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:tokenizePattern options:0 error:&regexError];
    if (regexError) {
        NSLog(@"%@", [regexError description]);
    }

    NSUInteger l = [template length];
    NSArray* matches = [regex matchesInString:template options:0 range:NSMakeRange(0, l)];
    NSMutableDictionary* tokens = [[NSMutableDictionary alloc] init];
    
    // extract the tokens from the template
    for (NSTextCheckingResult* match in matches) {
        // populates the dictionary using the pattern {{key||value}}
        // TODO: make this more aware of {{key}} and {{key||}} cases
        [tokens setObject: [template substringWithRange:[match rangeAtIndex:2]]
                   forKey: [template substringWithRange:[match rangeAtIndex:1]]];
    }
    

    // render the template
    for (NSString* token in [tokens allKeys]) {
        if ([dict objectForKey:token]) {
            
            [unusedKeys removeObject:token];
            [result replaceOccurrencesOfString:[NSString stringWithFormat:replacePattern, token]
                                             withString:[NSString stringWithFormat: @"%@", [dict objectForKey:token]]
                                                options:NSRegularExpressionSearch
                                                  range:NSMakeRange(0, [result length])];
        } else {
            [unknownKeys addObject:token];
            [result replaceOccurrencesOfString:[NSString stringWithFormat:replacePattern, token]
                                    withString:[NSString stringWithFormat: @"%@", [tokens objectForKey:token]]
                                       options:NSRegularExpressionSearch
                                         range:NSMakeRange(0, [result length])];
        }
    }
    
    if (unknownKeys.count > 0 || unusedKeys.count >0) {
        if (unknownKeys.count > 0) {
            NSLog(@"The template requested data that was not in the dictionary: %@", unknownKeys);
            
        }
        if (unusedKeys.count > 0) {
            NSLog(@"The dictionary contained data that was not used by the template: %@", unusedKeys);
        }
    }
    return result;
}

@end
