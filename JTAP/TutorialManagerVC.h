//
//  TutorialManagerVC.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/27/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerManager;
@class TutorialManagerVC;
@class Reachability;
@class Authenticated_User;
@class Groups;

@interface TutorialManagerVC : UITableViewController{
    NSString* Access_token_Tut;
    
    ServerManager *server;
    Reachability* hostReach;
    Authenticated_User *AUser;
}

- (IBAction)DoLogOut:(id)sender;


@end
