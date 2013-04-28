//
//  ScoreViewController.m
//  ScoreViewApp
//
//  Created by Aptara on 10/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CasestudyTextPopup.h"

@interface CasestudyTextPopup ()
{
    IBOutlet UIImageView *imgPatch;
    IBOutlet UIImageView *imgBG;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnClose;

    IBOutlet UIWebView *webView;
    
    int currentOrientation;
}
@end

@implementation CasestudyTextPopup

 
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
    [webView loadHTMLString:strCaseStudyText baseURL:nil];
}


-(IBAction)onClose:(id)sender
{
    [md Fn_SubCaseStudyText];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        currentOrientation =1;
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
        currentOrientation =1;
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
        currentOrientation =2;
	}
	else {
        [self Fn_rotatePortrait];
        currentOrientation =2;
	}
    
	return YES;
}


-(void)Fn_rotatePortrait
{
//    [imgBG setImage:[UIImage imageNamed:@"P_Img_Result.png"]];
//    [imgBG  setFrame:CGRectMake(0,0,768,1024)];
    
    
    [lblTitle setFrame:CGRectMake(170,87,386,38)];
    [btnClose setFrame:CGRectMake(653,89,41,36)];
}
-(void)Fn_rotateLandscape
{
    [imgPatch setImage:[UIImage imageNamed:@"L_Black_patch.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,1024,768)];
    
    [imgBG setImage:[UIImage imageNamed:@"BGImg_ScoreCard_with_Header.png"]];
    [imgBG setFrame:CGRectMake(134,67,755,615)];
    
    //[imgBG setImage:[UIImage imageNamed:@"L_Img_Result.png"]];
    //[imgBG  setFrame:CGRectMake(0,0,1024,768)];

    [lblTitle setFrame:CGRectMake(288,84,386,38)];
    [btnClose setFrame:CGRectMake(818,83,41,36)];
}

@end
