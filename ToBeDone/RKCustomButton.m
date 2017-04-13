//
//  RKCustomButton.m
//  RKTagsView
//
//  Created by Kulesha Raman on 02.03.16.
//  Copyright © 2016 Roman Kulesha. All rights reserved.
//

#import "RKCustomButton.h"

@implementation RKCustomButton

- (void)runBubbleAnimation {
  self.transform = CGAffineTransformMakeScale(0.5, 0.5);
  [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    self.transform = CGAffineTransformIdentity;
  } completion:nil];
}

- (void)setSelected:(BOOL)selected {
  if (self.selected != selected) {
    [self runBubbleAnimation];
  }
  [super setSelected:selected];
}

@end
