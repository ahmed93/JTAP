//
//  Groups.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/29/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Groups : NSObject{
    
    
    NSString *Group_Name;
    NSString *Group_ID;
    
    
}

@property (retain,nonatomic) NSString *Group_Name;
@property (retain,nonatomic) NSString *Group_ID;

-(id)init:(NSString*) code:(NSString*) _ID;


@end
