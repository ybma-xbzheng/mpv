/*
 * This file is part of mpv.
 *
 * mpv is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * mpv is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with mpv.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "video/out/gpu/context.h"
//#include "video/out/gpu/spirv.h"
#include "video/out/metal_swift.h"
#include "ra_metal.h"

struct priv {
    id <MTLDevice> device;
};


static bool metal_reconfig(struct ra_ctx *ctx)
{
    return true;
}

static int metal_control(struct ra_ctx *ctx, int *events, int request, void *arg)
{
    return true;
}

static int metal_color_depth(struct ra_swapchain *sw)
{
    return 8;
}

static bool metal_start_frame(struct ra_swapchain *sw, struct ra_fbo *out_fbo)
{
    return false;
}

static bool metal_submit_frame(struct ra_swapchain *sw,
                               const struct vo_frame *frame)
{
    return true;
}

static void metal_swap_buffers(struct ra_swapchain *sw)
{

}

static const struct ra_swapchain_fns metal_swapchain = {
    .color_depth  = metal_color_depth,
    .start_frame  = metal_start_frame,
    .submit_frame = metal_submit_frame,
    .swap_buffers = metal_swap_buffers,
};

static bool metal_init(struct ra_ctx *ctx)
{
    struct priv *p = ctx->priv = talloc_zero(ctx, struct priv);
    //p->opts = mp_get_config_group(ctx, ctx->global, &d3d11_conf);

    p->device = MTLCreateSystemDefaultDevice();

    struct ra_swapchain *sw = ctx->swapchain = talloc_zero(ctx, struct ra_swapchain);
    sw->priv = p;
    sw->ctx = ctx;
    sw->fns = &metal_swapchain;

    ctx->ra = ra_create_metal(p->device, ctx->log);


    return true;
}

static void metal_uninit(struct ra_ctx *ctx)
{

}


const struct ra_ctx_fns ra_ctx_metal = {
    .type     = "metal",
    .name     = "metal",
    .reconfig = metal_reconfig,
    .control  = metal_control,
    .init     = metal_init,
    .uninit   = metal_uninit,
};
