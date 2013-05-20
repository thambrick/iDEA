//
//  CustomSegueBottom.m
//  i-ShaRE
//
//  Created by Trey Hambrick on 5/6/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import "CustomSegueBottom.h"
#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation CustomSegueBottom

- (void) perform {
    
    ViewController *sourceViewController = (ViewController*)[self sourceViewController];
    ViewController *destinationController = (ViewController*)[self destinationViewController];

    CATransition* transition = [CATransition animation];
    transition.duration = .4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom

    [sourceViewController.navigationController.view.layer addAnimation:transition  forKey:kCATransition];

    [sourceViewController.navigationController pushViewController:destinationController animated:NO];

}

@end
