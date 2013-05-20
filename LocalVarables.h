//
//  LocalVarables.h
//  i-ShaRE
//
//  Created by Trey Hambrick on 5/12/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocalVarables : NSManagedObject

@property (nonatomic, retain) NSString * agency;
@property (nonatomic, retain) NSString * leo;
@property (nonatomic, retain) NSString * passcode;
@property (nonatomic, retain) NSString * uploadEmail;
@property (nonatomic, retain) NSString * enablePasscode;

@end
