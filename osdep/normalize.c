#include "mpv_talloc.h"

#include "normalize.h"

const char *mp_normalize_input_string(void *talloc_ctx, char *string)
{
    return talloc_strdup(talloc_ctx, string);
}
