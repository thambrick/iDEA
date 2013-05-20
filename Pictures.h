//
//  Pictures.h
//  i-ShaRE
//
//  Created by Trey Hambrick on 5/12/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Incident;

@interface Pictures : NSManagedObject

@property (nonatomic, retain) NSString * descPhoto;
@property (nonatomic, retain) NSNumber * idPhoto;
@property (nonatomic, retain) NSNumber * pictureNumber;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) Incident *incident;

@end
