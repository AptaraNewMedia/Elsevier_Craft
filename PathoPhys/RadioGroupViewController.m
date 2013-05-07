//
//  RadioGroupViewController.m
//  CraftApp
//
//  Created by PUN-MAC-012 on 29/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "RadioGroupViewController.h"
#import "RADIOHEADING.h"
#import "RADIOBUTTONS.h"
#import "Feedback.h"
#import "RadioGroupView.h"
#import <QuartzCore/QuartzCore.h>
#import "TestYourSelfViewController.h"

@interface RadioGroupViewController ()
{
    RADIOBUTTONS *objRB;
    RADIOHEADING *objRH;
    Feedback *objFeedback;
    RadioGroupView *radioView;
    UIImage *imgRadio;
    UIImage *imgRadioSelected;    
    
    NSMutableArray *arrRadios;
    
    int int_x;
    int int_y;
    int arrcount;
    
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;

    UIView *feedbackView;
    CGRect visibleRect;
    NSInteger currentOrientaion;
    
    float y_feedback_p;
    float y_feedback_l;
    
    float x_feedback_p;
    float x_feedback_l;
}
@end

@implementation RadioGroupViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize lblOption1;
@synthesize lblOption2;
@synthesize lblOption3;
@synthesize lblOptionHiding;

@synthesize scrollRadioOption;
@synthesize intVisited;
@synthesize strVisitedAnswer;
@synthesize parentObject;

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
    lblQuestionText.text = objRH.strQuestionText ;
    
    [self fn_SetFontColor];    
    
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:12px;color:AA3934;font-family:helvetica;\">Select the correct category for items on the left. Once you have selected all items, tap <b>Submit.</b></body></html>" baseURL:nil];
    }
    else {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Select the correct category for items on the left. Once you have selected all items, tap <b>Submit.</b></body></html>" baseURL:nil];            
    }
    
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            imgRadio = [UIImage imageNamed:@"radio_btn_grey.png"];
            imgRadioSelected = [UIImage imageNamed:@"radio_btn_blue.png"];
        }
        else {
            imgRadio = [UIImage imageNamed:@"btn_radio.png"];
            imgRadioSelected = [UIImage imageNamed:@"btn_radio_select.png"];
            
        }
    
    
    
    
    arrRadios = [[NSMutableArray alloc] init];   
    [self createRadios];
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}

-(void) fn_SetFontColor
{
    lblQuestionNo.textColor = COLOR_WHITE;
    lblQuestionText.textColor = COLOR_WHITE;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        lblQuestionNo.font = FONT_20;
        lblQuestionText.font = FONT_12;
    }
    else {
        lblQuestionNo.font = FONT_31;
        lblQuestionText.font = FONT_17;
    }    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Function

