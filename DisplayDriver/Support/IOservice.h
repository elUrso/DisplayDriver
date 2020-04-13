//
//  IOservice.h
//  DisplayDriver
//
//  Created by Vitor Silva on 13/04/20.
//  Copyright © 2020 Vitor Silva. All rights reserved.
//

#ifndef IOservice_h
#define IOservice_h

#include <IOKit/IOTypes.h>
#include <ApplicationServices/ApplicationServices.h>

io_service_t IOServicePortFromCGDisplayID(CGDirectDisplayID displayID);

#endif /* IOservice_h */
