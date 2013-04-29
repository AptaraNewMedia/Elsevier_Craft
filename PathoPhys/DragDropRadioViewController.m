//
//  DragDropFIBViewController.m
//  PathoPhys
//
//  Created by Rohit Yermalkar on 17/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "DragDropRadioViewController.h"
#import "DragDropRadio.h"
#import <QuartzCore/QuartzCore.h>
#import "DragDropManager.h"
#import "CustomDragButton.h"
#import "RadioView.h"
#import "Feedback.h"
#import "TestYourSelfViewController.h"

@interface DragDropRadioViewController ()
{
    DragDropRadio *objDRAGDROP;
    Feedback *objFeedback;
    UIImage *imgRadio;
    UIImage *imgRadioSelected;
    
    RadioView *objRadioView;
    NSMutableArray *draggableSubjects;
    NSMutableArray *droppableAreas;
    NSMutableArray *arr_radioButtons;
    
    DragDropManager *_dragDropManager;
    UIPanGestureRecognizer * uiTapGestureRecognizer;    
    
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;
    
    UIView *feedbackView;
    int RadioOptions;
    NSInteger currentOrientaion;
    
    float y_feedback_p;
    float y_feedback_l;
    float x_feedback_p;
    float x_feedback_l;
}

@property(nonatomic, retain) DragDropManager *dragDropManager;

@end


@implementation DragDropRadioViewController


@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize intVisited;
@synthesize strVisitedAnswer;
@synthesize parentObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    lblQuestionText.text = objDRAGDROP.strQuestionText ;
    [self fn_SetFontColor];
    [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:arial;\">Tap the item on the left, and then tap the corresponding item on the right. Once you have matched all items, tap <b>Submit.</b></body></html>" baseURL:nil];
    
    UIImage *imgName = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", objDRAGDROP.strImageName]];
    imgViewQue.image = imgName;
    [imgViewQue setFrame:CGRectMake(0, 0, imgName.size.width, imgName.size.height)];
    [imgDropView setFrame:imgViewQue.frame];
    [imgDropView setBackgroundColor:[UIColor clearColor]];
    [imgScroller setContentSize:CGSizeMake(imgScroller.frame.size.width, imgViewQue.frame.size.height)];
    
    draggableSubjects = [[NSMutableArray alloc] init];
    droppableAreas = [[NSMutableArray alloc] init];
    
    imgRadio = [UIImage imageNamed:@"table_radio_Btn.png"];
    imgRadioSelected = [UIImage imageNamed:@"table_radio_Btn_select.png"];
    
    [self draggblePoints];
    [self droppablePoints];
    
    [self createRadioButtons];
    
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
    
    lblQuestionNo.font = FONT_31;
    lblQuestionText.font = FONT_17;
    
}

- (void) draggblePoints{
    int y = 10;
    for (int i = 0; i < [objDRAGDROP.arrOptions count]; i++){
        
        CustomDragButton *bnDrag = [CustomDragButton buttonWithType:UIButtonTypeCustom];
        bnDrag.frame = CGRectMake(20, y, objDRAGDROP.fWidth, objDRAGDROP.fHeight);
        bnDrag.exclusiveTouch = YES;
        bnDrag.tag = i+1;
        bnDrag.x = bnDrag.frame.origin.x;
        bnDrag.y = bnDrag.frame.origin.y;
        
        [bnDrag setTitle:[objDRAGDROP.arrOptions objectAtIndex:i] forState:UIControlStateNormal];
        [bnDrag setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        [bnDrag setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
        bnDrag.titleLabel.font = FONT_14;
        bnDrag.userInteractionEnabled=YES;
        bnDrag.titleLabel.numberOfLines = 10;

        [bnDrag.ansImage setFrame:CGRectMake(objDRAGDROP.fWidth-25, -10, 22, 22)];
        [scrollViewDrag addSubview:bnDrag];
        y=y+objDRAGDROP.fHeight+10;
        [draggableSubjects addObject:bnDrag];
        
    }
    [scrollViewDrag setContentSize:CGSizeMake(scrollViewDrag.frame.size.width, y)];
}
- (void) droppablePoints{
    for (int i=0; i<objDRAGDROP.arrXYpoints.count; i++) {
        
        NSArray *points = [[objDRAGDROP.arrXYpoints objectAtIndex:i] componentsSeparatedByString:@","];
        float x_point = [[points objectAtIndex:0] floatValue];
        float y_point = [[points objectAtIndex:1] floatValue];
        
        UIButton *bn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bn setFrame:CGRectMake(x_point, y_point, objDRAGDROP.fWidth, objDRAGDROP.fHeight)];
        [bn setBackgroundColor:[UIColor clearColor]];
        [imgDropView addSubview:bn];
        [droppableAreas addObject:bn];
        
    }
    
    _dragDropManager = [[DragDropManager alloc] initWithDragSubjects:draggableSubjects andDropAreas:droppableAreas];
    uiTapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_dragDropManager action:@selector(dragging:)];
    [[self view] addGestureRecognizer:uiTapGestureRecognizer];
    
}


