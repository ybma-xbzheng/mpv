#import <Foundation/Foundation.h>
#include "mpv_talloc.h"

#include "normalize.h"

const char *mp_normalize_input_string(void *talloc_ctx, char *string)
{
    char *string_decomposed = string;
    NSString *string_tmp = [[NSString alloc] initWithUTF8String:string];

    if(string_tmp) {
        string_decomposed = talloc_strdup(talloc_ctx,
            [[string_tmp decomposedStringWithCanonicalMapping] UTF8String]);
    }

    [string_tmp release];
    return string_decomposed;
}
