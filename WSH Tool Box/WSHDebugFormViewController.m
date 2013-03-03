//
//  WSHDebugFormViewController.m
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


#import "WSHDebugFormViewController.h"
#import "WSHDebugReport.h"
#import "WSHHtmlReportViewController.h"
#import "WSHPreferences.h"
#import "UIImage+Motif.h"
#import "WSHInfoViewController.h"

@interface WSHDebugFormViewController ()

@end

@implementation WSHDebugFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QRootElement*)createRootElement {
    QRootElement* root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"Debug Report";
    
    QEntryElement* name = [[QEntryElement alloc] initWithTitle:@"Name" Value:[WSHPreferences defaultFieldValueWithKey:@"name"] Placeholder:nil];
    [name setKey:@"name"];

    QSection* first = [[QSection alloc] initWithTitle:@"Inputs"];
    QAutoEntryElement* autocomplete = [[QAutoEntryElement alloc] initWithTitle:@"Autocomplete" Value:nil Placeholder:@"start typing for suggestions"];
    [autocomplete setAutoCompleteValues:[WSHPreferences autocompleteValuesWithKey:@"chemicalName"]];
    [autocomplete setKey:@"autocomplete"];

    QDateTimeInlineElement* date = [[QDateTimeInlineElement alloc] initWithTitle:@"Date & Time" date:[NSDate date]];
    [date setKey:@"date"];
    
    QDecimalElement* vaporPressure = [[QDecimalElement alloc] initWithTitle:@"Vapor Pressure" value:0];
    [vaporPressure setKey:@"vaporPressure"];
    [vaporPressure setFractionDigits:1];
    
    [first addElement:name];
    [first addElement:autocomplete];
    [first addElement:date];
    [first addElement:vaporPressure];
    [root addSection:first];
    
    
    
    QSection* actions = [[QSection alloc] init];
    QButtonElement* calculate = [[QButtonElement alloc] initWithTitle:@"Calculate"];
    [calculate setKey:@"calculate"];
    calculate.controllerAction = @"onCalculate:";
    [actions addElement:calculate];
    
    [root addSection:actions];
    return root;
}

-(void) onAccessory:(id)sender
{
    //NSString* URL = @"http://www.stps.gob.mx/DGIFT_STPS/PDF/2005TLVsBEIsofACGIHHandbook.pdf"
    NSString* URL = @"http://webwiser.nlm.nih.gov/knownSubstanceSearch.do";
    WSHInfoViewController* viewController = [[WSHInfoViewController alloc] initWithURLString:URL];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void) onCalculate:(id)sender
{
    WSHFormData* form = [self formData];
    form.subtitle = [form objectForKey:@"autocomplete"];
    WSHDebugReport* report = [[WSHDebugReport alloc] initWithFormData:form];
    [self addFormToHistory:form];
    [self showHtmlReport:report];
}

-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if ([element.key isEqualToString:@"calculate"]) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage submitAccessory] forState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 0, 24, 24);
//        [button addTarget:self action:@selector(onCalculate:) forControlEvents:UIControlEventTouchUpInside];
//        cell.accessoryView = button;

        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else if ([element.key isEqualToString:@"vaporPressure"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
        //[button setImage:[UIImage infoAccessory] forState:UIControlStateNormal];
        //button.frame = CGRectMake(0, 0, 24, 24);
        [button addTarget:self action:@selector(onAccessory:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }
}

@end
