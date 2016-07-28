//
//  User+CoreDataProperties.h
//  RunRecipe
//
//  Created by QinShawn on 7/27/16.
//  Copyright © 2016 Team1. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *userid;
@property (nullable, nonatomic, retain) NSSet<Run *> *runs;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRunsObject:(Run *)value;
- (void)removeRunsObject:(Run *)value;
- (void)addRuns:(NSSet<Run *> *)values;
- (void)removeRuns:(NSSet<Run *> *)values;

@end

NS_ASSUME_NONNULL_END
