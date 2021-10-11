#import <Foundation/Foundation.h>

@interface BaseObject : NSObject

/**
 *  Abstract method that should be overriden in sub classes
 *
 *  @param json JSON to populate the object from
 *
 *  @return The object that has been initialized
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

/**
 *  Abstract method that should be overriden in sub classes
 *
 *  @return returns the JSON representation of the object
 */
- (NSDictionary *)jsonRepresentation;

/**
 *  Abstract method that should be overriden in sub classes
 *
 *  @return Returns the JSON representation to create the object in a GitLab request
 */
- (NSDictionary *)jsonCreateRepresentation;

- (NSString *)jsonString;

/**
 *  Method to check if a value is null
 *
 *  @param value The value to be checked
 *
 *  @return Returns nil if value is null otherwise the value
 */
- (id)checkForNull:(id)value;

- (id)jsonToObject:(NSString *)json;

@end
