//
//  Authenticated_User.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/28/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authenticated_User : NSObject {
    

    NSString *username;
    NSString *password;
    NSString *access_token;
    NSString *uid;
    NSString *name;
}

@property (retain,nonatomic) NSString *username;
@property (retain,nonatomic) NSString *password;
@property (retain,nonatomic) NSString *access_token;
@property (retain,nonatomic) NSString *uid;
@property (retain,nonatomic) NSString *name;

-(id)init:(NSString*) _username:(NSString*) _password :(NSString*)code :(NSString*) _uid :(NSString*)_name;
-(NSString*)_passCode;



@end
