//
//  ResultViewController.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 14/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "ResultViewController.h"
#import "Reachability.h"

@interface ResultViewController ()
{
    IBOutlet UIImageView *imgPatch;
//    IBOutlet UIImageView *imgPopupBG;
//    IBOutlet UIImageView *imgBG;
    IBOutlet UIButton *btnClose;
    NSString *testscore;
    NSString *thematicAreaName;
    NSString *chapterName;
    int currentOrientaion;
}

-(IBAction)onClose:(id)sender;
-(IBAction)Bn_Facebook_Tapped:(id)sender;
-(IBAction)Bn_Email_Tapped:(id)sender;


@end

@implementation ResultViewController



@synthesize btnFB;
@synthesize btnMail;
@synthesize facebook;
@synthesize lblChapterName;
@synthesize lblChapterName_Title;
//@synthesize lblResult;
@synthesize lblScore;
@synthesize lblScore_Title;
@synthesize lblShare_Title;
@synthesize lblThematicArea;
@synthesize lblThematicArea_Title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    facebook = [[Facebook alloc] initWithAppId:@"532908203419529" andDelegate:self];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self Fn_SetFontColor];
}

-(void) Fn_SetFontColor {
    lblChapterName_Title.font = FONT_17;
    lblChapterName.font = FONT_17;

    lblScore_Title.font = FONT_17;
    lblScore.font = FONT_17;

    lblShare_Title.font = FONT_17;

    lblThematicArea_Title.font = FONT_17;
    lblThematicArea.font = FONT_17;
    

    lblChapterName_Title.textColor = COLOR_BLACK;
    lblChapterName.textColor = COLOR_BLACK;
    
    lblScore_Title.textColor = COLOR_BLACK;
    lblScore.textColor = COLOR_BLACK;
    
    lblShare_Title.textColor = COLOR_BLACK;
    
    lblThematicArea_Title.textColor = COLOR_BLACK;
    lblThematicArea.textColor = COLOR_BLACK;

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClose:(id)sender{
    self.view.hidden = YES;
}
-(IBAction)Bn_Facebook_Tapped:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                nil];
        [facebook authorize:permissions];
    }
    else{
        //Temporary
        //==========================================
        testscore = [NSString stringWithFormat:@"%d",int_currentScore];
        thematicAreaName = strCurrentThematicName;
        chapterName = strCurrentChapterName;
        //==========================================
          NSString *messageBody = [NSString stringWithFormat:@"I just took the Pathophysiology quiz to evaluate Thematic Area:%@ of Chapter:%@ and scored %@%%! Find out how much you know Pathophysiology.",thematicAreaName,chapterName,testscore];
        
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        nil];
        [params setObject:@"PathoPhysioQuiz App" forKey:@"name"];
        [params setObject:@"http://www.elsevier.com" forKey:@"link"];
        [params setObject:@"Caption Text comes here" forKey:@"caption"];
        //[params setObject:messageBody forKey:@"message"];
        //[params setObject:[UIImage imageNamed:@"Default.png"] forKey:@"picture"];
        [params setObject:messageBody forKey:@"description"];
        [facebook dialog: @"feed"
               andParams: params
             andDelegate: self];
    }
  
}
-(IBAction)Bn_Email_Tapped:(id)sender{
    
    //Temporary
    //==========================================
    testscore = [NSString stringWithFormat:@"%d",int_currentScore];
    thematicAreaName = strCurrentThematicName;
    chapterName = strCurrentChapterName;
    //==========================================
    
    //==========================================
    
    if ([MFMailComposeViewController canSendMail]) {
        NSString *emailTitle = @"Test Yourself Score";
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"I just took the Pathophysiology quiz to evaluate Thematic Area:%@ of Chapter:%@ and scored %@%%! Find out how much you know Pathophysiology.",thematicAreaName,chapterName,testscore];

        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send email. Please check if you have configured email account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark Email Delegate Methods

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *message;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            message = @"Mail cancelled";
            NSLog(@"Mail cancelled");
        }
            break;
        case MFMailComposeResultSaved:
        {
            message = @"Mail saved";
            NSLog(@"Mail saved");
        }
            break;
        case MFMailComposeResultSent:
        {
            message = @"Mail sent";
            NSLog(@"Mail sent");
        }
            break;
        case MFMailComposeResultFailed:
        {
            message = @"Mail sent failure";
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
        }
            break;
        default:
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


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


-(void)Fn_rotatePortrait
{
    [self.view setFrame:CGRectMake(0,0,768,1024)];
    
    [imgPatch setImage:[UIImage imageNamed:@"Portrait_Result_BG_01.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,768,1024)];
    
    [btnClose setFrame:CGRectMake(663,191,33,29)];
    
    [lblChapterName_Title setFrame:CGRectMake(116,258,128,24)];
    [lblChapterName  setFrame:CGRectMake(252,252,500,50)];
    
    [lblThematicArea setFrame:CGRectMake(252,275,500,193)];
    [lblThematicArea_Title setFrame:CGRectMake(118,361,130,19)];
    
    [lblScore_Title setFrame:CGRectMake(185,460,58,24)];
    [lblScore setFrame:CGRectMake(252,460,500,24)];
    
    [lblShare_Title setFrame:CGRectMake(186,696,55,21)];
    [btnFB setFrame:CGRectMake(252,692,36,29)];
    [btnMail setFrame:CGRectMake(314,692,36,29)];

    

}
-(void)Fn_rotateLandscape
{
    [self.view setFrame:CGRectMake(0,0,1024,768)];
    
   
    [imgPatch setImage:[UIImage imageNamed:@"landscape_Result_box_01.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,1024,768)];
    
    [lblChapterName  setFrame:CGRectMake(332,158,500,50)];
    [lblChapterName_Title setFrame:CGRectMake(196,163,128,24)];
    
    [lblThematicArea setFrame:CGRectMake(332,160,500,193)];
    [lblThematicArea_Title setFrame:CGRectMake(196,246,130,19)];
    
    [lblShare_Title setFrame:CGRectMake(262,502,55,21)];
    [btnFB setFrame:CGRectMake(332,502,36,29)];
    [btnMail setFrame:CGRectMake(396,502,36,29)];
    
    [lblScore_Title setFrame:CGRectMake(262,320,58,24)];
    [lblScore setFrame:CGRectMake(332,320,500,24)];
    
    [btnClose setFrame:CGRectMake(800,110,41,36)];
    
}

@end
