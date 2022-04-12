/*
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#include "bsf.h"
#include "bsf_internal.h"
#include "cbs.h"
#include "cbs_bsf.h"
#include "cbs_h264.h"
#include "codec_id.h"

typedef struct H264ConstraintContext {
    CBSBSFContext common;

    int gaps_in_frame_num_value_allowed_flag;

    int max_num_reorder_frames;
    int max_dec_frame_buffering;
} H264ConstraintContext;


static int h264_constraint_update_sps(AVBSFContext *bsf,
                                      H264RawSPS *sps)
{
    H264ConstraintContext *ctx = bsf->priv_data;
    int add_restriction_flag = 0;

    if (ctx->gaps_in_frame_num_value_allowed_flag >= 0) {
        sps->gaps_in_frame_num_value_allowed_flag =
            ctx->gaps_in_frame_num_value_allowed_flag;
    }

    if (ctx->max_num_reorder_frames >= 0) {
        sps->vui.max_num_reorder_frames = ctx->max_num_reorder_frames;
        add_restriction_flag = 1;
    }

    if (ctx->max_dec_frame_buffering >= 0) {
        sps->vui.max_dec_frame_buffering = ctx->max_dec_frame_buffering;
        add_restriction_flag = 1;
    }

    if (add_restriction_flag) {
        sps->vui_parameters_present_flag = 1;
        sps->vui.bitstream_restriction_flag = 1;
    }

    return 0;
}

static int h264_constraint_update_fragment(AVBSFContext *bsf,
                                           AVPacket *pkt,
                                           CodedBitstreamFragment *au)
{
    for (int i = 0; i < au->nb_units; i++) {
        CodedBitstreamUnit *nal = &au->units[i];

        if (nal->type == H264_NAL_SPS)
            h264_constraint_update_sps(bsf, nal->content);
    }

    return 0;
}

static const CBSBSFType h264_constraint_type = {
    .codec_id        = AV_CODEC_ID_H264,
    .fragment_name   = "access unit",
    .unit_name       = "NAL unit",
    .update_fragment = &h264_constraint_update_fragment,
};

static int h264_constraint_init(AVBSFContext *bsf)
{
    return ff_cbs_bsf_generic_init(bsf, &h264_constraint_type);
}

#define OFFSET(x) offsetof(H264ConstraintContext, x)
#define FLAGS (AV_OPT_FLAG_VIDEO_PARAM|AV_OPT_FLAG_BSF_PARAM)
static const AVOption h264_constraint_options[] = {
    { "gaps_in_frame_num_value_allowed_flag",
        "Set gaps_in_frame_num_value_allowed_flag.",
        OFFSET(gaps_in_frame_num_value_allowed_flag),
        AV_OPT_TYPE_INT, { .i64 = -1 }, -1, 1, FLAGS },

    { "max_num_reorder_frames",
        "Set max_num_reorder_frames.",
        OFFSET(max_num_reorder_frames),
        AV_OPT_TYPE_INT, { .i64 = -1 }, -1, H264_MAX_DPB_FRAMES, FLAGS },

    { "max_dec_frame_buffering",
        "Set max_dec_frame_buffering.",
        OFFSET(max_dec_frame_buffering),
        AV_OPT_TYPE_INT, { .i64 = -1 }, -1, H264_MAX_DPB_FRAMES, FLAGS },

    { NULL }
};

static const AVClass h264_constraint_class = {
    .class_name = "h264_constraint_bsf",
    .item_name  = av_default_item_name,
    .option     = h264_constraint_options,
    .version    = LIBAVUTIL_VERSION_INT,
};

static const enum AVCodecID h264_constraint_codec_ids[] = {
    AV_CODEC_ID_H264, AV_CODEC_ID_NONE,
};

const AVBitStreamFilter ff_h264_constraint_bsf = {
    .name           = "h264_constraint",
    .priv_data_size = sizeof(H264ConstraintContext),
    .priv_class     = &h264_constraint_class,
    .init           = &h264_constraint_init,
    .close          = &ff_cbs_bsf_generic_close,
    .filter         = &ff_cbs_bsf_generic_filter,
    .codec_ids      = h264_constraint_codec_ids,
};
