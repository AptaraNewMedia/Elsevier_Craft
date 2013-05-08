//
//  Constants.h
//  Springer1.1
//
//  Created by PUN-MAC-012 on 05/02/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

//*************** ALL ALERT's TITLE **********
#define TITLE_WARN @"Warning"
#define TITLE_INFO @"Information"
#define TITLE_CONF @"Confirm"
#define TITLE_ALERT @"Alert"
#define TITLE_MSG @"Message"
#define TITLE_COMMON @"Pathophysquiz"
//*************** ALL ALERT's TITLE **********`


#define ALERT_SUBMIT_RESULT @"You have reached the end of the Quiz. \n\nTap Review if you wish to review and change the previously selected answers. \n\nTap Submit to view the results."



#define BTN_REVIEW @"Review"
#define BTN_SUBMIT @"Submit"
#define BTN_OK @"Ok"
#define BTN_CANCEL @"Cancel"


#define DELIMITER_ARR @"$#$"