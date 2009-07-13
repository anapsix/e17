# Copyright (C) 2009 by ProFUSION embedded systems
#
# This file is part of Python-Ethumb.
#
# Python-Ethumb is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-Ethumb is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-Ethumb.  If not, see <http://www.gnu.org/licenses/>.

cdef extern from "Eina.h":
    ctypedef int Eina_Bool

cdef extern from "Ethumb_Client.h":
    ctypedef struct Ethumb_Client
    ctypedef void (*connect_callback_t)(Ethumb_Client *client, Eina_Bool success, void *data)
    ctypedef void (*generated_callback_t)(int id, char *file, char *key, char *thumb_path, char *thumb_key, Eina_Bool success, void *data)

    int ethumb_client_init()
    ethumb_client_shutdown()

    Ethumb_Client *ethumb_client_connect(connect_callback_t cb, void *data, void (*free_data)(void *))
    void ethumb_client_disconnect(Ethumb_Client *client)

    void ethumb_client_fdo_set(Ethumb_Client *client, int s)

    void ethumb_client_size_set(Ethumb_Client *client, int tw, int th)
    void ethumb_client_size_get(Ethumb_Client *client, int *tw, int *th)
    void ethumb_client_format_set(Ethumb_Client *client, int f)
    int ethumb_client_format_get(Ethumb_Client *client)
    void ethumb_client_aspect_set(Ethumb_Client *client, int a)
    int ethumb_client_aspect_get(Ethumb_Client *client)
    void ethumb_client_crop_align_set(Ethumb_Client *client, float x, float y)
    void ethumb_client_crop_align_get(Ethumb_Client *client, float *x, float *y)
    void ethumb_client_quality_set(Ethumb_Client *client, int quality)
    int ethumb_client_quality_get(Ethumb_Client *client)
    void ethumb_client_compress_set(Ethumb_Client *client, int compress)
    int ethumb_client_compress_get(Ethumb_Client *client)
    Eina_Bool ethumb_client_frame_set(Ethumb_Client *client, char *file, char *group, char *swallow)
    void ethumb_client_dir_path_set(Ethumb_Client *client, char *path)
    char * ethumb_client_dir_path_get(Ethumb_Client *client)
    void ethumb_client_category_set(Ethumb_Client *client, char *category)
    char * ethumb_client_category_get(Ethumb_Client *client)
    void ethumb_client_video_time_set(Ethumb_Client *client, float time)
    void ethumb_client_video_start_set(Ethumb_Client *client, float start)
    void ethumb_client_video_interval_set(Ethumb_Client *client, float interval)
    void ethumb_client_video_ntimes_set(Ethumb_Client *client, int ntimes)
    void ethumb_client_video_fps_set(Ethumb_Client *client, int fps)
    void ethumb_client_document_page_set(Ethumb_Client *client, int page)

    Eina_Bool ethumb_client_file_set(Ethumb_Client *client, char *path, char *key)
    void ethumb_client_file_get(Ethumb_Client *client, char **path, char **key)
    void ethumb_client_file_free(Ethumb_Client *client)

    void ethumb_client_thumb_path_set(Ethumb_Client *client, char *path, char *key)
    void ethumb_client_thumb_path_get(Ethumb_Client *client, char **path, char **key)
    Eina_Bool ethumb_client_thumb_exists(Ethumb_Client *client)
    int ethumb_client_generate(Ethumb_Client *client, generated_callback_t generated_cb, void *data, void (*free_data)(void *))
    void ethumb_client_queue_remove(Ethumb_Client *client, int id, void (*queue_remove_cb)(Eina_Bool success, void *data), void *data)
    void ethumb_client_queue_clear(Ethumb_Client *client)

cdef class Client:
    cdef Ethumb_Client *obj
