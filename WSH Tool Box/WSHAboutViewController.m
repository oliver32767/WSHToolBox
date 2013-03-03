//
//  WSHAboutViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
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


#import "WSHAboutViewController.h"
#import "McTemplateRenderer.h"

#define TEXTFIELD_TAG 1
#define ICON_TAG 2
#define BUTTON_TAG 3

@interface WSHAboutViewController ()

@end

@implementation WSHAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"About";
    }
    return self;
}

- (void)applyMotif
{
    UITextView* textView = (UITextView*) [self.view viewWithTag:TEXTFIELD_TAG];
    textView.layer.cornerRadius = 10;
    textView.layer.borderColor = [UIColor viewBorderColor].CGColor;
    textView.layer.borderWidth = 2.0f;
    self.view.backgroundColor = [UIColor rootViewBackground];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self realignViews];
}

-(void)realignViews
{
    UIView* icon = [self.view viewWithTag:ICON_TAG];
    UIView* button = [self.view viewWithTag:BUTTON_TAG];
    
    icon.center = CGPointMake(self.view.frame.size.width/2, icon.center.y);
    button.center = CGPointMake(self.view.frame.size.width/2, button.center.y);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITextView* textView = (UITextView*) [self.view viewWithTag:TEXTFIELD_TAG];
    // load the template from a resource file
    // just to get file name right
    NSString* fn =
    [NSString stringWithFormat:@"%@/AboutText.txt",
     [[ NSBundle mainBundle ] resourcePath ]];
    // template
    NSError *error;
    NSString* fileContents =
    [NSString stringWithContentsOfFile:fn
                              encoding:NSUTF8StringEncoding error:&error];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self versionBuild] forKey:@"versionBuild"];
    NSString* aboutText = [McTemplateRenderer render:dict withTemplate:fileContents];
    
    textView.text = aboutText;

    [self applyMotif];
}
-(void)viewDidAppear:(BOOL)animated
{
[self realignViews];    
}
-(IBAction) iconClicked
{
    [TestFlight passCheckpoint:@"About icon clicked."];
}

- (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

- (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@.%@", versionBuild, build];
    }
    
    return versionBuild;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
