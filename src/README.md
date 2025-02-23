 System Integration
====================================



At this point, it is assumed that the Neural Network model has been already [trained](../tensorflow_training/) and [optimized](../tensorrt/). Also, the Thermal camera is assumed to be placed in the vehicle, as described in the [camera mounting](../CAD/README.md). However, before running the python script to perform online object detection on thermal images with the [Tau2 camera](../CAD/), some setup is required to interface with the camera as a regular video device (E.g. /dev/video0).

First, the libraries for TeAx's Thermal Grabber must be installed. Run the installation script provided in this folder. This script will install some dependencies (if needed), and then compile the necessary libraries to interface with the Tau2. 

```
$ ./install.sh
```



Then, the v4l2loopback kernel module must be loaded for the Thermal Grabber library to interface with.

```
$ sudo modprobe v4l2loopback
```



Finally, run the daemon to connect the module to the camera via TeAx's library.

```
$ sudo LD_PRELOAD=TCG_SDK_2018_02_14/libthermalgrabber/lib/libthermalgrabber.so ./TCGrabberUSBV4L2d /dev/video0
```

*Note: In order for this command to work, you must first verify the video device mounted by the kernel module in order to run the daemon correctly. This should match the videoX device in the command.*



After running this, you should see communication with the Tau2 camera. 



*Note: Some features are not enabled by default. This will lead to some error messages showing on screen (see below). Nevertheless, communication is still possible as long as the daemon is running.*



```
Request with 17 bytes: 55 41 52 54 c 6e 0 0 8e 0 2 df a2 0 40 48 c4 
 TauCom: Error:
:CAM_FEATURE_NOT_ENABLED
Error: Frame check failed
connect to camera failed
```



Finally, open a new terminal and run the object detector. The following command runs the object detector with the given model, model path, video device and confidence threshold. 



```
$ python3 trt_ssd.py --model ssd_mobilenet_v2_thermal --model_path ssd/TRT_ssd_mobilenet_v2_thermal.bin --usb --vid 0 --conf_th 0.6
```



If everything goes well, you should be able to see online inference with the thermal camera feed on screen.



<center>
    <img src="docs/thermal_capture.JPG" width="600px" />
</center>

​    



