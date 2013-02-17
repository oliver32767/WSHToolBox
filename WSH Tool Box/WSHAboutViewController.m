//
//  WSHAboutViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHAboutViewController.h"
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
    textView.text = fileContents;

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
