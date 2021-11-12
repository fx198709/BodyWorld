#import "BaseObject.h"

@implementation BaseObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p\n%@\n>", NSStringFromClass([self class]), self, [self jsonRepresentation]];
}

- (NSDictionary *)jsonRepresentation
{
    return nil;
}

- (NSDictionary *)jsonCreateRepresentation
{
    return nil;
}

- (NSString *)jsonString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self jsonRepresentation]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        NSLog(@"Error creating JSON string: %@", error);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (id)checkForNull:(id)value
{
    return value == [NSNull null] ? nil : value;
}

- (id)jsonToObject:(NSString *)json
{
    //string转data
    if(json == nil){
        return nil;
    }
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    //json解析
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return obj;
}

@end



