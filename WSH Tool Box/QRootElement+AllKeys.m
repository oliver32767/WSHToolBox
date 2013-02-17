//
//  QRootElement+AllKeys.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "QRootElement+AllKeys.h"

@implementation QRootElement (AllKeys)

// iterate over each element in each section, and add its key to an array, if possible
-(NSArray*)allElementKeys
{
    NSMutableArray* keys = [[NSMutableArray alloc] init];
    
    NSEnumerator* s = [[self sections] objectEnumerator];
    NSEnumerator* e = nil;
    QSection* section = nil;
    QElement* element = nil;
    while (section = [s nextObject]) {
        e = [[section elements] objectEnumerator];
        while (element = [e nextObject]) {
            if ([element isKindOfClass:[QEntryElement class]]) {
                if ((QEntryElement*) element.key) {
                    [keys addObject:(QEntryElement*) element.key];
                }
            }
        }
    }
    return keys;
}

@end
