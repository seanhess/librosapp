//
//  BookService.m
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "BookService.h"
#import "Book.h"
#import <RestKit/RestKit.h>
#import "ObjectStore.h"
#import "NSObject+Reflection.h"
#import "FileService.h"

@interface BookService ()
@end



@implementation BookService

+ (BookService *)shared
{
    static BookService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BookService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    RKEntityMapping *bookMapping = [ObjectStore.shared mappingForEntityForName:@"Book"];
    [bookMapping setIdentificationAttributes:@[@"bookId"]];
    
    NSMutableArray * propertyNames = [NSMutableArray arrayWithArray:[Book propertyNames]];
    NSIndexSet * indices = [propertyNames indexesOfObjectsPassingTest:^(NSString * name, NSUInteger idx, BOOL * stop) {
        return [name isEqualToString:@"descriptionText"];
    }];
    [propertyNames removeObjectsAtIndexes:indices];
    
    [bookMapping addAttributeMappingsFromArray:propertyNames];
    [bookMapping addAttributeMappingsFromDictionary:@{@"description": @"descriptionText"}];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping pathPattern:@"/books/" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
    [ObjectStore.shared syncWithFetchRequest:self.allBooks forPath:@"/books/"];
}

// So you can compose with compoundPredicates. Wahoo.
// Or just let the dumb view controllers do whatever they want. it's not THAT bad
// not that great either

// You can execute fetch requests right on the context
// OR you can make a fetched results controller and give it a fetch request

-(void)loadStore {
    [self loadStoreWithCb:nil];
}

-(void)loadStoreWithCb:(void(^)(void))cb {
    [[ObjectStore shared].objectManager getObjectsAtPath:@"/books/" parameters:nil success:^(RKObjectRequestOperation * operation, RKMappingResult *mappingResult) {
        if (cb) cb();
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

-(void)sendBookPurchased:(Book*)book {
    NSString * path = [NSString stringWithFormat:@"/books/%@/popularity", book.bookId];
    [[ObjectStore shared].objectManager postObject:nil path:path parameters:nil success:^(RKObjectRequestOperation * op, RKMappingResult *mp) {
    } failure:^(RKObjectRequestOperation * op, NSError * err) {
    }];
}

// has the sort descriptor built in
-(NSFetchRequest*)allBooks {
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    NSSortDescriptor *titleSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSSortDescriptor *popularitySort = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
    NSSortDescriptor *featuredSort = [NSSortDescriptor sortDescriptorWithKey:@"featured" ascending:NO];
    fetchRequest.sortDescriptors = @[featuredSort,popularitySort,titleSort];
    return fetchRequest;
}

-(NSFetchRequest*)popular {
    NSFetchRequest * fetchRequest = [self allBooks];
    return fetchRequest;
}

-(NSFetchRequest*)purchased {
    NSFetchRequest * fetchRequest = [self allBooks];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"purchased = YES"];
    return fetchRequest;
}

-(NSPredicate*)searchForText:(NSString*)text {
    // I initially only used BEGINSWITH for speed, but it might not be slow and people REALLY miss
    // being able to fuzzy search titles
    
    // return [NSPredicate predicateWithFormat:@"title BEGINSWITH[c] %@", [text lowercaseString]];
    return [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", [text lowercaseString]];
}

-(NSPredicate*)filterByType:(BookFilter)filter {
    if (filter == BookFilterHasAudio) return [NSPredicate predicateWithFormat:@"audioFiles > 0"];
    else if (filter == BookFilterHasText) return [NSPredicate predicateWithFormat:@"textFiles > 0"];
    else return [NSPredicate predicateWithFormat:@"audioFiles > 0 OR textFiles > 0"];
}



//-(NSString *)priceString:(Book *)book {
//    NSInteger dollars = floorf(book.priceValue / 100);
//    NSInteger pennies = book.priceValue % 100;
//    return [NSString stringWithFormat:@"%i.%02i", dollars, pennies];
//}

-(NSArray*)firstRunBooks {
    NSString * draculaId = @"b6145fe2-f386-483e-8aeb-84d84de4f65e";
    NSString * principeMendigoId = @"6b8e637a-2f19-4224-b68f-cba3fe03c79e";
    NSString * condenadaId = @"5af9d5a2-8515-4a22-80e6-a1404aedce78";
    NSArray * ids = @[draculaId, principeMendigoId, condenadaId];
    return [self booksWithIds:ids];
}

-(NSArray*)booksWithIds:(NSArray*)ids {
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"bookId IN %@", ids];
    NSArray * books = [ObjectStore.shared.context executeFetchRequest:fetchRequest error:nil];
    return books;
}



-(NSString*)productId:(Book*)book {
    return [book.bookId stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

-(NSString*)bookIdFromProductId:(NSString *)productId {
    return [productId stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
}

-(BOOL)isDownloading:(Book*)book {
    return (0.0 < book.downloaded) && (book.downloaded < 1.0);
}

-(BOOL)isDownloadComplete:(Book*)book {
    return (book.downloaded == 1.0);
}

@end
