//
//  ServerManager.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 12/22/12.
//  Copyright (c) 2012 Ahmed Mohamed Fareed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject{
    
}


-(NSDictionary*)getGroups;
-(NSDictionary*)getList:(NSString*)group_ID;
//-(NSDictionary*)createStudent:(NSString *)StudentName :(NSString *) StudentID;
//-(NSDictionary*)deleteStudent:(int)indexPaths;
-(NSDictionary*)createSession :(NSString*)group_ID :(NSMutableArray *)ids :(NSString *) location :(NSString *) slot :(NSString*)date;
-(NSDictionary*)AuthenticatedUsers:(NSString *)username :(NSString *) password ;

@end

