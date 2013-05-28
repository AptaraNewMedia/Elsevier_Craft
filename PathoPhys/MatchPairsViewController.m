//
//  MatchPairsViewController.m
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "MatchPairsViewController.h"
#import "MATCHTERMS.h"
#import "Feedback.h"

//#import "T1Button_ipad.h"
#import "T1Object_ipad.h"

#import "LeftMatchView_IPad.h"
#import "RightMatchView_Ipad.h"

#import "TestYourSelfViewController.h"

@interface MatchPairsViewController ()
{
    MATCHTERMS *objMatch;
    Feedback *objFeedback;
    int LEFT_OPTION_WIDTH;
    int LEFT_OPTION_MARGIN;
    int RIGHT_OPTION_WIDTH;
    int RIGHT_OPTION_MARGIN;
    int CENTER_DISTANCE;
    
    NSMutableArray *arrLeftSize;
    NSMutableArray *arrRightSize;

	NSMutableArray *questionArray;
	NSMutableArray *answerArray;
	NSMutableArray *imgviewArray;
	NSMutableArray *userAnswerArray;
    
	NSArray *colorArray;
    
	NSInteger currentQns;
	NSInteger currentColor;
	NSInteger currentAnswer;
	
	BOOL qnsFlag;
	NSInteger countNo;
    CGPoint startPoint,endPoint;
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;
    
    UIView *feedbackView;
    CGRect visibleRect;
    
    float y_feedback_p;
    float y_feedback_l;
    
    float x_feedback_p;
    float x_feedback_l;
    
    
    NSInteger currentOrientaion;
}
@end

@implementation MatchPairsViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize scrollViewOptions;
@synthesize intVisited;
@synthesize strVisitedAnswer;
@synthesize parentObject;

