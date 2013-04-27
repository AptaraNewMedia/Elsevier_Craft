//
//  SingleSelectionViewController.m
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "SingleSelectionViewController.h"
#import "MCSS.h"
#import "Feedback.h"
#import "MCSSCell_iPad.h"
#import "TestYourSelfViewController.h"

@interface SingleSelectionViewController()
{
    MCSS *objMCSS;
    Feedback *objFeedback;
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;
    BOOL MultipleSelect;
    NSMutableArray *cellArray;
    UIView *feedbackView;
    UIButton *btnInvisible;
    NSInteger currentOrientaion;    
}
@end

@implementation SingleSelectionViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    lblQuestionText.text = objMCSS.strQuestionText ;

    [self fn_SetFontColor];
    
    cellArray = [[NSMutableArray alloc] init];
    
    if ([objMCSS.arrAnswer count] > 1) {
        tblOptions.allowsMultipleSelection = YES;
        MultipleSelect = YES;
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Select the correct options and tap <b>Submit.</b></body></html>" baseURL:nil];
        
    }
    else {
        MultipleSelect = NO;
        tblOptions.allowsMultipleSelection = NO;
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Select the correct option and tap <b>Submit.</b></body></html>" baseURL:nil];
        
    }

    [self Fn_createInvisibleBtn];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) fn_SetFontColor
{
    lblQuestionNo.textColor = COLOR_WHITE;
    lblQuestionText.textColor = COLOR_WHITE;
    
    lblQuestionNo.font = FONT_31;
    lblQuestionText.font = FONT_17;
    
}

//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id 
{
    objMCSS = [db fnGetTestyourselfMCSS:question_id];
}
-(void) fn_CheckAnswersBeforeSubmit
{
    flagForAnyOptionSelect = NO;
    
    NSArray *selectedCells = [tblOptions indexPathsForSelectedRows];
    
    if ([selectedCells count] == 0) {
        flagForAnyOptionSelect = YES;
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
        [alert setMessage:[NSString stringWithFormat:@"Please select options"]];
    }
    else {
        if (flagForCheckAnswer == YES) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:[NSString stringWithFormat:@"That's Correct!"]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Ok"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"That's Incorrect!"]];
        }
    }
	[alert show];
}
//--------------------------------


- (BOOL) checkForAnswer{
    
    BOOL flag_answer = NO;
    
    NSMutableString *strAns = [[NSMutableString alloc] init];
    
    NSArray *selectedCells = [tblOptions indexPathsForSelectedRows];
    
    int answer_count = [objMCSS.arrAnswer count];
    int selected_count = [selectedCells count];
    
    if (selected_count == answer_count) {
        for (int i = 0; i < selected_count; i++) {

            NSIndexPath *indexPath = [selectedCells objectAtIndex:i];
            
            NSString *ss = [objMCSS.arrOptions objectAtIndex:indexPath.row];
            ss = [ss stringByReplacingOccurrencesOfString:@" " withString:@""];            
            
            for (int j = 0; j < answer_count; j++) {
                NSString *sa = [[objMCSS.arrAnswer objectAtIndex:j] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                    flag_answer = YES;
                    break;
                }
                
            }
            
            if (i == selected_count - 1)
                [strAns appendFormat:@"%@", ss];
            else
                [strAns appendFormat:@"%@#", ss];
            
        }
    }
    else
        flag_answer = NO;
    return flag_answer;
}


- (void) handleShowAnswers{

    [(TestYourSelfViewController*)self.parentViewController onTryAgain];
    
}

- (void) handleRevealScore{
    NSArray *selectedCells = [tblOptions indexPathsForSelectedRows];
    
    int answer_count = [objMCSS.arrAnswer count];
    int selected_count = [selectedCells count];
    
    //if (selected_count == answer_count) {
        for (int i = 0; i < selected_count; i++) {
            
            NSIndexPath *indexPath = [selectedCells objectAtIndex:i];
            
            NSString *ss = [objMCSS.arrOptions objectAtIndex:indexPath.row];
            ss = [ss stringByReplacingOccurrencesOfString:@" " withString:@""];
            ss = [ss lowercaseString];
            MCSSCell_iPad *cell = [cellArray objectAtIndex:indexPath.row];
            
            for (int j = 0; j < answer_count; j++) {
                NSString *sa = [[objMCSS.arrAnswer objectAtIndex:j] stringByReplacingOccurrencesOfString:@" " withString:@""];
                sa = [sa lowercaseString];
                if (![ss isEqualToString:sa]) {
                    [cell.imgAns setImage:[UIImage imageNamed:@"img_false.png"]];
                    NSString *feeback = [self fn_getFeeback:indexPath.row];
                    if (feeback.length > 0) {
                        cell.btnFeedback.hidden = NO;
                        cell.strFeedback = feeback;
                    }
                    
                }else {
                    [cell.imgAns setImage:[UIImage imageNamed:@"img_true.png"]];
                    NSString *feeback = [self fn_getFeeback:indexPath.row];
                    if (feeback.length > 0) {
                        cell.btnFeedback.hidden = NO;
                        cell.strFeedback = feeback;
                    }
                    break;
                }
            }
            
        }
    //}
    
    btnInvisible.hidden = NO;
}
//--------------------------------

