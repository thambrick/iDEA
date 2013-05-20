//
//  CustomSegue.m
//  SigEpProject
//
//  Created by Trey Hambrick on 4/5/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import "CustomSegue.h"
#import "ViewController.h"

@implementation CustomSegue


- (void) perform {
       
    
    ViewController *src = (ViewController *) self.sourceViewController;
    
    ViewController *dst = (ViewController *) self.destinationViewController;
        
    [UIView transitionWithView:src.navigationController.view duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                         animations:^{
                        [src.navigationController pushViewController:dst animated:NO];     
                    }
                    completion:NULL];
    }

//[self presentModalViewController:view animated:YES];
//ViewController *sourceViewController = (ViewController*)[self sourceViewController];
//ViewController *destinationController = (ViewController*)[self destinationViewController];
//
//CATransition* transition = [CATransition animation];
//transition.duration = .4;
//transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//
//[sourceViewController.navigationController.view.layer addAnimation:transition  forKey:kCATransition];
//
//[sourceViewController.navigationController pushViewController:destinationController animated:NO];


@end