- (void) createRadioButtons{
    
    
    arr_radioButtons = [[NSMutableArray alloc] init];
    
    
    int feedWidth = 36;
    int feedHeight = 39;
    
    float x, y;
    float xx, yy;
    int height, width;
    
    int spacingWidth = 91;
    int spacingHeight = 50;
    
    y = 30;
    height = 22;
    width = 22;
    
    float firstX;
    float firstY;
    float secondX;
    float secondY;
    float thirdX;
    float thirdY;
    
    
    RadioOptions = objDRAGDROP.arrRadioOptions.count;
    
    if (objDRAGDROP.intDRAGDROPRADIOid == 25) {
        spacingWidth = 92;
        spacingHeight = objDRAGDROP.fHeight;
        x = objDRAGDROP.fWidth + 10;
        y = 32;
        
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 26) {
        spacingWidth = 100;
        spacingHeight = objDRAGDROP.fHeight;
        x = objDRAGDROP.fWidth + 10;
        y = 32;
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 14) {
        RadioOptions = 2;
        spacingWidth = 160;
        firstX = 304;
        firstY = 0;
        secondX = 315;
        secondY = 40;
        thirdX = 14;
        thirdY = 86;
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 15) {
        RadioOptions = 2;        
        spacingWidth = 160;
        spacingHeight = objDRAGDROP.fHeight;
        firstX = 42;
        firstY = 57;
        secondX = 40;
        secondY = 101;
        thirdX = 406;
        thirdY = 101;
    }

    
    if (objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15) {
        
        for( int k =0; k < objDRAGDROP.arrRadioAnswers.count; k++){
            
            if (k == 0 ) {
                x = firstX;
                y = firstY;
            }
            else if (k == 1 ) {
                x = secondX;
                y = secondY;
            }
            else if (k == 2) {
                x = thirdX;
                y = thirdY;
            }
            
            NSArray *arrTemp = [[objDRAGDROP.arrRadioOptions objectAtIndex:k] componentsSeparatedByString:@","];
            
            // Option 1
            objRadioView = [[RadioView alloc] init];
            //objRadioView.backgroundColor = COLOR_DARKGRAY;
            [objRadioView setFrame:CGRectMake(x, y, spacingWidth, spacingHeight)];
            xx = 0;
            yy = (spacingHeight/2) - 5;
            [objRadioView.btnOption1 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption1 setTag:k];
            [objRadioView.btnOption1 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [objRadioView.btnOption1 setTitle:[arrTemp objectAtIndex:0] forState:UIControlStateNormal];
            
            UILabel *lbl1 =[[UILabel alloc] initWithFrame:CGRectMake(xx+width, yy, (spacingWidth/2)-width, height)];
            [lbl1 setText:[arrTemp objectAtIndex:0]];
            [lbl1 setTextColor:COLOR_BLUE];
            lbl1.backgroundColor  = COLOR_CLEAR;
            lbl1.font = FONT_14;
            [objRadioView addSubview:lbl1];
            
            [objRadioView.ansImage1 setImage:nil];
            [objRadioView.ansImage1 setFrame:CGRectMake(objRadioView.btnOption1.frame.origin.x + width + 10, yy - 16, width, height)];
            
//            [objRadioView.btnFeedback1 setFrame:CGRectMake(objRadioView.ansImage1.frame.origin.x + width + 10, yy - 10, feedWidth, feedHeight)];
//            [objRadioView.btnFeedback1 setTag:k];
//            [objRadioView.btnFeedback1 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
//            objRadioView.btnFeedback1.hidden = YES;
//            objRadioView.btnOption1.enabled = YES;
            xx = xx + spacingWidth/2;
            
            
            // Option 2
            
            [objRadioView.btnOption2 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption2 setTag:k];
            [objRadioView.btnOption2 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [objRadioView.btnOption1 setTitle:[arrTemp objectAtIndex:1] forState:UIControlStateNormal];
            
            UILabel *lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(xx+width, yy, (spacingWidth/2)-width, height)];
            [lbl2 setText:[arrTemp objectAtIndex:1]];
            [lbl2 setTextColor:COLOR_BLUE];
            lbl2.font = FONT_14;
            lbl2.backgroundColor  = COLOR_CLEAR;
            [objRadioView addSubview:lbl2];
            
            [objRadioView.ansImage2 setImage:nil];
            [objRadioView.ansImage2 setFrame:CGRectMake(objRadioView.btnOption2.frame.origin.x + width + 10, yy - 16, width, height)];
            
//            [objRadioView.btnFeedback2 setFrame:CGRectMake(objRadioView.ansImage2.frame.origin.x + width + 10, yy -10, feedWidth, feedHeight)];
//            [objRadioView.btnFeedback2 setTag:k];
//            [objRadioView.btnFeedback2 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
//            objRadioView.btnFeedback2.hidden = YES;
            xx = xx + spacingWidth;
            

                
            objRadioView.btnOption3.hidden = YES;
            objRadioView.btnOption4.hidden = YES;
            objRadioView.btnOption5.hidden = YES;
            
            [imgDropView addSubview:objRadioView];
            
            [arr_radioButtons addObject:objRadioView];
            
            y = y + objDRAGDROP.fHeight + 10;
        }
    }
    else {
        for( int k =0; k < objDRAGDROP.arrRadioAnswers.count; k++){
        
        // Option 1
        objRadioView = [[RadioView alloc] init];
        //objRadioView.backgroundColor = COLOR_DARKGRAY;
        [objRadioView setFrame:CGRectMake(x, y, spacingWidth*RadioOptions, spacingHeight)];
        xx = 5;
        yy = (spacingHeight/2) - 5;
        [objRadioView.btnOption1 setFrame:CGRectMake(xx, yy, width, height)];
        [objRadioView.btnOption1 setTag:k];
        [objRadioView.btnOption1 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [objRadioView.ansImage1 setImage:nil];        
        [objRadioView.ansImage1 setFrame:CGRectMake(objRadioView.btnOption1.frame.origin.x + width + 10, yy, width, height)];
        
        [objRadioView.btnFeedback1 setFrame:CGRectMake(objRadioView.ansImage1.frame.origin.x + width + 10, yy, feedWidth, feedHeight)];
        [objRadioView.btnFeedback1 setTag:k];
        [objRadioView.btnFeedback1 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        objRadioView.btnFeedback1.hidden = YES;
        objRadioView.btnOption1.enabled = YES;
         xx = xx + spacingWidth;
        
        
        // Option 2
        
        [objRadioView.btnOption2 setFrame:CGRectMake(xx, yy, width, height)];
        [objRadioView.btnOption2 setTag:k];
        [objRadioView.btnOption2 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [objRadioView.ansImage2 setImage:nil];
        [objRadioView.ansImage2 setFrame:CGRectMake(objRadioView.btnOption2.frame.origin.x + width + 10, yy, width, height)];
        
        [objRadioView.btnFeedback2 setFrame:CGRectMake(objRadioView.ansImage2.frame.origin.x + width + 10, yy, feedWidth, feedHeight)];
        [objRadioView.btnFeedback2 setTag:k];
        [objRadioView.btnFeedback2 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        objRadioView.btnFeedback2.hidden = YES;
        xx = xx + spacingWidth;
        
        
        // Option 3
        
        [objRadioView.btnOption3 setFrame:CGRectMake(xx, yy, width, height)];
        [objRadioView.btnOption3 setTag:k];
        [objRadioView.btnOption3 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [objRadioView.ansImage3 setImage:nil];
        [objRadioView.ansImage3 setFrame:CGRectMake(objRadioView.btnOption3.frame.origin.x + width + 10, yy, width, height)];
        
        [objRadioView.btnFeedback3 setFrame:CGRectMake(objRadioView.ansImage3.frame.origin.x + width + 10, yy, feedWidth, feedHeight)];
        [objRadioView.btnFeedback3 setTag:k];
        [objRadioView.btnFeedback3 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        objRadioView.btnFeedback3.hidden = YES;
        xx = xx + spacingWidth;

        
        
        // Option 4
        [objRadioView.btnOption4 setFrame:CGRectMake(xx, yy, width, height)];
        [objRadioView.btnOption4 setTag:k];
        [objRadioView.btnOption4 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [objRadioView.ansImage4 setImage:nil];
        [objRadioView.ansImage4 setFrame:CGRectMake(objRadioView.btnOption4.frame.origin.x + width + 10, yy, width, height)];
        
        [objRadioView.btnFeedback4 setFrame:CGRectMake(objRadioView.ansImage4.frame.origin.x + width + 10, yy, feedWidth, feedHeight)];
        [objRadioView.btnFeedback4 setTag:k];
        [objRadioView.btnFeedback4 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        objRadioView.btnFeedback4.hidden = YES;
        xx = xx + spacingWidth;
        
        
        // Option 5
        [objRadioView.btnOption5 setFrame:CGRectMake(xx, yy, width, height)];
        [objRadioView.btnOption5 setTag:k];
        [objRadioView.btnOption5 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [objRadioView.ansImage5 setImage:nil];
        [objRadioView.ansImage5 setFrame:CGRectMake(objRadioView.btnOption5.frame.origin.x + width + 10, yy, width, height)];
        
        [objRadioView.btnFeedback5 setFrame:CGRectMake(objRadioView.ansImage5.frame.origin.x + width + 10, yy, feedWidth, feedHeight)];
        [objRadioView.btnFeedback5 setTag:k];
        [objRadioView.btnFeedback5 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        objRadioView.btnFeedback5.hidden = YES;
        
        
        
        if (RadioOptions == 2) {
            objRadioView.btnOption3.hidden = YES;
            objRadioView.btnOption4.hidden = YES;
            objRadioView.btnOption5.hidden = YES;
        }
        else if (RadioOptions == 3) {
            objRadioView.btnOption4.hidden = YES;
            objRadioView.btnOption5.hidden = YES;
        }
        else if (RadioOptions == 4) {
            objRadioView.btnOption5.hidden = YES;
        }
        
        [imgDropView addSubview:objRadioView];
        
        [arr_radioButtons addObject:objRadioView];
        
        y = y + objDRAGDROP.fHeight + 10;
    }
    }
}

- (void) Fn_Radio_Tapped:(id)sender{

    objRadioView = [arr_radioButtons objectAtIndex:[sender tag]];
    
    [objRadioView.btnOption1 setImage:imgRadio forState:UIControlStateNormal];
    [objRadioView.btnOption2 setImage:imgRadio forState:UIControlStateNormal];
    [objRadioView.btnOption3 setImage:imgRadio forState:UIControlStateNormal];
    
    [sender setImage:imgRadioSelected forState:UIControlStateNormal];
    
    if (sender == objRadioView.btnOption1) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:0];
        if (objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15) {
            NSArray *temp = [[objDRAGDROP.arrRadioOptions objectAtIndex:0] componentsSeparatedByString:@","];
            objRadioView.selected = [temp objectAtIndex:0];
        }
        objRadioView.selectedIndex = 1;
    }
    else if (sender == objRadioView.btnOption2) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:1];
        if (objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15) {
            NSArray *temp = [[objDRAGDROP.arrRadioOptions objectAtIndex:0] componentsSeparatedByString:@","];
            objRadioView.selected = [temp objectAtIndex:1];
        }
        objRadioView.selectedIndex = 2;
    }
    else if (sender == objRadioView.btnOption3) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:2];
        objRadioView.selectedIndex = 3;
    }
    else if (sender == objRadioView.btnOption4) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:3];
        objRadioView.selectedIndex = 4;
    }
    else if (sender == objRadioView.btnOption5) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:4];
        objRadioView.selectedIndex = 5;
    }
}

- (NSString *) fn_getFeeback:(NSMutableArray *)feedbackArr AndCorrect:(NSString *)correctincorrect Andfeed:(int)intfeed {
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
- (NSString *) fn_getFeeback2:(int)intfeed AndCorrect:(NSString *)correctincorrect{
    NSString *strTemp = nil;
    
    for (int x=0; x<objDRAGDROP.arrFeedback.count; x++) {
        objFeedback =  [objDRAGDROP.arrFeedback objectAtIndex:x];
        NSString *trimmedOption = [objFeedback.strOption stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        char letter = [trimmedOption characterAtIndex:0];
        int char_index = [md charToScore:letter] ;
        
        NSString *trimmedType = [objFeedback.strType stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        trimmedType = [trimmedType lowercaseString];
        
        if (intfeed == char_index-1) {
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
    //txt_feedback.text = textValue;
    txt_feedback.text = [NSString stringWithFormat:@"Feedback: %@",textValue];
    txt_feedback.textColor = [UIColor whiteColor];
    txt_feedback.backgroundColor = [UIColor clearColor];
    txt_feedback.font = BOLD_FONT_14;
    txt_feedback.editable = NO;
    [txt_feedback setFrame:CGRectMake(13, 13, 235, 104)];
    [feedbackView addSubview:txt_feedback];
    [self.view addSubview:feedbackView];
}
- (void) Fn_Feedback_Tapped:(id)sender {
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) rotateScrollViewButtonsForLandscape{
    int counter= 0;
    int y = 10;
    for(UIView *myView in [scrollViewDrag subviews]){
        if([myView isKindOfClass:[CustomDragButton class]]){
            counter++;
            [myView removeFromSuperview];
            myView.frame = CGRectMake(20, y, myView.frame.size.width, myView.frame.size.height);
            [scrollViewDrag addSubview:myView];
            y = y + myView.frame.size.height + 10   ;
        }
    }
}

- (void) rotateScrollViewButtonsForPortrait{
    int counter= 0;
    int y = 10, x= 20;
    
    for(UIView *myView in [scrollViewDrag subviews]){
        if([myView isKindOfClass:[CustomDragButton class]]){
            counter++;
            [myView removeFromSuperview];
            myView.frame = CGRectMake(x, y, myView.frame.size.width, myView.frame.size.height);
            [scrollViewDrag addSubview:myView];
            y = y + myView.frame.size.height + 10;
            if(counter == 4){
                y = 10;
                x = x + myView.frame.size.width + 10;
                counter = 0;
            }
        }
    }
}




//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id{
    objDRAGDROP = [db fnGetTestyourselfDRAGDROPRadio:question_id];
}
-(void) fn_CheckAnswersBeforeSubmit{
    
	flagForAnyOptionSelect = NO;
    
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        if (dropArea.subviews.count == 0) {
            flagForAnyOptionSelect = YES;
        }
    }
    
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        if ([objRadioView.selected isEqualToString:@"0"]) {
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
-(void) fn_OnSubmitTapped{
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

- (BOOL) checkForAnswer{
    int i = 0;
    NSMutableString *strAns = [[NSMutableString alloc] init];
    BOOL flag1 = YES;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            UIButton *bn = [arrSubviews objectAtIndex:0];
            NSString *ss = [bn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *sa = [[objDRAGDROP.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                flag1 = NO;
                break;
            }
            if (i == [objDRAGDROP.arrAnswer count] - 1)
                [strAns appendFormat:@"%@", ss];
            else
                [strAns appendFormat:@"%@#", ss];
        }
        strVisitedAnswer = [NSString stringWithFormat:@"%@",strAns];
        i++;
    }
    
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        NSString *answer = [objDRAGDROP.arrRadioAnswers objectAtIndex:i];
        
        NSString *ss = [objRadioView.selected stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
			flag1 = NO;
		}
        if (i == [arr_radioButtons count] - 1)
            [strAns appendFormat:@"%@", ss];
        else
            [strAns appendFormat:@"%@#", ss];
    }
    strVisitedAnswer = [NSString stringWithFormat:@"%@",strAns];
    
    return flag1;
}
- (void) handleShowAnswers{
    
}
- (void) handleRevealScore{
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        NSString *answer = [objDRAGDROP.arrRadioAnswers objectAtIndex:i];
        
        NSString *ss = [objRadioView.selected stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [answer  stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        UIImageView *ansImage =  nil;
        UIButton *bnFeedback = nil;
        
        switch (objRadioView.selectedIndex) {
            case 1:
                ansImage =  objRadioView.ansImage1;
                bnFeedback = objRadioView.btnFeedback1;
                break;
            case 2:
                ansImage =  objRadioView.ansImage2;
                bnFeedback = objRadioView.btnFeedback2;
                break;
            case 3:
                ansImage =  objRadioView.ansImage3;
                bnFeedback = objRadioView.btnFeedback3;
                break;
            case 4:
                ansImage =  objRadioView.ansImage4;
                bnFeedback = objRadioView.btnFeedback4;
                break;
            case 5:
                ansImage =  objRadioView.ansImage5;
                bnFeedback = objRadioView.btnFeedback5;
                break;
        }
        
        if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
			[ansImage setImage:[UIImage imageNamed:@"Btn_feed_false.png"]];
            
            NSString *feeback = [self fn_getFeeback:objDRAGDROP.arrFeedback AndCorrect:@"incorrect" Andfeed:objRadioView.selectedIndex];
            if (feeback.length > 0) {
                bnFeedback.hidden = NO;
                objRadioView.feedback = feeback;
            }
            
		}else {
			
			[ansImage setImage:[UIImage imageNamed:@"Btn_feed_true.png"]];
            
            NSString *feeback = [self fn_getFeeback:objDRAGDROP.arrFeedback AndCorrect:@"correct" Andfeed:objRadioView.selectedIndex];
            if (feeback.length > 0) {
                bnFeedback.hidden = NO;
                objRadioView.feedback = feeback;
            }
        }
    }
    
    int i = 0;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            CustomDragButton *bn = [arrSubviews objectAtIndex:0];
            NSString *ss = [bn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *sa = [[objDRAGDROP.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                [bn.ansImage setImage:[UIImage imageNamed:@"Btn_feed_false.png"]];
                NSString *feeback = [self fn_getFeeback2:bn.tag AndCorrect:@"incorrect"];
                if (feeback.length > 0) {
                    bn.feedbackBt.hidden = NO;
                    bn.strFeedback = feeback;
                    [bn addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }else {
                [bn.ansImage setImage:[UIImage imageNamed:@"Btn_feed_true.png"]];
                NSString *feeback = [self fn_getFeeback2:bn.tag AndCorrect:@"correct"];
                if (feeback.length > 0) {
                    bn.feedbackBt.hidden = NO;
                    bn.strFeedback = feeback;
                    [bn addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }
        }
        i++;
    }
    
    [self disableEditFields];
}
- (void) disableEditFields {
    
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        objRadioView.btnOption1.enabled = NO;
        objRadioView.btnOption2.enabled = NO;
        objRadioView.btnOption3.enabled = NO;
        objRadioView.btnOption4.enabled = NO;
        objRadioView.btnOption5.enabled = NO;
    }
}
- (void) Fn_disableAllDraggableSubjects{
    for(UIButton *subview in [imgDropView subviews]) {
        [self.view removeGestureRecognizer:uiTapGestureRecognizer];
    }
}
//--------------------------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
            [self Fn_disableAllDraggableSubjects];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
            [self Fn_disableAllDraggableSubjects];            
        }
        else if (buttonIndex == 1)
        {
            [self handleShowAnswers];
        }
    }
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
    [webviewInstructions setFrame:CGRectMake(19, 130, 725, 70)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(x_feedback_p, y_feedback_p, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 20, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(125, 20, 570, 72)];
    
    
    // ScrollView
    [imgScroller setFrame:CGRectMake(20, 370, 730, 360)];
    imgScroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, imgScroller.bounds.size.width - 730);
    [scrollViewDrag setFrame:CGRectMake(20, 220, 730, 150)];
    [self rotateScrollViewButtonsForPortrait];
    
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
    [imgScroller setFrame:CGRectMake(258, 153, 800, 427)];
    imgScroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, imgScroller.bounds.size.width - 727);
    [scrollViewDrag setFrame:CGRectMake(20, 153, 237, 427)];
    
    [self rotateScrollViewButtonsForLandscape];
}
@end
