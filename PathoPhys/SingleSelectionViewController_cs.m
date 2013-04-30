//
//  SingleSelectionViewController.m
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "SingleSelectionViewController_cs.h"
#import "MCSS.h"
#import "Feedback.h"
#import "MCSSCell_iPad.h"
#import "CaseStudyViewController.h"

@interface SingleSelectionViewController_cs()
{
    MCSS *objMCSS;
    Feedback *objFeedback;
    BOOL flagForAnyOptionSelect;
    NSInteger flagForCheckAnswer;
    BOOL MultipleSelect;
    BOOL isImage;
    BOOL isSubmit;
    NSMutableArray *cellArray;
    UIView *feedbackView;
    UIButton *btnInvisible;
    NSInteger currentOrientaion;
    
    float y_feedback_p;
    float y_feedback_l;
    float x_feedback_p;
    float x_feedback_l;    

    NSMutableArray *selectedCells;
}
@end

@implementation SingleSelectionViewController_cs
@synthesize lblQuestionNo;
@synthesize webQuestionText;
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
    
    //webQuestionText.text = objMCSS.strQuestionText ;
    
    webQuestionText.scrollView.showsHorizontalScrollIndicator = NO;
    webQuestionText.scrollView.bounces = NO;
    btnCasestudyText.hidden = YES;
    
    NSString *question = [NSString stringWithFormat:@"<html><body style=\"font-size:16px;color:white;font-family:helvetica;background-color:#0c64b1;\">%@</body></html>", objMCSS.strQuestionText];
    
    [webQuestionText loadHTMLString:question baseURL:nil];
    
    [self fn_SetFontColor];
    
    cellArray = [[NSMutableArray alloc] init];
    
    webviewInstructions.scrollView.showsHorizontalScrollIndicator = NO;
    webviewInstructions.scrollView.bounces = NO;
    
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
    
    //if(objMCSS.strImageName == (id)[NSNull null]){
    if (objMCSS.strImageName == (id)[NSNull null] || objMCSS.strImageName.length == 0 || [objMCSS.strImageName isEqualToString:@" "]) {    
        isImage = NO;
        [ImgOption setImage:nil];
    }
    else {
        [ImgOption setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", objMCSS.strImageName]]];
        isImage = YES;
    }
    
    isSubmit = NO;
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
    

    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
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
    //webQuestionText.textColor = COLOR_WHITE;
    
    lblQuestionNo.font = FONT_31;
    //webQuestionText.font = FONT_17;
    
}

//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id 
{
    objMCSS = [db fnGetCasestudyMCSS:question_id];
}
-(void) fn_CheckAnswersBeforeSubmit
{
    flagForAnyOptionSelect = NO;
    
    NSArray *selectedCells_temp = [tblOptions indexPathsForSelectedRows];
    
    if ([selectedCells_temp count] == 0) {
        flagForAnyOptionSelect = YES;
        intVisited = 0;
    }
    else  {
        flagForCheckAnswer = [self checkForAnswer];
        
        if (flagForCheckAnswer == 1) {
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
        if (MultipleSelect) {
            [alert setMessage:[NSString stringWithFormat:@"Please select options."]];
        }
        else {
            [alert setMessage:[NSString stringWithFormat:@"Please select an option."]];
        }
    }
    else {
        if (flagForCheckAnswer == 1) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:[NSString stringWithFormat:@"That's Correct!"]];
        }
        else if (flagForCheckAnswer == 3) {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Ok"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"Partially Correct. Please try other options as well."]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Ok"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"That's Incorrect!"]];
            // Please match all the items.
            
        }
    }
	[alert show];
}
//--------------------------------

- (IBAction)onCasestudyTextTapped:(id)sender
{
    strCaseStudyText = objMCSS.strCasestudyText;
    [md Fn_AddCaseStudyText];
}

