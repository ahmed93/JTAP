//
//  StudentsManager.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/30/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@class ServerManager;
@class Student;
@class Groups;


@interface StudentsManager : UITableViewController
{
    ServerManager *server;
    Reachability* hostReach;
    
    NSString * groupID;

}

@property(retain,nonatomic)NSString* groupID;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *SubmitionB;

-(void)setGroupID:(NSString *)group_ID;
- (IBAction)setNewSession:(id)sender;

@end
