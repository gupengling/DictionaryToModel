//
//  NSObject+GPLDicToModel.m
//  OCDicToModel
//
//  Created by GPL on 2017/11/7.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import "NSObject+GPLDicToModel.h"
#import <objc/runtime.h>
#include <objc/objc.h>

NSString *const GPLClassType_object  =   @"object";
NSString *const GPLClassType_basic   =   @"basic";
NSString *const GPLClassType_other   =   @"other";


@implementation NSObject (GPLDicToModel)

+ (instancetype)gpl_initWithArray:(NSArray *)arr {
    NSMutableArray *arrModels = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [arrModels addObject:[self gpl_initWithArray:obj]];
        }
        else {
            id model = [self gpl_initWithDictionary:obj];
            [arrModels addObject:model];
        }
    }];
    
    return arrModels;
}

+ (instancetype)gpl_initWithDictionary:(NSDictionary *)dic {
    id obj = [[self alloc] init];
    
    unsigned int outCount;
    //获取类中的所有成员属性
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    NSMutableArray *arrNewProperty = [self allProperty:arrPropertys count:outCount];
    
    [self setDicObject:dic arrNewPropertys:arrNewProperty obj:obj];
    
    free(arrPropertys);    
    return obj;
}

- (void)setDicObject:(NSDictionary *)dic arrNewPropertys:(NSMutableArray *)arrNewProperty obj:(id)obj {
    for (NSDictionary *dicPropertyType in arrNewProperty) {
        
        NSString *propertyName = dicPropertyType[@"propertyName"];
        NSString *newPropertyName = dicPropertyType[@"propertyNewName"];
        id propertyValue = dic[newPropertyName];
        if (propertyValue == nil) {
            continue;
        }
        NSString *propertyClassType = [dicPropertyType objectForKey:@"classType"];
        NSString *propertyType = [dicPropertyType objectForKey:@"type"];
        if ([propertyType isEqualToString:GPLClassType_object]) {
            if ([propertyClassType isEqualToString:@"NSArray"] || [propertyClassType isEqualToString:@"NSMutableArray"]) {
                //数组类型
                if ([self.class respondsToSelector:@selector(gpl_objectClassKeyInArray)]) {
                    id propertyValueType = [[self.class gpl_objectClassKeyInArray] objectForKey:propertyName];
                    if ([propertyValueType isKindOfClass:[NSString class]]) {
                        propertyValue = [NSClassFromString(propertyValueType) gpl_initWithArray:propertyValue];
                    }
                    else {
                        if (propertyValueType != nil) {//如果是自定义数组
                            propertyValue = [propertyValueType gpl_initWithArray:propertyValue];
                        }
                    }
                    
                    if (propertyValue != nil) {
                        [obj setValue:propertyValue forKey:propertyName];
                    }
                }
                
            }
            else if ([propertyClassType isEqualToString:@"NSDictionary"] || [propertyClassType isEqualToString:@"NSMutableDictionary"]) {
                //字典类型  一般不会用字典，用自定义model
                
            }
            else if ([propertyClassType isEqualToString:@"NSString"]) {
                //字符串类型
                if (propertyValue != nil) {
                    [obj setValue:propertyValue forKey:propertyName];
                }
            }
            else {
                //自定义类型
                propertyValue = [NSClassFromString(propertyClassType) gpl_initWithDictionary:propertyValue];
                if (propertyValue != nil) {
                    [obj setValue:propertyValue forKey:propertyName];
                }
            }
        }
        else if ([propertyType isEqualToString:GPLClassType_basic]) {
            if ([propertyValue isKindOfClass:[NSString class]]) {
                propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:propertyValue];
            }
            else {
                
            }
            
            if (propertyValue != nil) {
                [obj setValue:propertyValue forKey:propertyName];
            }
        }
        else {
            
        }
    }
}
- (NSMutableArray *)allProperty:(objc_property_t *)arrPropertys count:(unsigned int)outCount {
    NSMutableArray *arrResetProperty = [NSMutableArray array];
    for (NSInteger i = 0; i < outCount; i ++) {
        objc_property_t property = arrPropertys[i];
        //获取属性名字符串 model中的属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        //字典中的属性名
        NSString *newPropertyName;
        if ([self.class respondsToSelector:@selector(gpl_propertyReplacedKeyWithValue)]) {
            newPropertyName = [[self.class gpl_propertyReplacedKeyWithValue] objectForKey:propertyName];
        }
        if (!newPropertyName) {
            newPropertyName = propertyName;
        }

        NSLog(@"属性名:%@", propertyName);
        
        //获取属性是什么类型的
        NSMutableDictionary *dicPropertyType = [self propertyTypeFromProperty:property];
        [dicPropertyType setObject:newPropertyName forKey:@"propertyNewName"];
        [dicPropertyType setObject:propertyName forKey:@"propertyName"];
        [arrResetProperty addObject:dicPropertyType];

    }
    return arrResetProperty;
}
- (NSMutableDictionary *)propertyTypeFromProperty:(objc_property_t)property
{
    //获取属性的类型, 类似 T@"NSString",C,N,V_name    T@"UserModel",&,N,V_user
    NSString *propertyAttrs = @(property_getAttributes(property));
    
    NSMutableDictionary *dicPropertyType = [NSMutableDictionary dictionary];
    
    NSRange commaRange = [propertyAttrs rangeOfString:@","];
    NSString *propertyType = [propertyAttrs substringWithRange:NSMakeRange(1, commaRange.location - 1)];
//    NSLog(@"属性类型:%@, %@", propertyAttrs, propertyType);
    
    if ([propertyType hasPrefix:@"@"] && propertyType.length > 2) {
        //对象类型
        NSString *propertyClassType = [propertyType substringWithRange:NSMakeRange(2, propertyType.length - 3)];
        [dicPropertyType setObject:propertyClassType forKey:@"classType"];
        [dicPropertyType setObject:GPLClassType_object forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"q"]) {
        [dicPropertyType setObject:@"NSInteger" forKey:@"classType"];
        [dicPropertyType setObject:GPLClassType_basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"d"]) {
        [dicPropertyType setObject:@"CGFloat" forKey:@"classType"];
        [dicPropertyType setObject:GPLClassType_basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"B"]) {
        [dicPropertyType setObject:@"BOOL" forKey:@"classType"];
        [dicPropertyType setObject:GPLClassType_basic forKey:@"type"];
    }
    else {
        [dicPropertyType setObject:GPLClassType_other forKey:@"type"];
    }
    return dicPropertyType;
}

@end
