# Installation
(Taken from the official libirimager documentation)
Download the libirimager package and install with
```
sudo dpkg -i FILE_YOU_DOWNLOADED.deb
```

# Configuration
To generate a config file for your camera, run the following commands in the shell:
```
$ sudo ir_download_calibration
$ ir_generate_configuration > `ir_find_serial`.xml # this file's name is your camera's serial number
```

# Kernel Driver Settings
You may find that the test file in the repo does not show video. If this happens, you may need to run the following commands to modify some of the UVC kernel module settings.

To test temporarily, run
```
$ sudo rmmod uvcvideo; sudo modprobe uvcvideo nodrop=1
```

If this fixes your problem, permanently change the flag with

```
$ sudo bash -c 'echo "options uvcvideo nodrop=1" > /etc/modprobe.d/uvcvideo.conf'
```
