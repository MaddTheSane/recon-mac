//
//  NSTask+OneLineTasksWithOutput.h
//  OpenFileKiller
//
//  Created by Matt Gallagher on 4/05/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Cocoa/Cocoa.h>
#import <SecurityFoundation/SFAuthorization.h>

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const RMOneLineTasksErrorDomain;
typedef NS_ERROR_ENUM(RMOneLineTasksErrorDomain, RMOneLineTaskErrors) {
   RMOneLineTaskErrorLaunchFailed = -1,
   RMOneLineTaskErrorProcessOutput = -2,
};

@interface NSTask (OneLineTasksWithOutput)

/// @method stringByLaunchingPath:withArguments:error:
///
/// @brief Executes a process and returns the standard output as an NSString
///
/// @param processPath the path to the executable
/// @param arguments arguments to pass to the executable
/// @param error an NSError pointer or nil
///
/// @return Returns the standard out from the process an an \c NSString (if the NSTask
/// completes successfully), \c nil otherwise.
///
/// @discussion Error handling notes:
///
/// If the NSTask throws an exception, it will be automatically caught and
/// the "error" object will have the code kNSTaskLaunchFailed and the
/// localizedDescription will be the -[NSException reason] from the thrown
/// exception. The return value will be nil in this case.
///
/// If the NSTask is successfully run but outputs on standard error, the
/// \c localizedDescription of the \c NSError will be set to the string output to
/// standard error (the output on standard out will still be returned as a
/// string). The error code will be \c RMOneLineTaskErrorProcessOutput in this case.
+ (nullable NSString *)stringByLaunchingPath:(NSString *)processPath
	withArguments:(NSArray<NSString*> *)arguments
	error:(NSError **)error
   withObserver:(NSObject *)observer;

/// @method stringByLaunchingPath:withArguments:error:
///
/// @brief Executes a process with specified authorization and returns the standard
/// output as an NSString.
///
/// @param processPath the path to the executable
/// @param arguments arguments to pass to the executable
/// @param authorization an \c SFAuthorization object specifying the privileges
/// @param error an \c NSError pointer or \c nil
///
/// @return Returns the standard out from the process an an \c NSString (if the
/// \c AuthorizationExecuteWithPrivileges completes successfully), \c nil otherwise.
///
/// @discussion Error handling notes:
///
/// If any error is returned from AuthorizationExecuteWithPrivileges, the error
/// object will have its code set to the \c OSErr that it returns and \c nil will be
/// returned from the method.
+ (nullable NSString *)stringByLaunchingPath:(NSString *)processPath
	withArguments:(NSArray<NSString*> *)arguments
	authorization:(SFAuthorization *)authorization
	error:(NSError **)error;

@end

static const RMOneLineTaskErrors kNSTaskLaunchFailed API_DEPRECATED_WITH_REPLACEMENT("RMOneLineTaskErrorLaunchFailed", macos(10.0, 10.7)) = RMOneLineTaskErrorLaunchFailed;
static const RMOneLineTaskErrors kNSTaskProcessOutputError API_DEPRECATED_WITH_REPLACEMENT("RMOneLineTaskErrorProcessOutput", macos(10.0, 10.7)) = RMOneLineTaskErrorProcessOutput;

NS_ASSUME_NONNULL_END
