//
//  UIColor+Motif.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/15/13.
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



#import "UIColor+Motif.h"

@implementation UIColor (Motif)

//+(UIColor*) colorWithRGB:(float)hex
//{
//    return [UIColor colorWithRed:((float)((hex && 0xFF0000) >> 16))/255.0
//                           green:((float)((hex && 0xFF00) >> 8))/255.0
//                            blue:((float)(hex && 0xFF))/255.0 alpha:1.0];
//}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+(UIColor*) navigationBarTint
{
//    return [UIColor colorWithHexString:@"13283e"];
    return [UIColor colorWithHexString:@"000"];
}

+(UIColor*) rootViewBackground
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"root-view-background.png"]];
}

+(UIColor*) menuViewBackground
{
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-view-background3.png"]];
//    return [UIColor rootViewBackground];
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"polaroid_@2X.png"]];
}

+(UIColor*) menuButtonBackground
{
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-button-background.png"]];
//        return [UIColor rootViewBackground];
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"shl_@2X.png"]];
}

+(UIColor*) menuButtonBorder
{
    return [UIColor colorWithHexString:@"13283e"];
}

+(UIColor*) menuButtonSelectedBackground
{
//     return [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav-bar-textured.png"]];
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];
//    return [UIColor colorWithHexString:@"cc0b1d2c"];

}

+(UIColor*) menuButtonSelectedBorder
{
    return [UIColor colorWithHexString:@"13283e"];

}

+(UIColor*) menuButtonSelectedTextColor
{
    return [UIColor colorWithHexString:@"FFF"];
}

+(UIColor*) reportViewBackground
{
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"retina_wood_@2X.png"]];
    return [UIColor menuViewBackground];
}

+(UIColor*) labelTextColor
{
    return [UIColor colorWithRed:0.3025 green:0.3375 blue:0.425 alpha:1];
}

+(UIColor*) viewBorderColor
{
    return [UIColor lightGrayColor];
}

+(UIColor*) autocompleteColor
{
    return [UIColor lightGrayColor];
}
@end
