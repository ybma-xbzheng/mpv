#pragma once

//#include <stdio.h>
//#include <stdint.h>
#include <stdbool.h>

#import <Metal/Metal.h>

#include "video/out/gpu/ra.h"

struct ra *ra_create_metal(id <MTLDevice> device, struct mp_log *log);