- (int) checkForAnswer{
    
    NSMutableString *strAns = [[NSMutableString alloc] init];
    
    NSArray *selectedCells_temp = [tblOptions indexPathsForSelectedRows];
    
    int answer_count = [objMCSS.arrAnswer count];
    int selected_count = [selectedCells_temp count];
    
    NSMutableArray *selected_answer_check = [[NSMutableArray alloc] init];
    for (int i = 0; i < selected_count; i++) {
        [selected_answer_check addObject:[NSNumber numberWithInt:2]];
    }
    
    
    //if (selected_count == answer_count) {
        for (int i = 0; i < selected_count; i++) {

            NSIndexPath *indexPath = [selectedCells_temp objectAtIndex:i];
            
            NSString *ss = [objMCSS.arrOptions objectAtIndex:indexPath.row];
            ss = [ss stringByReplacingOccurrencesOfString:@" " withString:@""];            
            
            for (int j = 0; j < answer_count; j++) {
                NSString *sa = [[objMCSS.arrAnswer objectAtIndex:j] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                    [selected_answer_check replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
                    break;
                }
                
            }
            
            if (i == selected_count - 1)
                [strAns appendFormat:@"%@", ss];
            else
                [strAns appendFormat:@"%@#", ss];
            
        }

    BOOL flag_answer = 3;
    
    int incorrectcount = 0;
    int correctcount = 0;
    
    for (int x =0; x < [selected_answer_check count]; x++) {
        if ([[selected_answer_check objectAtIndex:x] intValue] == 1) {
            correctcount++;
        }
        else if ([[selected_answer_check objectAtIndex:x] intValue] == 2) {
            incorrectcount++;
        }
    }

    if (incorrectcount > 0) {
        flag_answer = 2;
    }
    else if (correctcount == [objMCSS.arrAnswer count]) {
        flag_answer = 1;
    }
    
    return flag_answer;
}

- (void) handleShowAnswers{

    [(CaseStudyViewController*)self.parentViewController onTryAgain];
    
}

- (void) handleRevealScore{
    
    NSArray *selectedCells_temp = [tblOptions indexPathsForSelectedRows];
    
    int answer_count = [objMCSS.arrAnswer count];
    int selected_count = [selectedCells_temp count];
    
    //if (selected_count == answer_count) {
    for (int i = 0; i < selected_count; i++) {
        
        NSIndexPath *indexPath = [selectedCells_temp objectAtIndex:i];
        
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
    
    [self Fn_createInvisibleBtn];
}
//--------------------------------

-(void) Fn_createInvisibleBtn
{    
    [btnInvisible removeFromSuperview];
    btnInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnInvisible setFrame:CGRectMake(tblOptions.frame.origin.x, tblOptions.frame.origin.y, tblOptions.frame.size.width - 50, tblOptions.frame.size.height)];
    btnInvisible.backgroundColor = [UIColor clearColor];
    [btnInvisible addTarget:self action:@selector(onInvisible:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInvisible];    
}

-(IBAction)onInvisible:(id)sender
{
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
    float x_point = bn.frame.origin.x - (221);
    float y_point = tblOptions.frame.origin.y + cell.frame.origin.y + bn.frame.origin.y  - (128);
    
    x_feedback_l = 270;
    y_feedback_l = cell.frame.origin.y + bn.frame.origin.y  - (131);
    
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
            isSubmit = YES;
            [parentObject Fn_DisableSubmit];
            [self handleRevealScore];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0)
        {
            isSubmit = YES;
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
        }
        else if (buttonIndex == 1)
        {
            isSubmit = NO;
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
        
        if (currentOrientaion==1||currentOrientaion==2) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"MCSSCell_iPad_P" owner:self options:nil];
            cell = [cellArray2 lastObject];            
        }
        else {
            
            if (isImage) {
                NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"MCSSCell_iPad_half" owner:self options:nil];
                cell = [cellArray2 lastObject];
            }
            else {
                NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"MCSSCell_iPad" owner:self options:nil];
                cell = [cellArray2 lastObject];
            }
        }
        
        UIView *v = [[UIView alloc] init];
    	v.backgroundColor = [UIColor clearColor];
    	cell.selectedBackgroundView = v;
    }
    
    
    cell.btnInvisible.backgroundColor = COLOR_CLEAR;
    // Set Images BG
    
    if (currentOrientaion==1||currentOrientaion==2) {
        
        if (MultipleSelect) {
            cell.imgTableCellBG.image=[UIImage imageNamed:@"P_Question_multiple.png"];
            cell.imgTableCellBG.highlightedImage=[UIImage imageNamed:@"P_Question_multiple_select.png"];
        }
        else {
            cell.imgTableCellBG.image=[UIImage imageNamed:@"P_Question_redio_btn.png"];
            cell.imgTableCellBG.highlightedImage=[UIImage imageNamed:@"P_Question_redio_btn_select.png"];
        }
    }
    else {
        
        if (isImage) {
            if (MultipleSelect) {
                cell.imgTableCellBG.image=[UIImage imageNamed:@"L_Que-Box_Multiple_half.png"];
                cell.imgTableCellBG.highlightedImage=[UIImage imageNamed:@"L_Que-Box_Multiple_select_half.png"];
            }
            else {
                cell.imgTableCellBG.image=[UIImage imageNamed:@"L_Que-Box_redio_btn_half.png"];
                cell.imgTableCellBG.highlightedImage=[UIImage imageNamed:@"L_Que-Box_redio_btn_select_half.png"];
            }
            
        }
        else {
            if (MultipleSelect) {
                cell.imgTableCellBG.image=[UIImage imageNamed:@"L_Que-Box_Multiple.png"];
                cell.imgTableCellBG.highlightedImage=[UIImage imageNamed:@"L_Que-Box_Multiple_select.png"];
            }
            else {
                cell.imgTableCellBG.image=[UIImage imageNamed:@"L_Que-Box_redio_btn.png"];
                cell.imgTableCellBG.highlightedImage=[UIImage imageNamed:@"L_Que-Box_redio_btn_select.png"];
            }
        }
    }
    
    if (selectedCells) {
        
        if ([selectedCells containsObject:[NSNumber numberWithInt:indexPath.row]]) {
          [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone          ];

        }        
    }
    
    cell.tag = indexPath.row;
    cell.lblOptionName.lineBreakMode = UILineBreakModeWordWrap;
    cell.lblOptionName.numberOfLines = 3;
    cell.lblOptionName.font = FONT_17;
    cell.lblOptionName.textColor = COLOR_BLACK;
    cell.lblOptionName.highlightedTextColor = COLOR_BottomBlueButton;
    cell.lblOptionName.numberOfLines = 5;
    cell.lblOptionName.text = [objMCSS.arrOptions objectAtIndex:indexPath.row];
    
    char letter = (char) indexPath.row + 65;
    cell.lblAlphabet.font = FONT_17;
    cell.lblAlphabet.textColor = COLOR_BLACK;
    cell.lblAlphabet.highlightedTextColor = COLOR_BottomBlueButton;    
    cell.lblAlphabet.text = [[NSString stringWithFormat:@"%c.", letter] lowercaseString];
    
    cell.btnFeedback.hidden = YES;
    cell.btnFeedback.tag = indexPath.row;
    [cell.btnFeedback addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [cellArray addObject:cell];
    
    if (indexPath.row == [objMCSS.arrOptions count] - 1) {
        if (isSubmit) {
            [self handleRevealScore];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 55;
    if (currentOrientaion == 1 || currentOrientaion == 2) {
        height = 70;
    }
    else {
        if (isImage) {
            height = 80;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *Cells = [tblOptions indexPathsForSelectedRows];
    selectedCells = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in Cells) {
        [selectedCells addObject:[NSNumber numberWithInt:indexPath.row]];
    }
    
    
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
    // Self View
    [self.view setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Question Bg
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg_p.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Instruction
    [webviewInstructions setFrame:CGRectMake(19, 138, 660, 55)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(x_feedback_p, y_feedback_p, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 20, 93, 75)];
    
    // Question text
    [webQuestionText setFrame:CGRectMake(125, 30, 615, 100)];    
   
    // Casestudy_text
    [btnCasestudyText setFrame:CGRectMake(705, 140, 35, 35)];
    
    //Table
    if (isImage) {
        [ImgOption setFrame:CGRectMake(100, 200, 250, 200) ];
        [tblOptions setFrame:CGRectMake(0,400, 767, 350) ];
    }
    else
        [tblOptions setFrame:CGRectMake(0, 200, 767, 525) ];
    //[tblOptions setBackgroundColor:COLOR_BottomBlueButton];
    cellArray = [[NSMutableArray alloc] init];
    [tblOptions reloadData];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(767-x_feedback_l, y_feedback_l+tblOptions.frame.origin.y, feedbackView.frame.size.width, feedbackView.frame.size.height)];
}
-(void)Fn_rotateLandscape
{
    // Self View
    [self.view setFrame:CGRectMake(0, 0, 1005, 600)];
    
    // Question Bg
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 1005, 600)];
    
    // Instruction
    [webviewInstructions setFrame:CGRectMake(17, 93, 905, 45)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(x_feedback_l, y_feedback_l, 261, 131)];
    
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75)];
    
    // Question text
    [webQuestionText setFrame:CGRectMake(118, 19, 867, 72)];    

    // Casestudy_text
    [btnCasestudyText setFrame:CGRectMake(947, 93, 35, 35)];
    
    // Table
    if (isImage) {
        [tblOptions setFrame:CGRectMake(470,156, 516, 425) ];
        [ImgOption setFrame:CGRectMake(30,156, 250, 200) ];
    }
    else
        [tblOptions setFrame:CGRectMake(0,156, 1005, 425) ];
    //[tblOptions setBackgroundColor:COLOR_BottomBlueButton];
    cellArray = [[NSMutableArray alloc] init];    
    [tblOptions reloadData];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(1005-x_feedback_l, y_feedback_l+tblOptions.frame.origin.y, feedbackView.frame.size.width, feedbackView.frame.size.height)];
    
}
@end