-(void) createRadios
{
    // Question Text
    lblQuestionText.text = objRH.strQuestionText;    
    
    arrcount = [objRH.arrHeadingText count];
    
    // Option Headers
    int_x = 30;
    int_y = 140;
    
    float option_hiding_width = 0;
    float option_hiding_height = 40;
    
    CGSize sizeOptionHiding = [self getSize:[objRH.arrHeadingText objectAtIndex:0]];
   
    option_hiding_width = sizeOptionHiding.width + 40;
    
    if ([objRH.strQuestionId isEqualToString:@"10_2_3_1"]) {
        option_hiding_width = 300;
    }
    
    UIFont *font = FONT_17;
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        font = FONT_10;
        option_hiding_width = 100;
        option_hiding_height = 20;
        int_x = 5;
    }
   
    lblOptionHiding.text = [objRH.arrHeadingText objectAtIndex:0];
    lblOptionHiding.frame=CGRectMake(int_x, 0, option_hiding_width, option_hiding_height);
    lblOptionHiding.backgroundColor = COLOR_CUSTOMBUTTON_BLUE;
    lblOptionHiding.textAlignment=UITextAlignmentCenter;
    lblOptionHiding.font = font;
    lblOptionHiding.textColor = COLOR_WHITE;
    [lblOptionHiding.layer setCornerRadius:9];
    
    lblOption1.numberOfLines = 2;
    lblOption2.numberOfLines = 2;
    lblOption3.numberOfLines = 2;
    
    
    // Option 1
    CGSize sizeOption1 = [self getSize:[objRH.arrHeadingText objectAtIndex:1]];
    lblOption1.text = [objRH.arrHeadingText objectAtIndex:1];
    lblOption1.font = font;
    lblOption1.textColor = COLOR_WHITE;
    [lblOption1.layer setCornerRadius:9];
    
    
    // Option 2
    CGSize sizeOption2 = [self getSize:[objRH.arrHeadingText objectAtIndex:2]];
    lblOption2.text = [objRH.arrHeadingText objectAtIndex:2];
    lblOption2.font = font;
    lblOption2.textColor = COLOR_WHITE;
    [lblOption2.layer setCornerRadius:9];

    
    // Get Max width
    float max_width = MAX(sizeOption1.width, sizeOption2.width);
    

    // Option 3
    CGSize sizeOption3;
    lblOption3.hidden = YES;
    if (arrcount > 3) {
        sizeOption3 = [self getSize:[objRH.arrHeadingText objectAtIndex:3]];
        lblOption3.text = [objRH.arrHeadingText objectAtIndex:3];
        lblOption3.font = font;
        lblOption3.textColor = COLOR_WHITE;
        [lblOption3.layer setCornerRadius:9];
        
        
        max_width = MAX(max_width, sizeOption3.width);
        lblOption3.hidden = NO;
    }
    
    if ([objRH.strQuestionId isEqualToString:@"5_4_3_2"]) {
        max_width = 100;
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        max_width = 40;
        
        lblOptionHiding.numberOfLines = 2;
        lblOption1.numberOfLines = 2;
        lblOption2.numberOfLines = 2;
        lblOption3.numberOfLines = 2;
    }
    
    //max_width = 150;
    
    //
    int_x = int_x + lblOptionHiding.frame.origin.x+option_hiding_width + 40;
    
    // Set Options frame
    lblOption1.frame=CGRectMake(int_x, 0, max_width, option_hiding_height);
    lblOption1.backgroundColor=COLOR_CUSTOMBUTTON_BLUE;
    lblOption1.textAlignment=UITextAlignmentCenter;
    
    //
    int_x = int_x + max_width + 40;
    
    lblOption2.frame=CGRectMake(int_x, 0, max_width, option_hiding_height);
    lblOption2.backgroundColor=COLOR_CUSTOMBUTTON_BLUE;
    lblOption2.textAlignment=UITextAlignmentCenter;

    //
    if (arrcount > 3) {
        int_x = int_x + max_width + 40;
        lblOption3.frame=CGRectMake(int_x, 0, max_width, option_hiding_height);
        lblOption3.backgroundColor=COLOR_CUSTOMBUTTON_BLUE;
        lblOption3.textAlignment=UITextAlignmentCenter;
    }
    
    
    //
    int_y = 0;

    
    for (int i=0; i<[objRH.arrRadioButtons count]; i++)
    {
        objRB =[objRH.arrRadioButtons objectAtIndex:i];
        
        radioView = [[RadioGroupView alloc] init];
        [radioView setFrame:CGRectMake(lblOptionHiding.frame.origin.x,int_y, scrollRadioOption.frame.size.width - 50, 32)];
        
        [radioView.lblQuestion setText: [NSString stringWithFormat:@"  %@", objRB.strQuestionText]];
        [radioView.lblQuestion setFrame:CGRectMake(0, 0, option_hiding_width, 32)];        
        
        [radioView.btnOption1 setTag:i];
        [radioView.btnOption2 setTag:i];
        [radioView.btnOption3 setTag:i];
        
        [radioView.btnOption1 setImage:imgRadio forState:UIControlStateNormal];
        [radioView.btnOption2 setImage:imgRadio forState:UIControlStateNormal];
        if (arrcount > 3)
            [radioView.btnOption3 setImage:imgRadio forState:UIControlStateNormal];
        
        
        [radioView.btnOption1 addTarget:self action:@selector(onOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
        [radioView.btnOption2 addTarget:self action:@selector(onOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
        if (arrcount > 3)
            [radioView.btnOption3 addTarget:self action:@selector(onOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [radioView.btnOption1 setFrame:CGRectMake(radioView.lblQuestion.frame.size.width + 40 , 0, max_width, 32)];
        [radioView.btnOption2 setFrame:CGRectMake(radioView.btnOption1.frame.origin.x+radioView.btnOption1.frame.size.width + 40, 0, max_width, 32)];
        float width_ans = radioView.btnOption2.frame.origin.x + radioView.btnOption2.frame.size.width + 10 ;
        if (arrcount > 3) {
            [radioView.btnOption3 setFrame:CGRectMake(radioView.btnOption2.frame.origin.x + radioView.btnOption2.frame.size.width + 40, 0, max_width, 32)];
            width_ans = radioView.btnOption3.frame.origin.x + radioView.btnOption3.frame.size.width + 10;
        }
        
        [radioView.ansImage setImage:nil];
        [radioView.ansImage setFrame:CGRectMake(width_ans, 0, 36, 35)];
        
        [radioView.feedbackBt setFrame:CGRectMake(width_ans + 22 + 30, 0, 30, 38)];
        [radioView.feedbackBt setTag:i];        
        [radioView.feedbackBt setImage:[UIImage imageNamed:@"btn_feedback.png"] forState:UIControlStateNormal];
        [radioView.feedbackBt setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        radioView.feedbackBt.hidden = YES;
        [radioView.feedbackBt addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];        
        
        // iPhone
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            
            radioView.lblQuestion.font = FONT_12;
            [radioView.btnOption1 setFrame:CGRectMake(radioView.lblQuestion.frame.size.width + 10 , 0, max_width, 32)];
            [radioView.btnOption2 setFrame:CGRectMake(radioView.btnOption1.frame.origin.x+radioView.btnOption1.frame.size.width + 10, 0, max_width, 32)];
            float width_ans = radioView.btnOption2.frame.origin.x + radioView.btnOption2.frame.size.width  ;
            if (arrcount > 3) {
                [radioView.btnOption3 setFrame:CGRectMake(radioView.btnOption2.frame.origin.x + radioView.btnOption2.frame.size.width + 10, 0, max_width, 32)];
                width_ans = radioView.btnOption3.frame.origin.x + radioView.btnOption3.frame.size.width ;
            }
            
            [radioView.ansImage setFrame:CGRectMake(width_ans, 0, 36, 35)];
            
            [radioView.feedbackBt setFrame:CGRectMake(width_ans + 22 + 10, 0, 30, 38)];
            
                        
            
            
            int_y = int_y + 45;
            
        }
        else {
            int_y = int_y + 50;
            
        }
        
        [arrRadios addObject:radioView];
        [scrollRadioOption addSubview:radioView];
        
    }
    
    scrollRadioOption.contentSize=CGSizeMake(scrollRadioOption.frame.size.width, int_y);
}

-(CGSize) getSize:(NSString *)str
{
    CGSize constraintSiz = CGSizeMake(280.0f, 10000.0f);
    CGSize labelSiz = [str sizeWithFont:FONT_20 constrainedToSize:constraintSiz lineBreakMode:UILineBreakModeWordWrap];
    return labelSiz;
}

-(IBAction)onOptionTapped:(id)sender
{
    radioView = [arrRadios objectAtIndex:[sender tag]];
    
    [radioView.btnOption1 setImage:imgRadio forState:UIControlStateNormal];
    [radioView.btnOption2 setImage:imgRadio forState:UIControlStateNormal];
    if (arrcount > 3)
        [radioView.btnOption3 setImage:imgRadio forState:UIControlStateNormal];
    
    [sender setImage:imgRadioSelected forState:UIControlStateNormal];
    
    if (sender == radioView.btnOption1) {
        radioView.selected = [objRH.arrHeadingText objectAtIndex:1];
        radioView.selectedIndex = 1;
    }
    else if (sender == radioView.btnOption2) {
        radioView.selected = [objRH.arrHeadingText objectAtIndex:2];
        radioView.selectedIndex = 2;
    }
    else if (sender == radioView.btnOption3) {
        radioView.selected = [objRH.arrHeadingText objectAtIndex:3];
        radioView.selectedIndex = 3;
    }
    
}

- (NSString *) fn_getFeeback:(NSMutableArray *)feedbackArr AndCorrect:(NSString *)correctincorrect Andfeed:(int)intfeed
{
    NSString *strTemp = nil;
    
    for (int x=0; x<feedbackArr.count; x++) {
        objFeedback =  [feedbackArr objectAtIndex:x];
        NSString *trimmedOption = [objFeedback.strOption stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        char letter = [trimmedOption characterAtIndex:0];
        int char_index = [md charToScore:letter] ;
        
        NSString *trimmedType = [objFeedback.strType stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        trimmedType = [trimmedType lowercaseString];
        
        if (intfeed == char_index) {
            if ([trimmedType isEqualToString:correctincorrect]) {
                strTemp = [NSString stringWithFormat:@"%@", objFeedback.strFeedback];
            }
        }        
    }
    
    return strTemp;
}

- (void) Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue{
    
    [feedbackView removeFromSuperview];
    
    feedbackView = [[UIView alloc] initWithFrame:CGRectMake(xValue, yValue, 261, 131)];
    feedbackView.backgroundColor = [UIColor clearColor];
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    [bg setFrame:CGRectMake(13, 13, 235, 104)];
    [feedbackView addSubview:bg];
    
    
    UIImageView *img_feedback = [[UIImageView alloc] init];
    img_feedback.backgroundColor = [UIColor clearColor];
    [img_feedback setImage:[UIImage imageNamed:@"img_feedback_down_box.png"]];
    [img_feedback setFrame:CGRectMake(0, 0, 261, 131)];
    [feedbackView addSubview:img_feedback];
    
    
    UITextView *txt_feedback = [[UITextView alloc] init];
    txt_feedback.text = textValue;
    txt_feedback.textColor = [UIColor whiteColor];
    txt_feedback.backgroundColor = [UIColor clearColor];
    txt_feedback.font = FONT_14;
    txt_feedback.editable = NO;
    [txt_feedback setFrame:CGRectMake(13, 13, 235, 104)];
    [feedbackView addSubview:txt_feedback];
    [self.view addSubview:feedbackView]; 
}

-(IBAction)onFeedbackTapped:(id)sender
{
    objRB = [objRH.arrRadioButtons objectAtIndex:[sender tag]];
    radioView = [arrRadios objectAtIndex:[sender tag]];
    UIButton *bn = (UIButton *)sender;
    float x_point = bn.frame.origin.x - 150;
    float y_point = bn.superview.frame.origin.y;
    y_point = y_point - visibleRect.origin.y;
    
    x_feedback_l=x_point-10;
    y_feedback_l=y_point+60;
    
    x_feedback_p=x_feedback_l-10;;
    y_feedback_p=y_feedback_l+65;
    
    if(currentOrientaion==1 || currentOrientaion==2) // Portrait
    {
        [self Fn_AddFeedbackPopup:x_feedback_p andy:y_feedback_p andText:radioView.feedback];
    }
    else //Lanscape
    {
        [self Fn_AddFeedbackPopup:x_feedback_l andy:y_feedback_l andText:radioView.feedback];
    }
}

- (BOOL) checkForAnswer{
    BOOL flag1 = YES;
    NSMutableString *strAns = [[NSMutableString alloc] init];
    for (int i =0; i <[arrRadios count]; i++) {
        radioView = [arrRadios objectAtIndex:i];
        objRB = [objRH.arrRadioButtons objectAtIndex:i];
        
        NSString *ss = [radioView.selected stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [objRB.strAnswer stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
			flag1 = NO;
		}
        if (i == [arrRadios count] - 1)
            [strAns appendFormat:@"%@", ss];
        else
            [strAns appendFormat:@"%@#", ss];
    }
    strVisitedAnswer = [NSString stringWithFormat:@"%@",strAns];
	return flag1;
}
- (void) handleRevealScore{
    for (int i =0; i <[arrRadios count]; i++) {
        radioView = [arrRadios objectAtIndex:i];
        objRB = [objRH.arrRadioButtons objectAtIndex:i];
        
        NSString *ss = [radioView.selected stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [objRB.strAnswer stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
			[radioView.ansImage setImage:[UIImage imageNamed:@"img_false.png"]];
            
            NSString *feeback = [self fn_getFeeback:objRB.arrFeedback AndCorrect:@"incorrect" Andfeed:radioView.selectedIndex];
            if (feeback.length > 0) {
                radioView.feedbackBt.hidden = NO;
                [radioView.feedbackBt addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
                radioView.feedback = feeback;
            }
            
		}else {
			
			[radioView.ansImage setImage:[UIImage imageNamed:@"img_true.png"]];
            
            NSString *feeback = [self fn_getFeeback:objRB.arrFeedback AndCorrect:@"correct" Andfeed:radioView.selectedIndex];
            if (feeback.length > 0) {
                radioView.feedbackBt.hidden = NO;
                [radioView.feedbackBt addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
                radioView.feedback = feeback;                
            }
        }
    }
    
    [self disableEditFields];
}
- (void) disableEditFields {
    
    for (int i =0; i <[arrRadios count]; i++) {
        radioView = [arrRadios objectAtIndex:i];
        radioView.btnOption1.enabled = NO;
        radioView.btnOption2.enabled = NO;
        radioView.btnOption3.enabled = NO;
    }
}

//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id
{
    objRH = [db fnGetTestyourselfRadioGroup:question_id];
    
}
-(void) fn_CheckAnswersBeforeSubmit
{
    flagForAnyOptionSelect = NO;
    for (int i =0; i <[arrRadios count]; i++) {
        radioView = [arrRadios objectAtIndex:i];
        if ([radioView.selected isEqualToString:@"0"]) {
            flagForAnyOptionSelect = YES;
            break;
        }
    }
    
    if (flagForAnyOptionSelect) {
        intVisited = 0;
    }
    else  {
        flagForCheckAnswer = [self checkForAnswer];
        if (flagForCheckAnswer == YES) {
            intVisited = 1;
        }
        else {
            intVisited = 2;
        }
    }
}
-(void) fn_OnSubmitTapped
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Message"];
    [alert setDelegate:self];
    if (flagForAnyOptionSelect) {
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please select options."]];
    }
    else {
        if (flagForCheckAnswer == YES) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:[NSString stringWithFormat:@"Correct"]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Ok"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"Incorrect"]];
        }
    }
	[alert show];
}


# pragma mark - scrollview delegate
//---------------------Delegate-------
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    // or if you are sure you wanna it always on left:
    [aScrollView setContentOffset: CGPointMake(0, aScrollView.contentOffset.y)];
    
    feedbackView.hidden=YES;
    visibleRect.origin = aScrollView.contentOffset;    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];
            [self handleRevealScore];
        }
    }
    else if (alertView.tag == 3) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
        }
        else if (buttonIndex == 1)
        {
            [parentObject onTryAgain];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    feedbackView.hidden = YES;
}


#pragma Orientation
//------------------------------
- (BOOL) shouldAutorotate{
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    currentOrientaion = interfaceOrientation;
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
    NSUInteger mask= UIInterfaceOrientationMaskPortrait;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    currentOrientaion = interfaceOrientation;
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        
        mask  |= UIInterfaceOrientationMaskLandscapeLeft;
        
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
       	[self Fn_rotateLandscape];
        mask |= UIInterfaceOrientationMaskLandscapeRight;
        
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
     	[self Fn_rotatePortrait];
        mask  |=UIInterfaceOrientationMaskPortraitUpsideDown;
        
	}
	else {
        [self Fn_rotatePortrait];
        mask  |=UIInterfaceOrientationMaskPortrait;
        
	}
    return UIInterfaceOrientationMaskAll;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
    currentOrientaion = interfaceOrientation;
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        return YES;
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
        return YES;
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
        return YES;
	}
	else {
        [self Fn_rotatePortrait];
        return YES;
	}
    
	return YES;
}
//------------------------------
/*
-(void)Fn_rotatePortrait
{
    [self.view setFrame:CGRectMake(0, 0, 767, 803)];
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg_p.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 767, 803)];
    
    [lblQuestionNo setFrame:CGRectMake(17, 25, 93, 114) ];
    [lblQuestionText setFrame:CGRectMake(118, 25, 567, 114) ];
    [webviewInstructions setFrame:CGRectMake(20, 140, 727, 32) ];
    
    [scrollRadioOption setFrame:CGRectMake(0,230, 767, 475) ];    
    
    //[ImgQuestionTextBg setImage:[UIImage imageNamed:@"blue_5text_bar.png"]];
    //[ImgQuestionTextBg setFrame:CGRectMake(0, 17, 767, 177)];
    
    [webviewInstructions setFrame:CGRectMake(19, 190, 725, 45)];
    
    //[ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator_P.png"]];
    //[ImgQuestionSeperator setFrame:CGRectMake(4, 225, 767, 53)];
    
    
}
-(void)Fn_rotateLandscape
{
    [self.view setFrame:CGRectMake(0, 0, 1005, 600)];
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 1005, 600)];

    
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75) ];
    [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72) ];
    [webviewInstructions setFrame:CGRectMake(17, 93, 968, 32) ];
    
    [scrollRadioOption setFrame:CGRectMake(10,170, 968, 415) ];
   
    
    //[ImgQuestionTextBg setFrame:CGRectMake(0, 17, 1005, 75)];
    //[ImgQuestionTextBg setImage:[UIImage imageNamed:@"img_questiontext2_bg.png"]];
    
   // [ImgQuestionSeperator setFrame:CGRectMake(13, 128, 977, 54)];
    //[ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator.png"]];
    
    
}
 */

-(void)Fn_rotatePortrait
{
    // Self View
    [self.view setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Question Bg
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg_p.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Instruction
    [webviewInstructions setFrame:CGRectMake(19, 130, 615, 70)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(feedbackView.frame.origin.x, y_feedback_p, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 20, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(125, 20, 570, 72)];
    
    // ScrollView
    [scrollRadioOption setFrame:CGRectMake(0, 260, 954, 500)];
    scrollRadioOption.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, scrollRadioOption.bounds.size.width - 726);
    
    // Title Options
    [viewTitle setFrame:CGRectMake(19, 210, 747, 45)];

}
-(void)Fn_rotateLandscape
{
    // Self View
    [self.view setFrame:CGRectMake(0, 0, 1005, 600)];
    
    // Question Bg
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 1005, 600)];
    
    // Instruction
    [webviewInstructions setFrame:CGRectMake(17, 93, 968, 45)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(feedbackView.frame.origin.x, y_feedback_l, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72)];
    
    // ScrollView
    [scrollRadioOption setFrame:CGRectMake(10, 195, 974, 390)];
    scrollRadioOption.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, scrollRadioOption.bounds.size.width - 974);
    //scrollRadioOption.backgroundColor = [UIColor greenColor];
    
    // Title Options
    [viewTitle setFrame:CGRectMake(30, 150, 965, 45)];
}

@end
