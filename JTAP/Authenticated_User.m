//
//  Authenticated_User.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/28/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import "Authenticated_User.h"

@implementation Authenticated_User

@synthesize username,password,access_token,uid,name;

-(id)init:(NSString*) _username:(NSString*) _password :(NSString*)code :(NSString*) _uid :(NSString*)_name
{
    self = [super init];
    if (self) {
        username = _username;
        password = _password;
        access_token = code;
        uid = _uid;
        name = _name;
        
    }
    return self;
}

-(NSString*)_passCode
{
    return password;
}



- (NSString *)description {
    NSString *s = [NSString stringWithFormat:@"{\"username\" = \"%@\" , \"uid\" = \"%@\"}",username,uid];
    return s;
}





@end