// Defaults
//--------------------------------
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
    
    
    
    if (![objMatch.strQuestionText isEqualToString:@""] || objMatch.strQuestionText.length != 0) {
        lblQuestionText.text = objMatch.strQuestionText ;
    }    
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:10px;color:AA3934;font-family:helvetica;\">Tap the item on the left, and then tap the corresponding item on the right. Once you have matched all items, tap <b>Submit.</b></body></html>" baseURL:nil];
        // ScrollView
        
        self.view.frame = CGRectMake(0, 0, 320, 360);
        if([UIScreen mainScreen].bounds.size.height != 568.0){
            NSLog(@"Not in iPhone5");
            [scrollViewOptions setFrame:CGRectMake(5, 91, 315, 235)];
        }
        
    }
    else {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Tap the item on the left, and then tap the corresponding item on the right. Once you have matched all items, tap <b>Submit.</b></body></html>" baseURL:nil];
    }
    
    // Get Sizes for all labels
    
    [self fn_SetVariables];
    [self fn_SetFontColor];
    
    // getting size of left side options
    for (int i = 0; i < [objMatch.arrOptions1 count]; i++) {
        NSString *strOption = [objMatch.arrOptions1 objectAtIndex:i];
        float size = [self fn_getLeftSize:strOption];
        [arrLeftSize addObject:[NSNumber numberWithFloat:size]];        
    }
    
    // getting size of right side of buttons
    for (int j = 0; j < [objMatch.arrOptions2 count]; j++) {
        NSString *strOption = [objMatch.arrOptions2 objectAtIndex:j];
        float size = [self fn_getLeftSize:strOption];
        [arrRightSize addObject:[NSNumber numberWithFloat:size]];
    }
    
    // create left sides option labels
    CGFloat heightLeftScorll = 10.0;
    for (int i = 0; i < [objMatch.arrOptions1 count]; i++) {
        
        float heightOfLabel = [[arrLeftSize objectAtIndex:i] floatValue];
        LeftMatchView_IPad * bt = [[LeftMatchView_IPad alloc]initWithFrame:CGRectMake(5, heightLeftScorll, 200, heightOfLabel+15)];
		[bt.customBt addTarget:self action:@selector(handle_questions:) forControlEvents:UIControlEventTouchUpInside];
		bt.customBt.titleLabel.textAlignment = UITextAlignmentCenter;
		bt.customBt.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [bt.customBt setTitle:[[NSString alloc]initWithString:[objMatch.arrOptions1 objectAtIndex:i]] forState:UIControlStateNormal];
		bt.customBt.frame = CGRectMake(0, 0, 150, heightOfLabel+15);
		bt.customBt.tag = i;
		
        [bt.dotBt addTarget:self action:@selector(handle_questions:) forControlEvents:UIControlEventTouchUpInside];
        bt.dotBt.frame = CGRectMake(bt.customBt.frame.size.width+10, (heightOfLabel/2) - 5, 25, 25);
		bt.dotBt.tag = i;
        [bt.dotBt setBackgroundImage:[UIImage imageNamed:@"btn_dot.png"] forState:UIControlStateNormal];
        [bt.dotBt setBackgroundImage:[UIImage imageNamed:@"btn_dot.png"] forState:UIControlStateHighlighted];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            [bt setFrame:CGRectMake(0, heightLeftScorll, 100, heightOfLabel)];
            bt.customBt.titleLabel.font = FONT_10;
            bt.customBt.frame = CGRectMake(0, 0, 80, heightOfLabel);
            bt.dotBt.frame = CGRectMake(bt.customBt.frame.size.width+1, (heightOfLabel/2) - 5, 20, 20);
            heightLeftScorll = heightLeftScorll + heightOfLabel + 5;
            
        }
        else {
            heightLeftScorll = heightLeftScorll + heightOfLabel + 30;
            
        }
        
		[scrollViewOptions addSubview:bt];        
        
        
        [questionArray addObject:bt];
		[userAnswerArray addObject:bt.customBt.titleLabel.text];
    }
    
    // create right side of option labels
    CGFloat heightScorll = 10.0;
    for (int j = 0; j < [objMatch.arrOptions2 count]; j++) {
        
        float heightOfLabel = [[arrRightSize objectAtIndex:j] floatValue];
        
        RightMatchView_Ipad * bt = [[RightMatchView_Ipad alloc] initWithFrame:CGRectMake(310, heightScorll, 420, heightOfLabel+15)];
        
        [bt.dotBt addTarget:self action:@selector(handle_answers:) forControlEvents:UIControlEventTouchUpInside];
        bt.dotBt.frame = CGRectMake(0, (heightOfLabel/2) - 5, 25, 25);
		bt.dotBt.tag = j;
        [bt.dotBt setBackgroundImage:[UIImage imageNamed:@"btn_dot.png"] forState:UIControlStateNormal];
        [bt.dotBt setBackgroundImage:[UIImage imageNamed:@"btn_dot.png"] forState:UIControlStateHighlighted];

        
		[bt.customBt addTarget:self action:@selector(handle_answers:) forControlEvents:UIControlEventTouchUpInside];
		bt.customBt.titleLabel.textAlignment = UITextAlignmentCenter;
		bt.customBt.titleLabel.adjustsFontSizeToFitWidth = YES;
		bt.customBt.titleLabel.minimumFontSize = 8.0f;
		bt.customBt.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [bt.customBt setTitle:[[NSString alloc]initWithString:[objMatch.arrOptions2 objectAtIndex:j]] forState:UIControlStateNormal];
		bt.customBt.frame = CGRectMake(30, 0, 290, heightOfLabel+15);
		bt.customBt.tag = j;
		
        bt.ansImage.frame = CGRectMake(bt.customBt.frame.origin.x+bt.customBt.frame.size.width+10, (heightOfLabel/2) - 10, 36, 35);
		
        bt.feedbackBt.frame = CGRectMake(bt.ansImage.frame.origin.x+bt.ansImage.frame.size.width+10, (heightOfLabel/2) - 10, 30, 38);
        [bt.feedbackBt setTag:j];
        [bt.feedbackBt setImage:[UIImage imageNamed:@"btn_feedback.png"] forState:UIControlStateNormal];
        [bt.feedbackBt setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        bt.feedbackBt.hidden = YES;
        [bt.feedbackBt addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            [bt setFrame:CGRectMake(120, heightScorll, 200, heightOfLabel)];
            bt.dotBt.frame = CGRectMake(0, (heightOfLabel/2) - 5, 20, 20);
            bt.customBt.titleLabel.font = FONT_10;            
            bt.customBt.frame = CGRectMake(21, 0, 130, heightOfLabel);
            bt.ansImage.frame = CGRectMake(bt.customBt.frame.origin.x+bt.customBt.frame.size.width, (heightOfLabel/2) - 10, 20, 20);
            bt.feedbackBt.frame = CGRectMake(bt.ansImage.frame.origin.x+bt.ansImage.frame.size.width, (heightOfLabel/2) - 10, 20, 20);
            heightScorll = heightScorll + heightOfLabel + 5;
            
        }
        else  {
            heightScorll = heightScorll + heightOfLabel + 30;
            
        }
            
		[scrollViewOptions addSubview:bt];
        
		[answerArray addObject:bt];        
        
        
    }
    
    float greaterHeight =MAX(heightLeftScorll, heightScorll);
    
     if([UIScreen mainScreen].bounds.size.height == 568.0){
         [scrollViewOptions setFrame:CGRectMake(10, 100, 315, 274)];
         [scrollViewOptions setScrollEnabled:YES];
         scrollViewOptions.contentSize = CGSizeMake(scrollViewOptions.frame.size.width, greaterHeight);
     }
     else{
         scrollViewOptions.contentSize = CGSizeMake(scrollViewOptions.frame.size.width, greaterHeight);
     }
    
    // create imageview for lines
    for (int i = 0; i < [objMatch.arrOptions1 count]; i++) {
        UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewOptions.frame.size.width, greaterHeight)];
        lineView.tag = i;
        lineView.backgroundColor = COLOR_CLEAR;
        [scrollViewOptions addSubview:lineView];
        [imgviewArray addObject:lineView];
    }
    
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
//--------------------------------


