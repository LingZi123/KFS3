//
//  MoodAndHealthModel.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/21.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MoodAndHealthModel.h"

@implementation MoodAndHealthModel


#pragma mark-nscoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_mydate forKey:@"mydate"];
    [aCoder encodeObject:_healthStarIndex forKey:@"healthStarIndex"];
    [aCoder encodeObject:_moodStarIndex forKey:@"moodStarIndex"];
    [aCoder encodeBool:_isPost forKey:@"isPost"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        _username=[aDecoder decodeObjectForKey:@"username"];
        _mydate=[aDecoder decodeObjectForKey:@"mydate"];
        _moodStarIndex=[aDecoder decodeObjectForKey:@"moodStarIndex"];
        _healthStarIndex=[aDecoder decodeObjectForKey:@"healthStarIndex"];
        _isPost=[aDecoder decodeBoolForKey:@"isPost"];
        
    }
    return self;
}
@end
