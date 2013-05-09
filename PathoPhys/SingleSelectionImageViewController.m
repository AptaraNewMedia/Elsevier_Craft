//
//  SingleSelectionImageViewController.m
//  PathoPhys
//
//  Created by Rohit Yermalkar on 26/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "SingleSelectionImageViewController.h"
#import "MCSS.h"
#import "Feedback.h"
#import "MCSSCell_iPad.h"   
#import "TestYourSelfViewController.h"


@interface SingleSelectionImageViewController ()

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
    IBOutlet UIScrollView *scrollViewOptions;
    IBOutlet UIImageView *imgViewQuestion;
    int qType;
    
     NSString *temp;
}


@end

@implementation SingleSelectionImageViewController

@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize intVisited;
@synthesize strVisitedAnswer;
@synthesize parentObject;


- (void) viewDidLoad{
    [super viewDidLoad];
    
    lblQuestionText.text = objMCSS.strQuestionText ;
    cellArray = [[NSMutableArray alloc] init];
    
    [self fn_SetFontColor];
    
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
    [self Fn_createScrollViewOptions];
    
//    qType =1;
//    //1 ===> Single Select
//    //2 ===> Multiple Select
    
    qType = 1;
    
    if([objMCSS.arrAnswer count] > 1){
        qType = 2;
        //NSLog(@"Multiple Select");
    }
    else{
        qType = 1;
        //NSLog(@"Single Select");
    }

    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}



//Get db data from question_id
//--------------------------------
- (void) fn_LoadDbData:(NSString *)question_id{
    objMCSS = [db fnGetTestyourselfMCSS:question_id];
}
- (void) Fn_createScrollViewOptions{
   
    int scrollViewX,scrollViewY;
    int scrollViewWidth;
    scrollViewY = 126;
    
    if(objMCSS.strImageName == (id)[NSNull null]){
        //This template does not contain image. ScrollView needs to be bigger in width.
        NSLog(@"big");
        scrollViewX = 36;
        scrollViewWidth = 950;
        imgViewQuestion.hidden = YES;
    }
    else{
        //This template does  contain image. This templates should show both image and scrollView;
        NSLog(@"small");
        temp = [[NSBundle mainBundle] pathForResource:objMCSS.strImageName ofType:nil inDirectory:@""];
        [imgViewQuestion setImage:[UIImage imageWithContentsOfFile:temp]];
        scrollViewX = 490;
        scrollViewWidth = 496;
        imgViewQuestion.hidden = NO;
    }
    
    
    int tempx , tempy;
    tempx = 10;
    tempy = 10;
    
    for (int i =0; i < [objMCSS.arrOptions count]; i++){
        UIButton *bn_option = [UIButton buttonWithType:UIButtonTypeCustom];
        bn_option.frame = CGRectMake(tempx, tempy, 300, 70);
        [bn_option setTitle:[objMCSS.arrOptions objectAtIndex:i] forState:UIControlStateNormal];
        [bn_option addTarget:self action:@selector(Bn_Option_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        [bn_option setBackgroundColor:[UIColor grayColor]];
        bn_option.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        bn_option.titleLabel.textAlignment = NSTextAlignmentCenter;
        bn_option.tag = i + 1;
        [scrollViewOptions addSubview:bn_option];
        tempy = tempy + 90;
    }
    
    [scrollViewOptions setContentSize:CGSizeMake(496,[objMCSS.arrOptions count] * 70 + ([objMCSS.arrOptions count] -1) *20)];
    
    
    [scrollViewOptions setScrollEnabled:YES];
}

- (IBAction)Bn_Option_Tapped:(id)sender{
    
    flagForAnyOptionSelect = NO;
    
    if(qType == 1){
        
        for(UIView *myView in scrollViewOptions.subviews){
            [myView setBackgroundColor:[UIColor grayColor]];
        }
        
        [sender setBackgroundColor:[UIColor blueColor]];
    }
    else{
        [sender setBackgroundColor:[UIColor blueColor]];
    }
    
}

-(void) fn_OnSubmitTapped{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:TITLE_COMMON];
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


- (void) Fn_createInvisibleBtn{
    btnInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnInvisible setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    btnInvisible.backgroundColor = [UIColor clearColor];
    [btnInvisible addTarget:self action:@selector(onInvisible:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInvisible];
    btnInvisible.hidden = YES;
}
- (void) fn_SetFontColor{
    lblQuestionNo.textColor = COLOR_WHITE;
    lblQuestionText.textColor = COLOR_WHITE;
    
    lblQuestionNo.font = FONT_31;
    lblQuestionText.font = FONT_17;
    
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
//    [lblQuestionNo setFrame:CGRectMake(17, 25, 93, 114) ];
//    
//    
//    //  [webviewInstructions setFrame:CGRectMake(20, 140, 727, 32) ];
//    
//    
//    [ImgQuestionBg setImage:[UIImage imageNamed:@"text-box.png"]];
//    [ImgQuestionBg setFrame:CGRectMake(0, 17, 767, 803)];
//    
//    [ImgQuestionTextBg setImage:[UIImage imageNamed:@"blue_5text_bar.png"]];
//    [ImgQuestionTextBg setFrame:CGRectMake(0, 17, 767, 177)];
//    
//    [webviewInstructions setFrame:CGRectMake(19, 190, 725, 45)];
//    
//    [ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator_P.png"]];
//    [ImgQuestionSeperator setFrame:CGRectMake(4, 225, 767, 53)];
//    
//    [lblQuestionText setFrame:CGRectMake(118, 40, 570, 114) ];
//    
//    
//    if(temp == NULL)
//    {
//        
//        [scrollViewOptions setFrame:CGRectMake(59, 256, 496, 454)];
//    }
//    else
//    {
//        [imgViewQuestion setFrame:CGRectMake(36, 196, 425, 313)];
//        [scrollViewOptions setFrame:CGRectMake(389, 256, 496, 454)];
//    }
    
}
-(void)Fn_rotateLandscape
{
//    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75) ];
//    
//    [webviewInstructions setFrame:CGRectMake(17, 93, 968, 32) ];
//    
//    [ImgQuestionBg setFrame:CGRectMake(0, 0, 1005, 600)];
//    [ImgQuestionBg setImage:[UIImage imageNamed:@"img_question_bg.png"]];
//    
//    [ImgQuestionTextBg setFrame:CGRectMake(0, 17, 1005, 75)];
//    [ImgQuestionTextBg setImage:[UIImage imageNamed:@"img_questiontext2_bg.png"]];
//    
//    [ImgQuestionSeperator setFrame:CGRectMake(13, 128, 977, 54)];
//    [ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator.png"]];
//    
//    [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72) ];
//    
//    // [scrollViewOptions setFrame:CGRectMake(489, 126, 496, 454)];
//    
//    
//    if(temp == NULL)
//    {
//        
//        [scrollViewOptions setFrame:CGRectMake(69, 126, 496, 454)];
//    }
//    else
//    {
//        [imgViewQuestion setFrame:CGRectMake(36, 196, 425, 313)];
//        [scrollViewOptions setFrame:CGRectMake(489, 126, 496, 454)];
//    }
    
    
}

@end
