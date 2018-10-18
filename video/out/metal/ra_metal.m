#include "ra_metal.h"

#include "video/out/gpu/utils.h"

/*struct ra_layout metal_uniform_layout(struct ra_renderpass_input *inp) {

}

struct ra_layout metal_push_constant_layout(struct ra_renderpass_input *inp) {

}*/

static struct ra_fns ra_fns_metal;

struct ra *ra_create_metal(struct mp_log *log) {
    struct ra *ra = talloc_zero(NULL, struct ra);
    ra->log = log;
    ra->fns = &ra_fns_metal;
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
