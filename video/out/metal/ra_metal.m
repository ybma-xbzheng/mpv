#include "ra_metal.h"

#include "video/out/gpu/utils.h"

/*struct ra_layout metal_uniform_layout(struct ra_renderpass_input *inp) {

}

struct ra_layout metal_push_constant_layout(struct ra_renderpass_input *inp) {

}*/

static struct ra_fns ra_fns_metal;

struct ra_metal {
    id <MTLDevice> device;
};

struct metal_fmt {
    const char *name;
    MTLPixelFormat fmt;
    int components;
    int bytes;
    int bits[4];
    enum ra_ctype ctype;
    bool unordered;
};

// https://developer.apple.com/metal/Metal-Feature-Set-Tables.pdf
static struct metal_fmt formats[] = {
    // Regular, byte-aligned integer formats
    { "r8",        MTLPixelFormatR8Unorm,      1,  1, { 8            }, RA_CTYPE_UNORM },
    { "rg8",       MTLPixelFormatRG8Unorm,     2,  2, { 8,  8        }, RA_CTYPE_UNORM },
    { "rgba8",     MTLPixelFormatRGBA8Unorm,   4,  4, { 8,  8,  8,  8}, RA_CTYPE_UNORM },
    { "r16",       MTLPixelFormatR16Unorm,     1,  2, {16            }, RA_CTYPE_UNORM },
    { "rg16",      MTLPixelFormatRG16Unorm,    2,  4, {16, 16        }, RA_CTYPE_UNORM },
    { "rgba16",    MTLPixelFormatRGBA16Unorm,  4,  8, {16, 16, 16, 16}, RA_CTYPE_UNORM },
    { "rgb10a2",   MTLPixelFormatRGB10A2Unorm, 4,  4, {10, 10, 10,  2}, RA_CTYPE_UNORM },

    // Special, integer-only formats
    { "r8ui",      MTLPixelFormatR8Uint,       1,  1, { 8            }, RA_CTYPE_UINT },
    { "rg8ui",     MTLPixelFormatRG8Uint,      2,  2, { 8,  8        }, RA_CTYPE_UINT },
    { "rgba8ui",   MTLPixelFormatRGBA8Uint,    4,  4, { 8,  8,  8,  8}, RA_CTYPE_UINT },
    { "r16ui",     MTLPixelFormatR16Uint,      1,  2, {16            }, RA_CTYPE_UINT },
    { "rg16ui",    MTLPixelFormatRG16Uint,     2,  4, {16, 16        }, RA_CTYPE_UINT },
    { "rgba16ui",  MTLPixelFormatRGBA16Uint,   4,  8, {16, 16, 16, 16}, RA_CTYPE_UINT },
    { "r32ui",     MTLPixelFormatR32Uint,      1,  4, {32            }, RA_CTYPE_UINT },
    { "rg32ui",    MTLPixelFormatRG32Uint,     2,  8, {32, 32        }, RA_CTYPE_UINT },
    { "rgba32ui",  MTLPixelFormatRGBA32Uint,   4, 16, {32, 32, 32, 32}, RA_CTYPE_UINT },
    { "rgb10a2ui", MTLPixelFormatRGB10A2Uint,  4,  4, {10, 10, 10,  2}, RA_CTYPE_UINT  },

    // Float formats (native formats, hf = half float, df = double float)
    { "r16f",      MTLPixelFormatR16Float,     1,  2, {16            }, RA_CTYPE_FLOAT }, // or hf?
    { "rg16f",     MTLPixelFormatRG16Float,    2,  4, {16, 16        }, RA_CTYPE_FLOAT }, // or hf?
    { "rgba16f",   MTLPixelFormatRGBA16Float,  4,  8, {16, 16, 16, 16}, RA_CTYPE_FLOAT }, // or hf?
    { "r32f",      MTLPixelFormatR32Float,     1,  4, {32            }, RA_CTYPE_FLOAT },
    { "rg32f",     MTLPixelFormatRG32Float,    2,  8, {32, 32        }, RA_CTYPE_FLOAT },
    { "rgba32f",   MTLPixelFormatRGBA32Float,  4, 16, {32, 32, 32, 32}, RA_CTYPE_FLOAT },
    { "rg11b10f",  MTLPixelFormatRG11B10Float, 3,  4, {11, 11, 10    }, RA_CTYPE_FLOAT },

