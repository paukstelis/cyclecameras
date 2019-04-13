# cyclecameras
PHP/bash scripts for cycling mjpg_streamer processes for multiple USB cameras based on need (ideal for systems with multiple Octoprint instances)

## Purpose
I wrote these scripts for a mini-3D printer farm (9 printers) running individual octoprint instances on a single Linux box. I had a bunch of cheap YUV USB webcams pointed at each
printer, but since they reserve so much bandwidth on the USB bus, I could only have two running at a time. These scripts start/stop mjpg_streamer processes as needed so all the printers can be monitored by cameras (just not at the same time).

## Setup
Every setup is going to be different. In my case I am running apache and some basic web pages to provide overview of the printers' status and another level of access control for the octoprint instances.  
Therefore, in octoprint setup, I point my stream URL to the PHP script and pass it the device name associated with that printer's camera:
`http://myprinteraddress.com/pathtophpscripts/cyclecamera.php?camera=/dev/video0`
(it's a good idea to use udev to set a device alias based on serial number of camera or use USB hardware address)

## Basics
If an old mjpg_streamer instances is already active on the designated port, the script will check to see if it is being actively monitored using `ss`.
If the old mjpg_streamer instance is being watched and has been running for more than 10 minutes, it will be killed and the new instance for the new camera is started.
If the old instance is not being watched (not streaming to any clients), it will be killed and the new instance started.

## Other
You can still run multiple cameras on separate USB buses. In my case I have 3 buses with 3 cameras on each. I use port-specific script pairs (8001, 8002, 8003, etc.) to control the active mjpg_streamer instance on each bus. Simply edit the port variable in the bash script.

## Disclaimer
Not making any crazy claims and use at your own risk.
