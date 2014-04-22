//
//  SubmitAttend.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 2/8/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@class ServerManager;
@class GradientButton;

@interface SubmitAttend : UIViewController{
    ServerManager *server;
    Reachability* hostReach;
}
@property (retain, nonatomic) IBOutlet UILabel *taName;

@property (retain, nonatomic) IBOutlet UILabel *CurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *Slote;
@property (retain, nonatomic) IBOutlet UILabel *totalStudents;
@property (retain, nonatomic) IBOutlet UITextField *LocationTF;
@property (retain, nonatomic) IBOutlet GradientButton *DoneB;
@property (retain, nonatomic) IBOutlet GradientButton *BackB;
@property (retain, nonatomic) IBOutlet GradientButton *EditToSecondVB;

- (NSString*)updateCurrentDate:(NSDate*)newDate;


@end