// Set local variables
//--------------------------------
-(void) fn_SetVariables
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        LEFT_OPTION_WIDTH = 80;
        LEFT_OPTION_MARGIN = 2;
        RIGHT_OPTION_WIDTH = 150;
        RIGHT_OPTION_MARGIN = 2;
        CENTER_DISTANCE = 100;
    }
    else {
        LEFT_OPTION_WIDTH = 200;
        LEFT_OPTION_MARGIN = 10;
        RIGHT_OPTION_WIDTH = 400;
        RIGHT_OPTION_MARGIN = 10;
        CENTER_DISTANCE = 300;        
    }
    
    arrLeftSize = [[NSMutableArray alloc] init];
    arrRightSize = [[NSMutableArray alloc] init];
    
    UIColor *color1=[UIColor colorWithRed:252.0f/255.f green:189.0f/255.f blue:119.0f/255.f alpha:1.0];
	UIColor *color2=[UIColor colorWithRed:129.0f/255.f green:129.0f/255.f blue:255.0f/255.f alpha:1.0];
	UIColor *color3=[UIColor colorWithRed:192.0f/255.f green:160.0f/255.f blue:223.0f/255.f alpha:1.0];
	UIColor *color4=[UIColor colorWithRed:115.0f/255.f green:201.0f/255.f blue:247.0f/255.f alpha:1.0];
	UIColor *color5=[UIColor colorWithRed:255.0f/255.f green:223.0f/255.f blue:97.0f/255.f alpha:1.0];
	UIColor *color6=[UIColor colorWithRed:253.0f/255.f green:164.0f/255.f blue:98.0f/255.f alpha:1.0];
	UIColor *color7=[UIColor colorWithRed:151.0f/255.f green:195.0f/255.f blue:130.0f/255.f alpha:1.0];
	UIColor *color8=[UIColor colorWithRed:205.0f/255.f green:229.0f/255.f blue:108.0f/255.f alpha:1.0];
	UIColor *color9=[UIColor colorWithRed:97.0f/255.f green:160.0f/255.f blue:192.0f/255.f alpha:1.0];
	UIColor *color10=[UIColor colorWithRed:242.0f/255.f green:115.0f/255.f blue:119.0f/255.f alpha:1.0];
	UIColor *color11=[UIColor colorWithRed:97.0f/255.f green:192.0f/255.f blue:192.0f/255.f alpha:1.0];
	UIColor *color12=[UIColor colorWithRed:204.0f/255.f green:182.0f/255.f blue:116.0f/255.f alpha:1.0];
	UIColor *color13=[UIColor colorWithRed:97.0f/255.f green:160.0f/255.f blue:97.0f/255.f alpha:1.0];
	UIColor *color14=[UIColor colorWithRed:97.0f/255.f green:230.0f/255.f blue:230.0f/255.f alpha:1.0];
	UIColor *color15=[UIColor colorWithRed:255.0f/255.f green:161.0f/255.f blue:192.0f/255.f alpha:1.0];
	UIColor *color16=[UIColor colorWithRed:192.0f/255.f green:97.0f/255.f blue:97.0f/255.f alpha:1.0];
	UIColor *color17=[UIColor colorWithRed:160.0f/255.f green:97.0f/255.f blue:192.0f/255.f alpha:1.0];
	UIColor *color18=[UIColor colorWithRed:255.0f/255.f green:97.0f/255.f blue:160.0f/255.f alpha:1.0];
	UIColor *color19=[UIColor colorWithRed:97.0f/255.f green:223.0f/255.f blue:97.0f/255.f alpha:1.0];
	UIColor *color20=[UIColor colorWithRed:255.0f/255.f green:97.0f/255.f blue:255.0f/255.f alpha:1.0];
	
	colorArray=[[NSArray alloc] initWithObjects:color1,color2,color3,color4,color5,color6,color7,color8,color9,color10,color11,color12,color13,color14,color15,color16,color17,color18,color19,color20,nil];
	
	//array
	questionArray = [[NSMutableArray alloc]init];
    imgviewArray = [[NSMutableArray alloc] init];
	answerArray = [[NSMutableArray alloc]init];
	userAnswerArray = [[NSMutableArray alloc]init];
    
	currentQns = -1;
	qnsFlag = TRUE;
	currentAnswer = -2;    
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

