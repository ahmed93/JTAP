//
//  Student.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/31/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Groups.h"

@interface Student : NSObject{
    
    
    NSString * _ID;
    NSString * name;
    NSString * uid;
    Groups * group;
    
}

@property (retain,nonatomic) NSString *_ID;
@property (retain,nonatomic) NSString *name;
@property (retain,nonatomic) NSString *uid;
@property (retain,nonatomic) Groups *group;

-(id)init:(NSString*) _id:(NSString*) _name :(NSString*) _uid :(Groups*) _group;


@end
