//
//  MultipleSelectionViewController.m
//  CraftApp
//
//  Created by PUN-MAC-012 on 29/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "MultipleSelectionViewController.h"
#import "MCMS.h"

@interface MultipleSelectionViewController ()
{
    MCMS *objMCMS;
}
@end

@implementation MultipleSelectionViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize lblInstructions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lblQuestionText.text = objMCMS.strQuestionText ;
    lblInstructions.text = objMCMS.strInstruction;
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id
{
    objMCMS = [db fnGetTestyourselfMCMS:question_id];
}
//--------------------------------

@end