-(void) Fn_createInvisibleBtn
{
    btnInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnInvisible setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    btnInvisible.backgroundColor = [UIColor clearColor];
    [btnInvisible addTarget:self action:@selector(onInvisible:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInvisible];
    btnInvisible.hidden = YES;
}

-(IBAction)onInvisible:(id)sender
{
    btnInvisible.hidden = YES;
    feedbackView.hidden = YES;
}

- (NSString *) fn_getFeeback:(int)intfeed 
{
    NSString *strTemp = nil;
    
    for (int x=0; x<objMCSS.arrFeedback.count; x++) {
        objFeedback =  [objMCSS.arrFeedback objectAtIndex:x];
        NSString *trimmedString = [objFeedback.strOption stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        char letter = [trimmedString characterAtIndex:0];
        int char_index = [md charToScore:letter];
        if (intfeed == char_index-1) {
            return objFeedback.strFeedback;
        }
        
    }
    
    return strTemp;
}

-(IBAction)onFeedbackTapped:(id)sender{
    UIButton *bn = sender;
    MCSSCell_iPad *cell = [cellArray objectAtIndex:bn.tag];
    
    float x_point = bn.frame.origin.x - 201;
    //float x_point = bn.frame.origin.x;
    float y_point = bn.frame.origin.y + bn.superview.frame.origin.y + (cell.tag * 56);
    
    [self Fn_AddFeedbackPopup:x_point andy:y_point andText:cell.strFeedback];
}
- (void) Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue {

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 0)
        {
            [self handleRevealScore];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0)
        {
            [self handleRevealScore];
        }
        else if (buttonIndex == 1)
        {
            [parentObject onTryAgain];
        }
    }
}

#pragma mark Touch Events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (feedbackView) {
        [feedbackView removeFromSuperview];
    }
}

#pragma mark - Table View
//---------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [objMCSS.arrOptions count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *MyIdentifier = @"tblCellView";
    MCSSCell_iPad *cell = (MCSSCell_iPad *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"MCSSCell_iPad" owner:self options:nil];
        cell = [cellArray2 lastObject];
    }
    cell.tag = indexPath.row;
    cell.lblOptionName.lineBreakMode = UILineBreakModeWordWrap;
    cell.lblOptionName.numberOfLines = 3;
    cell.lblOptionName.font = FONT_17;
    cell.lblOptionName.textColor = COLOR_BLACK;
    cell.lblOptionName.highlightedTextColor = COLOR_BottomBlueButton;

    cell.lblOptionName.text = [objMCSS.arrOptions objectAtIndex:indexPath.row];
    
    char letter = (char) indexPath.row + 65;
    cell.lblAlphabet.font = FONT_17;
    cell.lblAlphabet.textColor = COLOR_BLACK;
    cell.lblAlphabet.highlightedTextColor = COLOR_BottomBlueButton;    
    cell.lblAlphabet.text = [[NSString stringWithFormat:@"%c.", letter] lowercaseString];
    
    cell.btnFeedback.hidden = YES;
    cell.btnFeedback.tag = indexPath.row;
    [cell.btnFeedback addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft)
        cell.imgTableCellBG.highlightedImage=[UIImage imageNamed:@"Selected_chapter_tbl_row_center.png"];
    //else
        //cell.imgTableCellBG.image=[UIImage imageNamed:@"Selected_chapter_tbl_row_center_p.png"];
    
    [cellArray addObject:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIFont *cellFont = FONT_17;
//    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
//    CGSize labelSize = [[objMCSS.arrOptions objectAtIndex:indexPath.row] sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
//    
//    return labelSize.height + 20;
    
    return 56;
}
//---------------------------------------------------------

#pragma Orientation
//------------------------------
- (BOOL) shouldAutorotate{
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    currentOrientaion = interfaceOrientation;
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
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
    [lblQuestionNo setFrame:CGRectMake(17, 25, 93, 114) ];
    
    
    [webviewInstructions setFrame:CGRectMake(20, 140, 727, 32) ];
    
    [tblOptions setFrame:CGRectMake(20,200, 727, 425) ];

    
    [ImgQuestionBg setImage:[UIImage imageNamed:@"text-box.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 17, 767, 803)];
    
    [ImgQuestionTextBg setImage:[UIImage imageNamed:@"blue_5text_bar.png"]];
    [ImgQuestionTextBg setFrame:CGRectMake(0, 17, 767, 177)];
    
    [webviewInstructions setFrame:CGRectMake(19, 190, 725, 45)];
    
    [ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator_P.png"]];
    [ImgQuestionSeperator setFrame:CGRectMake(4, 225, 767, 53)];
    
    [lblQuestionText setFrame:CGRectMake(118, 40, 570, 114) ];

    
    [tblOptions reloadData];
    
    
}
-(void)Fn_rotateLandscape
{
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75) ];
    
    [webviewInstructions setFrame:CGRectMake(17, 93, 968, 32) ];
    [tblOptions setFrame:CGRectMake(17,156, 968, 425) ];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 1005, 600)];
    [ImgQuestionBg setImage:[UIImage imageNamed:@"img_question_bg.png"]];
    
    [ImgQuestionTextBg setFrame:CGRectMake(0, 17, 1005, 75)];
    [ImgQuestionTextBg setImage:[UIImage imageNamed:@"img_questiontext2_bg.png"]];
    
    [ImgQuestionSeperator setFrame:CGRectMake(13, 128, 977, 54)];
    [ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator.png"]];
    
        [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72) ];
    [tblOptions reloadData];
    
}
@end
