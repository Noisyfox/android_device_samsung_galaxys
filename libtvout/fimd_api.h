/*
 * Copyright@ Samsung Electronics Co. LTD
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __FIMD_API_H__
#define __FIMD_API_H__

#include <linux/fb.h>

#ifdef __cplusplus
extern "C" {
#endif

#define TOTAL_FB_NUM		5

/* TVOUT video */
#define PFX_NODE_FB         "/dev/graphics/fb"

/* FB */
struct s5ptvfb_user_window {
    int x;
    int y;
};

#define S5PTVFB_WIN_POSITION _IOW('F', 213, struct s5ptvfb_user_window)

int fb_open(int win);
int fb_close(int fp);
int fb_on(int fp);
int fb_off(int fp);
int fb_off_all(void);
char *fb_init_display(int fp, int width, int height,\
			int left_x, int top_y, int bpp);
int fb_ioctl(int fp, __u32 cmd, void *arg);
char *fb_mmap(__u32 size, int fp);
int simple_draw(char *dest, const char *src,\
		int img_width, struct fb_var_screeninfo *var);
int draw(char *dest, const char *src,\
	int img_width, struct fb_var_screeninfo *var);
int get_fscreeninfo(int fp, struct fb_fix_screeninfo *fix);
int get_vscreeninfo(int fp, struct fb_var_screeninfo *var);
int put_vscreeninfo(int fp, struct fb_var_screeninfo *var);
int get_bytes_per_pixel(int bits_per_pixel);

#ifdef __cplusplus
}
#endif

#endif /* __FIMD_API_H__ */
