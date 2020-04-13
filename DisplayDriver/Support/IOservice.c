//
//  IOservice.c
//  DisplayDriver
//
//  Source is a commit by Camilla Berglund <elmindreda@glfw.org> at glfw project.
//  See: https://git.mac94.de/marcel/glfw/commit/94b8486d4b33e1aadb5ac1ae23719dc5786a1784
//  Need a proper credit later

#include "IOservice.h"

io_service_t IOServicePortFromCGDisplayID(CGDirectDisplayID displayID)
{
    io_iterator_t iter;
    io_service_t serv, servicePort = 0;

    CFMutableDictionaryRef matching = IOServiceMatching("IODisplayConnect");

    // releases matching for us
    kern_return_t err = IOServiceGetMatchingServices(kIOMasterPortDefault,
                             matching,
                             &iter);
    if (err)
    {
        return 0;
    }

    while ((serv = IOIteratorNext(iter)) != 0)
    {
        CFDictionaryRef info;
        CFIndex vendorID, productID;
        CFNumberRef vendorIDRef, productIDRef;
        Boolean success;

        info = IODisplayCreateInfoDictionary(serv,
                             kIODisplayOnlyPreferredName);

        vendorIDRef = CFDictionaryGetValue(info,
                           CFSTR(kDisplayVendorID));
        productIDRef = CFDictionaryGetValue(info,
                            CFSTR(kDisplayProductID));

        success = CFNumberGetValue(vendorIDRef, kCFNumberCFIndexType,
                                   &vendorID);
        success &= CFNumberGetValue(productIDRef, kCFNumberCFIndexType,
                                    &productID);

        if (!success)
        {
            CFRelease(info);
            continue;
        }

        if (CGDisplayVendorNumber(displayID) != vendorID ||
            CGDisplayModelNumber(displayID) != productID)
        {
            CFRelease(info);
            continue;
        }

        // we're a match
        servicePort = serv;
        CFRelease(info);
        break;
    }

    IOObjectRelease(iter);
    return servicePort;
}
