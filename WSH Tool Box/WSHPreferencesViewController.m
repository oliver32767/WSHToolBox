//
//  WSHPreferencesViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/17/13.
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

#import "WSHPreferencesViewController.h"
#import "WSHPreferences.h"

#define FORM_HISTORY_ALERT_TAG 1
#define FIELD_VALUES_ALERT_TAG 2

@interface WSHPreferencesViewController ()

@end

@implementation WSHPreferencesViewController

-(id)init
{
    self = [super init];
    if (self) {
        return [super initWithRoot:[self createRootElement]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (QRootElement*)createRootElement
{
    QRootElement* root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"Preferences";

    
    QSection* section1 = [[QSection alloc] initWithTitle:nil];
    section1.footer = @"Report History allows you to keep a history of previously generated reports. Setting this to Off will delete all report history records.";

    QBooleanElement* formHistory = [[QBooleanElement alloc] initWithTitle:@"Report History" BoolValue:[WSHPreferences shouldSaveFormDataHistory]];
    [formHistory setKey:@"formHistory"];
    formHistory.onValueChanged = ^(QRootElement* root){
        [WSHPreferences setShouldSaveFormDataHistory:
         ![WSHPreferences shouldSaveFormDataHistory]];
    };

    [section1 addElement:formHistory];
    [root addSection:section1];
    
    QSection* section2 = [[QSection alloc] init];
    section2.footer = @"Form Values History will make some form fields remember its previous value, or provide autocomplete suggestions based on previous values. Setting this to Off will delete all form values history.";
    
    QBooleanElement* fieldValues = [[QBooleanElement alloc] initWithTitle:@"Form Values History" BoolValue:[WSHPreferences shouldSaveFieldValueHistory]];
    [fieldValues setKey:@"fieldValues"];
    fieldValues.onValueChanged = ^(QRootElement* root){
        [WSHPreferences setShouldSaveFieldValueHistory:
         ![WSHPreferences shouldSaveFieldValueHistory]];
    };
    
    [section2 addElement:fieldValues];
    [root addSection:section2];
    
    return root;
}

-(void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView
{
    [super setQuickDialogTableView:quickDialogTableView];
    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.backgroundColor = [UIColor rootViewBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
