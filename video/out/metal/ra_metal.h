#pragma once

//#include <stdio.h>
//#include <stdint.h>
#include <stdbool.h>

#include "video/out/gpu/ra.h"

struct ra *ra_create_metal(struct mp_log *log);
