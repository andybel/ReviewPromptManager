//
//  ReviewPromptManger.m
//  ThinkDesign
//
//  Created by Andy Bell on 18/06/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

#import "ReviewPromptManger.h"

NSString * const kAPPID = @"id890837037";

NSString *const RPMAlertString_Yes = @"Yes";
NSString *const RPMAlertString_NO = @"No";
NSString *const RPMAlertString_AskMeLater = @"Ask me later";

static NSString * const kReviewPromptCount = @"kReviewPromptCount";
static int const kNoFurtherPromptsVal = 666;
static int const kReviewPromptDisplayThreashold = 3;

@implementation ReviewPromptManger

+(void)checkForReviewPrompt {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"review prompt count = %li", (long)[[ud objectForKey:kReviewPromptCount] integerValue]);
    
    if ([ud objectForKey:kReviewPromptCount]) {
        
        NSInteger promptCount = [[ud objectForKey:kReviewPromptCount] integerValue];
        
        if (promptCount == kReviewPromptDisplayThreashold) {
            
            [self displayRatePrompt];
            [self resetPromptCount];
            
        }else if (promptCount != kNoFurtherPromptsVal && promptCount < kReviewPromptDisplayThreashold) {

            promptCount++;
            [self storePromptCountInteger:promptCount];
        }
        
    }else{
        [self resetPromptCount];
    }
    
}

+(void)storePromptCountInteger:(NSInteger)promptCount {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(promptCount) forKey:kReviewPromptCount];
    [ud synchronize];
}

+(void)noMoreReviewPrompts {
    [self storePromptCountInteger:kNoFurtherPromptsVal];
}

+(void)resetPromptCount {
    [self storePromptCountInteger:0];
}

+(void)displayRatePrompt {
    
    UIAlertView *ratePromt = [[UIAlertView alloc] initWithTitle:@"Like Vintage London?"
                                                        message:@"Rate us on the App store"
                                                       delegate:self
                                              cancelButtonTitle:RPMAlertString_AskMeLater
                                              otherButtonTitles:RPMAlertString_Yes, RPMAlertString_NO, nil];
    [ratePromt show];
    
}

+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:RPMAlertString_Yes]) {
        [self openAppStoreReviews];
    }else if ([btnTitle isEqualToString:RPMAlertString_NO]){
        [ReviewPromptManger noMoreReviewPrompts];
    }else{
        [ReviewPromptManger resetPromptCount];
    }
    
}

+(void)openAppStoreReviews {
    
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/%@", kAPPID];
    
    NSURL *urlAppStore = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:urlAppStore];
    
}

@end