//--------------------------------


//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id
{
    objMatch = [db fnGetTestyourselfMatchTerms:question_id];
}
-(NSString *) fn_CheckAnswersBeforeSubmit
{
    int i = 0;
	flagForAnyOptionSelect = NO;
    NSMutableString *strTemp = [[NSMutableString alloc] init];
    
	while (i < [userAnswerArray count]) {
        if (![[userAnswerArray objectAtIndex:i] isKindOfClass:[T1Object_ipad class]]) {
            flagForAnyOptionSelect = YES;
        }
        else {
            T1Object_ipad *obj = [userAnswerArray objectAtIndex:i];
            NSString *tempStr = [NSString stringWithFormat:@"%d$%d$%d", obj.qnsID, obj.ansID, obj.colorID];
            [strTemp appendString:tempStr];
            if (i == [userAnswerArray count]-1) {
                
            }
            else {
                [strTemp appendString:@"#"];
            }
        }
        i++;
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
    
    return strTemp;
}
-(void) fn_OnSubmitTapped
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:TITLE_COMMON];
    [alert setDelegate:self];
    if (flagForAnyOptionSelect) {
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please match the items."]];
    }
    else {
        if (flagForCheckAnswer == YES) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:[NSString stringWithFormat:@"That's Correct!"]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Answer"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"That's Incorrect!"]];
        }
    }
	[alert show];
}
-(void) fn_ShowSelected:(NSString *)visitedAnswers
{
    
    userAnswerArray = [[NSMutableArray alloc] init];
    NSArray *main;
    if (visitedAnswers.length > 0) {
        
        main = [visitedAnswers componentsSeparatedByString:@"#"];
        for (int i=0; i<[main count]; i++) {
            NSArray *sub = [[main objectAtIndex:i] componentsSeparatedByString:@"$"];
            T1Object_ipad *obj = [[T1Object_ipad alloc]init];
            obj.qnsID = [[sub objectAtIndex:0] intValue];
            obj.ansID = [[sub objectAtIndex:1] intValue];
            obj.colorID = [[sub objectAtIndex:2] intValue];
            [userAnswerArray addObject:obj];
            
            currentQns = obj.qnsID;
            currentColor = obj.colorID;
            
            LeftMatchView_IPad *lbt = [questionArray objectAtIndex:currentQns];
            [lbt.customBt setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
            [lbt.dotBt setBackgroundColor:[colorArray objectAtIndex:currentColor]];
            startPoint = CGPointMake(lbt.frame.origin.x+lbt.dotBt.frame.origin.x+(lbt.dotBt.frame.size.width/2) , lbt.frame.origin.y+lbt.dotBt.frame.origin.y+(lbt.dotBt.frame.size.height/2));
            
            RightMatchView_Ipad *rbt = [answerArray objectAtIndex:obj.ansID];
            [rbt.customBt setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
            [rbt.dotBt setBackgroundColor:[colorArray objectAtIndex:currentColor]];
            endPoint = CGPointMake(rbt.frame.origin.x+rbt.dotBt.frame.origin.x+(rbt.dotBt.frame.size.width/2) , rbt.frame.origin.y+rbt.dotBt.frame.origin.y+(rbt.dotBt.frame.size.height/2));
            [self drawLine];
        }
    }
    [self handleRevealScore];
    [self disableEditFields];
    [parentObject Fn_DisableSubmit];
}

//--------------------------------
- (void) Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue
{
    [feedbackView removeFromSuperview];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        feedbackView = [[UIView alloc] initWithFrame:CGRectMake(xValue, yValue, 150, 90)];
        feedbackView.backgroundColor = [UIColor clearColor];
        
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        [bg setFrame:CGRectMake(12, 12, 125, 65)];
        [feedbackView addSubview:bg];
        
        
        UIImageView *img_feedback = [[UIImageView alloc] init];
        img_feedback.backgroundColor = [UIColor clearColor];
        //        [img_feedback setImage:[UIImage imageNamed:@"img_feedback_down_box.png"]];
        
        [img_feedback setImage:[UIImage imageNamed:@"Small_Feedback_Box_004.png"]];
        
        [img_feedback setFrame:CGRectMake(0, 0, 150, 90)];
        [feedbackView addSubview:img_feedback];
        
        
        UITextView *txt_feedback = [[UITextView alloc] init];
        txt_feedback.text = textValue;
        txt_feedback.textColor = [UIColor whiteColor];
        txt_feedback.backgroundColor = [UIColor clearColor];
        txt_feedback.font = FONT_10;
        txt_feedback.editable = NO;
        [txt_feedback setFrame:CGRectMake(12, 12, 125, 65)];
        [feedbackView addSubview:txt_feedback];
        [self.view addSubview:feedbackView];
    }
    else
    {
        feedbackView = [[UIView alloc] initWithFrame:CGRectMake(xValue, yValue, 261, 131)];
        feedbackView.backgroundColor = [UIColor clearColor];
        
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        [bg setFrame:CGRectMake(13, 13, 235, 104)];
        [feedbackView addSubview:bg];
        
        
        UIImageView *img_feedback = [[UIImageView alloc] init];
        img_feedback.backgroundColor = [UIColor clearColor];
        [img_feedback setImage:[UIImage imageNamed:@"img_feedback_down_box.png"]];
        
        //    [img_feedback setImage:[UIImage imageNamed:@"Small_Feedback_Box_004.png"]];
        
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
}

- (NSString *) fn_getFeeback:(int)intfeed AndCorrect:(NSString *)correctincorrect
{
    NSString *strTemp = nil;
    
    for (int x=0; x<objMatch.arrFeedback.count; x++) {
        objFeedback =  [objMatch.arrFeedback objectAtIndex:x];
        NSString *trimmedOption = [objFeedback.strOption stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        char letter = [trimmedOption characterAtIndex:0];
        int char_index = [md charToScore:letter];
        
        NSString *trimmedType = [objFeedback.strType stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        trimmedType = [trimmedType lowercaseString];
        
        if (intfeed == char_index-1) {
            if ([trimmedType isEqualToString:correctincorrect]) {
                strTemp = [NSString stringWithFormat:@"%@", objFeedback.strFeedback];
            }
        }
        else if(objMatch.intMatchid == 46 || objMatch.intMatchid == 47)
        {
            if ([trimmedType isEqualToString:correctincorrect]) {
                strTemp = [NSString stringWithFormat:@"%@", objFeedback.strFeedback];
            }
        }
        
    }
    
    return strTemp;
}
-(IBAction)onFeedbackTapped:(id)sender
{
    UIButton *bn = sender;
    RightMatchView_Ipad *btTemp = [answerArray objectAtIndex:bn.tag];
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point = bn.frame.origin.x+7;
        y_point = bn.superview.frame.origin.y + bn.frame.origin.y;
        y_point = y_point - visibleRect.origin.y;
        
        [self Fn_AddFeedbackPopup:x_point andy:y_point andText:btTemp.strFeedback];
    }
    else
    {
        x_point = bn.frame.origin.x;
        y_point = bn.superview.frame.origin.y + bn.frame.origin.y + 10;
        y_point = y_point - visibleRect.origin.y;
        
        y_feedback_p=y_point + 65;
        y_feedback_l=y_point;
        
        x_feedback_p = x_point + 110;
        x_feedback_l = x_point + 235;
        
        if(currentOrientaion==1 || currentOrientaion==2) // Portrait
        {
            [self Fn_AddFeedbackPopup:x_feedback_p andy:y_feedback_p andText:btTemp.strFeedback];
        }
        else // Landscape
        {
            [self Fn_AddFeedbackPopup:x_feedback_l andy:y_feedback_l andText:btTemp.strFeedback];
        }
    }
}
// Get Size of text
//--------------------------------
-(float) fn_getLeftSize:(NSString *)data
{
    CGSize constraint = CGSizeMake(LEFT_OPTION_WIDTH - (LEFT_OPTION_MARGIN * 2), 20000.0f);
    UIFont *font = FONT_15;
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        font = FONT_12;
    }
    CGSize size = [data sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

-(float) fn_getRightSize:(NSString *)data
//--------------------------------
{
    CGSize constraint = CGSizeMake(RIGHT_OPTION_WIDTH - (RIGHT_OPTION_MARGIN * 2), 40000.0f);
    UIFont *font = FONT_15;
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        font = FONT_10;
    }
    CGSize size = [data sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}


- (void)drawLine{
    UIImageView *drawLineView = [imgviewArray objectAtIndex:currentQns];
    
    UIGraphicsBeginImageContext(drawLineView.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 4.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();    
    
    CGContextSetStrokeColorWithColor(context, [[colorArray objectAtIndex:currentColor] CGColor]);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [drawLineView setImage:ret];
}

- (void) disableEditFields{
    
	int i = 0;
	
	while (i < [questionArray count]) {
		
		LeftMatchView_IPad *bt = [questionArray objectAtIndex:i];
		bt.customBt.enabled = NO;
        bt.dotBt.enabled = NO;
		i++;
	}
	
	i = 0;
	
	while (i < [answerArray count]) {
		
		RightMatchView_Ipad *bt = [answerArray objectAtIndex:i];
		bt.customBt.enabled = NO;
        bt.dotBt.enabled = NO;
		i++;
	}
	
}


- (void) handleShowAnswers{
    
}

- (void) handleRevealScore{
	
	int i = 0;
	
	while (i < [userAnswerArray count]) {
		
		T1Object_ipad *obj = [userAnswerArray objectAtIndex:i];
		RightMatchView_Ipad *bt = [answerArray objectAtIndex:obj.ansID];
		NSString *ss = [bt.customBt.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [[objMatch.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		RightMatchView_Ipad *btTemp = [answerArray objectAtIndex:obj.ansID];
		
		if (![ss isEqualToString:sa]) {
			
			[btTemp.ansImage setImage:[UIImage imageNamed:@"img_false.png"]];
            
            NSString *feeback = [self fn_getFeeback:obj.ansID AndCorrect:@"incorrect"];
            if (feeback.length > 0) {
                btTemp.feedbackBt.hidden = NO;
                btTemp.strFeedback = feeback;
            }
            
		}else {
			
			[btTemp.ansImage setImage:[UIImage imageNamed:@"img_true.png"]];
            
            NSString *feeback = [self fn_getFeeback:obj.ansID AndCorrect:@"correct"];
            if (feeback.length > 0) {
                btTemp.feedbackBt.hidden = NO;
                btTemp.strFeedback = feeback;
            }
            
		}        
		
		i++;
	}
	
	[self disableEditFields];    
}

- (BOOL) checkForAnswer{
	NSMutableString *strAns = [[NSMutableString alloc] init];
	int i = 0;
	BOOL flag1 = YES;
	while (i < [userAnswerArray count]) {
		
		T1Object_ipad *obj = [userAnswerArray objectAtIndex:i];
		RightMatchView_Ipad *bt = [answerArray objectAtIndex:obj.ansID];
		NSString *ss = [bt.customBt.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [[objMatch.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
		if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {			
			flag1 = NO;
			break;
		}
		i++;
        
        if (i == [userAnswerArray count] - 1)
            [strAns appendFormat:@"%d$%d$%d", obj.ansID, obj.qnsID, obj.colorID];
        else
            [strAns appendFormat:@"%d$%d$%d#", obj.ansID, obj.qnsID, obj.colorID];
	}
	strVisitedAnswer = [NSString stringWithFormat:@"%@",strAns];
	return flag1;
}

- (NSInteger) getRandomColor{
	
	int i = 0;
	
	int colorId = arc4random() % ([colorArray count]);
	while (i < [userAnswerArray count]) {
		
		T1Object_ipad *obj = [userAnswerArray objectAtIndex:i];
		if ([[userAnswerArray objectAtIndex:i] isKindOfClass:[T1Object_ipad class]]) {
			
			if (obj.colorID == colorId) {
				
				i = -1;
				colorId = arc4random() % ([colorArray count]);
			}
		}
		i++;
	}
	
	return colorId;
}

- (NSInteger) checkQuenstion:(NSInteger) ansID{
	
	int i = 0;
	
	while (i < [userAnswerArray count]) {
		
		if ([[userAnswerArray objectAtIndex:i] isKindOfClass:[T1Object_ipad class]]) {
			
			T1Object_ipad * obj = [userAnswerArray objectAtIndex:i];
			
			if (obj.ansID == ansID && currentQns != obj.qnsID) {
				
				LeftMatchView_IPad *pqnsBt = [questionArray objectAtIndex:obj.qnsID];
				[pqnsBt.dotBt setBackgroundColor:COLOR_CLEAR];
				[pqnsBt.customBt setBackgroundColor:COLOR_BottomGrayButton];
                UIImageView *drawLineView = [imgviewArray objectAtIndex:obj.qnsID];
                [drawLineView setImage:nil];
                
				obj.ansID = -1;
				ansID = -1;
				
				countNo--;
				break;
			}
		}
		i++;
	}
	
	if (ansID == -1) {
		
		return 1;
	}
	return 0;
}

- (void) handle_questions:(id)selector{
    
	UIButton *tempBt = (UIButton *) selector;
    LeftMatchView_IPad *bt = [questionArray objectAtIndex:tempBt.tag];    
	countNo++;
	if (qnsFlag) {
		
		qnsFlag =  FALSE;
		
		currentQns = tempBt.tag;
		currentColor = [self getRandomColor];
		currentAnswer = -1;
        startPoint = CGPointMake(bt.frame.origin.x+bt.dotBt.frame.origin.x+(bt.dotBt.frame.size.width/2) , bt.frame.origin.y+bt.dotBt.frame.origin.y+(bt.dotBt.frame.size.height/2));
        [bt.customBt setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
		[bt.dotBt setBackgroundColor:[colorArray objectAtIndex:currentColor]];
	}
}

- (void) handle_answers:(id)selector{
	
	UIButton *tempBt = (UIButton *) selector;
    RightMatchView_Ipad *bt = [answerArray objectAtIndex:tempBt.tag];
	if ((currentAnswer != tempBt.tag || currentAnswer == -1) && currentAnswer != -2) {
		
		currentAnswer = tempBt.tag;
		qnsFlag = TRUE;
		if (currentQns != -1) {
			
			[self checkQuenstion:tempBt.tag];
			
			if ([[userAnswerArray objectAtIndex:currentQns] isKindOfClass:[T1Object_ipad class]]) {
				
				T1Object_ipad *obj = [userAnswerArray objectAtIndex:currentQns];
				
				if (obj.ansID != -1) {
					
					RightMatchView_Ipad *pansBt = [answerArray objectAtIndex:obj.ansID];
                    [pansBt.dotBt setBackgroundColor:COLOR_CLEAR];
					[pansBt.customBt setBackgroundColor:COLOR_BottomGrayButton];
				}
				
				obj.ansID = tempBt.tag;
				obj.colorID = currentColor;
			}else {
				
				T1Object_ipad *obj = [[T1Object_ipad alloc]init];
				obj.qnsID = currentQns;
				obj.ansID = tempBt.tag;
				obj.colorID = currentColor;
				[userAnswerArray replaceObjectAtIndex:currentQns withObject:obj];
			}
		}
        [bt.customBt setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
		[bt.dotBt setBackgroundColor:[colorArray objectAtIndex:currentColor]];
        endPoint = CGPointMake(bt.frame.origin.x+bt.dotBt.frame.origin.x+(bt.dotBt.frame.size.width/2) , bt.frame.origin.y+bt.dotBt.frame.origin.y+(bt.dotBt.frame.size.height/2));
        [self drawLine];
	}
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


# pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    feedbackView.hidden=YES;    
    visibleRect.origin = scrollViewOptions.contentOffset;
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
-(void)Fn_rotatePortrait
{
    // Self View
    [self.view setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Question Bg
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg_p.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Instruction
    [webviewInstructions setFrame:CGRectMake(19, 130, 725, 70)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(x_feedback_p, y_feedback_p, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 20, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(125, 20, 570, 72)];
    
    // ScrollView
    [scrollViewOptions setFrame:CGRectMake(21, 210, 954, 560)];
    scrollViewOptions.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, scrollViewOptions.bounds.size.width - 726);
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
    [feedbackView setFrame:CGRectMake(x_feedback_l, y_feedback_l, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72)];
    
    // ScrollView
    [scrollViewOptions setFrame:CGRectMake(150, 142, 954, 430)];
    scrollViewOptions.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, scrollViewOptions.bounds.size.width - 830);
}

@end


