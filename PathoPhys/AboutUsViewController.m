//
//  AboutUsViewController.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 21/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    IBOutlet UIImageView *imgBG;
    IBOutlet UIButton *btnClose;
    IBOutlet UIWebView *webView;
}
@end

@implementation AboutUsViewController
@synthesize lblTitle;

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
    
    lblTitle.font = FONT_20;
    lblTitle.textColor = COLOR_WHITE;
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        webView.scrollView.scrollEnabled = YES;
    }
    else{
        webView.scrollView.scrollEnabled = NO;
    }
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}

- (void) Fn_LoadAboutData:(int)index
{
    
    if (index == 0) {
        lblTitle.text = @"About the Author";
    }
    else if (index == 1) {
        lblTitle.text = @"About the App";
    }
    else if (index == 2) {
        lblTitle.text = @"About Elsevier Australia";
    }
    
    NSString *webdata = nil;
    if (index == 1) {
        webdata = @"About the App";
    }
    else if(index == 0) {
        webdata = @"<b>About the author</b><br /><br />        <b>Sarah List<br /> PhD, BSc (Hons), BA </b><br />        Course Coordinator and Lecturer, Bachelor of Nursing Program <br/>        School of Pharmacy and Medical Sciences, Division of Health Sciences,<br />        University of South Australia, Adelaide <br />        <br/>        <b><a href='http://www.elsevierhealth.com.au/au/product.jsp?sid=&isbn=9780729539517&lid=EHS_ANZ_BS-DIS-4&iid=&utm_campaign=patho_app&utm_medium=app_tracking&utm_source=elsevier_ad&utm_content=understanding_patho'>About Understanding Pathophysiology ñ ANZ adaptation</a></b><br /><br />   <b>The authors:</b><br />        <b>Judy Craft</b> BAppSc (Hons), PhD; <b>Christopher Gordon</b> RN, MExSc, PhD; <b>Adriana P Tiziani</b> RN, BSc, Dip Ed, MEdSt, MRCNA;<b> Sue E Huether</b> RN, PhD; <b>Kathryn L McCance</b> RN, PhD and Valentina L Brashers MD<br />        A new pathophysiology textbook specifically for Australian and New Zealand nursing students.<br/>            <br/>            Understanding Pathophysiology provides nursing students with the optimal balance between science, clinical case material and pharmacology.  <br /><br />            This local edition of Understanding Pathophysiology incorporates a lifespan approach  and explores contemporary health with specific chapters on stress, genes and the environment, obesity and diabetes, cancer, mental illness and Indigenous health issues. <br /><br />";
    }
    else {
     
        webdata = @"<b>About Elsevier Australia</b><br /><br />        Elsevier Australia is the leading publisher of textbooks, professional titles and e-solutions for students, lecturers and health science professionals. <br /><br />            With a catalogue of publications spanning the entire health science spectrum, Elsevier Australia specialises in titles for medicine and surgery, nursing and midwifery, dentistry, veterinary science and a wide range of allied health professions.<br /><br />                As well as offering the very best international titles, Elsevier Australia engages the expertise of authoritative local authors and contributors to provide quality publications tailored for students, academics and practitioners within the region. <br /><br />                    Elsevier Australia is an instrumental arm of the global Elsevier group ñ founded in the Netherlands in 1880. Elsevier is today an international multimedia publishing powerhouse, providing essential tools to healthcare communities around the world. <br /><br />                    The company proudly counts several respected imprints within its number, including Churchill Livingstone, Academic Press, Butterworth-Heinemann, BailliËre Tindall, Hanley & Belfus, Saunders and Mosby. <br /><br />                    For world-class content in the format thatís right for you, visit the popular <b>Elsevier Australia online shop</b> <a href='http://www.elsevierhealth.com.au'>http://www.elsevierhealth.com.au</a>.  Youíll find a comprehensive list of textbooks, reference titles, periodicals, journals and e-solutions ñ both local and international ñ along with great discounts on bestselling titles.<br /><br />                        Alternatively, contact the <b>Elsevier Australia Customer Service</b> team by emailing <a href='mailto:customerserviceau@elsevier.com'>customerserviceau@elsevier.com</a>  or calling 1800 263 951 (toll free within Australia) or                        0800 170 165 (toll free from New Zealand) .";
    }

    NSString *data = [NSString stringWithFormat:@"<html><body style=\"background-color: #FFFFFF; color: #000000; font-family: Helvetica; font-size: 10pt; word-wrap: break-word;\"> %@</body></html>", webdata];
    [webView loadHTMLString:data baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClose:(id)sender
{
    [md Fn_SubAbout];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
	}
	else {
        [self Fn_rotatePortrait];
	}
    
	return YES;
}

-(void)Fn_rotatePortrait
{
    [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
    
    [imgBG setImage:[UIImage imageNamed:@"img_aboutus_bg_p.png"]];
    [imgBG setFrame:CGRectMake(0,45,768,1004)];
    
    [btnClose setFrame:CGRectMake(647,172,41,36)];
    [lblTitle setFrame:CGRectMake(162,172,555,48)];
    [webView setFrame:CGRectMake(110,259,560,548)];
    
}
-(void)Fn_rotateLandscape
{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    
    [imgBG setImage:[UIImage imageNamed:@"img_aboutus_bg.png"]];
    [imgBG setFrame:CGRectMake(0,45,1024,722)];
    
    [btnClose setFrame:CGRectMake(847,145,41,36)];
    [webView setFrame:CGRectMake(121,189,782,448)];
    [lblTitle setFrame:CGRectMake(141,143,555,48)];
}

@end