    // "Swapped" component order images
    { "bgra8",     MTLPixelFormatBGRA8Unorm,   4,  4, { 8,  8,  8,  8}, RA_CTYPE_UNORM, true },
    // only available on mac 10.13, macOS_GPUFamily1_v3
    //{ "bgr10a2",   MTLPixelFormatBGR10A2Unorm, 4,  4, {10, 10, 10,  2}, RA_CTYPE_UNORM, true },
};
struct ra *ra_create_metal(id <MTLDevice> device, struct mp_log *log) {
    struct ra *ra = talloc_zero(NULL, struct ra);
    ra->log = log;
    ra->fns = &ra_fns_metal;

    struct ra_metal *p = ra->priv = talloc_zero(ra, struct ra_metal);
    p->device = device;

    for (int i = 0; i < MP_ARRAY_SIZE(formats); i++) {
        struct metal_fmt *metalfmt = &formats[i];

        // all pixel formats can be used for reading and sampling
        struct ra_format *fmt = talloc_zero(ra, struct ra_format);
        *fmt = (struct ra_format) {
            .name           = metalfmt->name,
            .priv           = metalfmt,
            .ctype          = metalfmt->ctype,
            .ordered        = !metalfmt->unordered,
            .num_components = metalfmt->components,
            .pixel_size     = metalfmt->bytes,
            .linear_filter  = true, // only available on macOS 10.13?
            .renderable     = true,
        };

        for (int j = 0; j < metalfmt->components; j++)
            fmt->component_size[j] = fmt->component_depth[j] = metalfmt->bits[j];

        fmt->glsl_format = ra_fmt_glsl_format(fmt);

        MP_TARRAY_APPEND(ra, ra->formats, ra->num_formats, fmt);
    }

    return ra;
}

static void metal_destroy(struct ra *ra) {

}

static struct ra_tex *metal_tex_create(struct ra *ra, const struct ra_tex_params *params) {

}

static void metal_tex_destroy(struct ra *ra, struct ra_tex *tex) {

}

static bool metal_tex_upload(struct ra *ra, const struct ra_tex_upload_params *params) {

}

static bool metal_tex_download(struct ra *ra, struct ra_tex_download_params *params) {

}

static struct ra_buf *metal_buf_create(struct ra *ra, const struct ra_buf_params *params) {

}

static void metal_buf_destroy(struct ra *ra, struct ra_buf *buf) {

}

static void metal_buf_update(struct ra *ra, struct ra_buf *buf, ptrdiff_t offset, const void *data, size_t size) {

}

static bool metal_buf_poll(struct ra *ra, struct ra_buf *buf) {

}

static void metal_clear(struct ra *ra, struct ra_tex *dst, float color[4], struct mp_rect *scissor) {

}

static void metal_blit(struct ra *ra, struct ra_tex *dst, struct ra_tex *src, struct mp_rect *dst_rc, struct mp_rect *src_rc) {

}

static int metal_desc_namespace(enum ra_vartype type) {

}

static struct ra_renderpass *metal_renderpass_create(struct ra *ra, const struct ra_renderpass_params *params) {

}

static void metal_renderpass_destroy(struct ra *ra, struct ra_renderpass *pass) {

}

static void metal_renderpass_run(struct ra *ra, const struct ra_renderpass_run_params *params) {

}

static ra_timer *metal_timer_create(struct ra *ra) {

}

static void metal_timer_destroy(struct ra *ra, ra_timer *timer) {

}

static void metal_timer_start(struct ra *ra, ra_timer *timer) {

}

static uint64_t metal_timer_stop(struct ra *ra, ra_timer *timer) {

}

static void metal_debug_marker(struct ra *ra, const char *msg) {

}

static struct ra_fns ra_fns_metal = {
    .destroy                = metal_destroy,
    .tex_create             = metal_tex_create,
    .tex_destroy            = metal_tex_destroy,
    .tex_upload             = metal_tex_upload,
    .tex_download           = metal_tex_download,
    .buf_create             = metal_buf_create,
    .buf_destroy            = metal_buf_destroy,
    .buf_update             = metal_buf_update,
    .buf_poll               = metal_buf_poll,
    .clear                  = metal_clear,
    .blit                   = metal_blit,
    .uniform_layout         = std140_layout,
    .desc_namespace         = metal_desc_namespace,
    .renderpass_create      = metal_renderpass_create,
    .renderpass_destroy     = metal_renderpass_destroy,
    .renderpass_run         = metal_renderpass_run,
    .timer_create           = metal_timer_create,
    .timer_destroy          = metal_timer_destroy,
    .timer_start            = metal_timer_start,
    .timer_stop             = metal_timer_stop,
    .debug_marker           = metal_debug_marker,
};
