/*
**
** Copyright 2008, The Android Open Source Project
** Copyright 2010, Samsung Electronics Co. LTD
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/

#ifndef ANDROID_HARDWARE_CAMERA_HARDWARE_SEC_H
#define ANDROID_HARDWARE_CAMERA_HARDWARE_SEC_H

#include "SecCamera.h"
#include "SecCameraParameters.h"

#include <utils/threads.h>
#include <binder/MemoryBase.h>
#include <binder/MemoryHeapBase.h>

#include <hardware/camera.h>

namespace android {
class CameraHardwareSec {
public:
    CameraHardwareSec(int cameraId);
    ~CameraHardwareSec();

    sp<IMemoryHeap> getPreviewHeap() const;
    sp<IMemoryHeap> getRawHeap() const;

    void        setCallbacks(camera_notify_callback notify_cb,
                             camera_data_callback data_cb,
                             camera_data_timestamp_callback data_cb_timestamp,
                             camera_request_memory get_memory,
                             void *user);

    void        enableMsgType(int32_t msgType);
    void        disableMsgType(int32_t msgType);
    bool        msgTypeEnabled(int32_t msgType);

    status_t    setPreviewWindow(struct preview_stream_ops *window);
    status_t    storeMetaDataInBuffers(bool enable);

    status_t    startPreview();
#if defined(BOARD_USES_OVERLAY)
    bool        useOverlay();
    status_t    setOverlay(const sp<Overlay> &overlay);
#endif
    void        stopPreview();
    bool        previewEnabled();

    status_t    startRecording();
    void        stopRecording();
    bool        recordingEnabled();
    void        releaseRecordingFrame(const sp<IMemory> &mem);

    status_t    autoFocus();
    status_t    cancelAutoFocus();
    status_t    takePicture();
    status_t    cancelPicture();
    /*status_t    dump(int fd, const Vector<String16> &args) const;*/
    status_t    setParameters(const char *parameters);
    status_t    setParameters(const CameraParameters& params);
    char*       getParameters() const;
    void        putParameters(char *parms);
    status_t    sendCommand(int32_t command, int32_t arg1,
                                    int32_t arg2);
    void        release();

private:
    static  const int   kBufferCount = MAX_BUFFERS;
    static  const int   kBufferCountForHd = MAX_BUFFERS_HD;

    class PreviewThread : public Thread {
        CameraHardwareSec *mHardware;
    public:
        PreviewThread(CameraHardwareSec *hw):
        Thread(false),
        mHardware(hw) { }
        virtual void onFirstRef() {
            run("CameraPreviewThread", PRIORITY_URGENT_DISPLAY);
        }
        virtual bool threadLoop() {
            mHardware->previewThreadWrapper();
            return false;
        }
    };

    class PictureThread : public Thread {
        CameraHardwareSec *mHardware;
    public:
        PictureThread(CameraHardwareSec *hw):
        Thread(false),
        mHardware(hw) { }
        virtual bool threadLoop() {
            mHardware->pictureThread();
            mHardware->mSecCamera->endSnapshot();
            return false;
        }
    };

    class AutoFocusThread : public Thread {
        CameraHardwareSec *mHardware;
    public:
        AutoFocusThread(CameraHardwareSec *hw): Thread(false), mHardware(hw) { }
        virtual void onFirstRef() {
            run("CameraAutoFocusThread", PRIORITY_DEFAULT);
        }
        virtual bool threadLoop() {
            mHardware->autoFocusThread();
            return true;
        }
    };

            void        initDefaultParameters(int cameraId);
            void        initHeapLocked();

    sp<PreviewThread>   mPreviewThread;
            int         previewThread();
            int         previewThreadWrapper();

    sp<AutoFocusThread> mAutoFocusThread;
            int         autoFocusThread();

    sp<PictureThread>   mPictureThread;
            int         pictureThread();
            bool        mCaptureInProgress;

            int         save_jpeg(unsigned char *real_jpeg, int jpeg_size);
            void        save_postview(const char *fname, uint8_t *buf,
                                        uint32_t size);
            int         decodeInterleaveData(unsigned char *pInterleaveData,
                                                int interleaveDataSize,
                                                int yuvWidth,
                                                int yuvHeight,
                                                int *pJpegSize,
                                                void *pJpegData,
                                                void *pYuvData);
            bool        YUY2toNV21(void *srcBuf, void *dstBuf, uint32_t srcWidth, uint32_t srcHeight);
            bool        scaleDownYuv422(char *srcBuf, uint32_t srcWidth,
                                        uint32_t srcHight, char *dstBuf,
                                        uint32_t dstWidth, uint32_t dstHight);

            bool        CheckVideoStartMarker(unsigned char *pBuf);
            bool        CheckEOIMarker(unsigned char *pBuf);
            bool        FindEOIMarkerInJPEG(unsigned char *pBuf,
                                            int dwBufSize, int *pnJPEGsize);
            bool        SplitFrame(unsigned char *pFrame, int dwSize,
                                   int dwJPEGLineLength, int dwVideoLineLength,
                                   int dwVideoHeight, void *pJPEG,
                                   int *pdwJPEGSize, void *pVideo,
                                   int *pdwVideoSize);
            void        setSkipFrame(int frame);
            bool        isSupportedPreviewSize(const int width,
                                               const int height) const;
    /* used by auto focus thread to block until it's told to run */
    mutable Mutex       mFocusLock;
    mutable Condition   mFocusCondition;
            bool        mExitAutoFocusThread;

    /* used by preview thread to block until it's told to run */
    mutable Mutex       mPreviewLock;
    mutable Condition   mPreviewCondition;
    mutable Condition   mPreviewStoppedCondition;
            bool        mPreviewRunning;
            bool        mExitPreviewThread;

    /* used to guard threading state */
    mutable Mutex       mStateLock;

    CameraParameters    mParameters;
    CameraParameters    mInternalParameters;

    sp<MemoryHeapBase>  mPreviewHeap;
    sp<MemoryHeapBase>  mRawHeap;
    sp<MemoryHeapBase>  mRecordHeap;
    sp<MemoryHeapBase>  mJpegHeap;

    SecCamera           *mSecCamera;
    const __u8          *mCameraSensorName;

    mutable Mutex       mSkipFrameLock;
    int                 mSkipFrame;

#if defined(BOARD_USES_OVERLAY)
    sp<Overlay>         mOverlay;
    bool                mUseOverlay;
    int                 mOverlayBufferIdx;
#endif

    camera_notify_callback mNotifyCb;
    camera_data_callback mDataCb;
    camera_data_timestamp_callback mDataCbTimestamp;
    void                *mCallbackCookie;

    int32_t             mMsgEnabled;

    bool                mRecordRunning;
    mutable Mutex       mRecordLock;
    int                 mPostViewWidth;
    int                 mPostViewHeight;
    int                 mPostViewSize;

    Vector<Size>        mSupportedPreviewSizes;
};

}; // namespace android

#endif
