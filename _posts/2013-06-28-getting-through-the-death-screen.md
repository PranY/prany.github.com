---
layout: post
title: "Getting through the 'Death Screen'"
tagline: "Unbrick an android phone"
category: Android
tags: [Death screen, bricked]
---

It's not uncommon for Android devices to get bricked. With so many custom ROMs around in the wild, and will to play around doing all sorts of things with the device may make the device bricked! So what’s next? If you have time and money to make it to the service center, you can go ahead and get your Galaxy S unbricked (If you can pay almost 60% of total cost). Or simply follow the below guide to unbrick your Samsung GALAXY S-I9000 Series phone. 
(I personally bricked mine by a wrong click on Re-partition while rooting) 

When we say bricked, it means your device is not booting or got stucked at the booting screen namely DEATH SCREEN.

<center>
<img src="/assets/images/deathscreen.jpg" alt="deathscreen">
</center>

##### Note that this method works only if your Galaxy S boots into Download mode by pressing and holding "Volume Down" key, "Power" button, and "Home" button simultaneously. For those who are not able to boot into Download mode, I suggest to get unbrick done from Samsung service center. 

###### _I have a solution for above problem too, but it will cost you some amount to purchase a micro-USB connector modified with a 301k resistor in proper links._

Pre Requisites (Downloadable):
[2.2.1 XWJS7 Firmware][1] (Password : samfirmware.com),
[PIT 803][2],
[Odin3 v1.3][3],
USB Cable,
Samsung Galaxy S GT-I9000

Procedure to flash XWJS7 2.2.1 (Stable Froyo) version on your Galaxy S GT I9000:

*  1--Now, after downloading the XWJS7 firmware along with the Odin and PIT File, you need to unzip the same as it's a zip ffile after which you will get three files.
*  2--Next up you need to open Odin 1.3 from the above zip file so that you can install this downloaded firmware into your device. After opening the Odin 1.3, **ensure that you have completely closed the KIES application on your computer and ensure that you haven't connectedd the mobile**

( PS : Remove  it from your HD because its s useless and irritating software, If you think its good for backups then you must know that those backups aren't forward compatible and .md5 checksum error is common if you upgrade to another higher ROM. Use backup option provided in kernel mode. )
<center>
<img src="assets/images/odin.jpg" alt="odin">
</center>
* 3--Now, first switch off your phone, take out the sim card along with the memory card and Switch On your device in the download mode. To start download mode in Samsung Galaxy S GT I 9000, you need to hold the Volume Down button + the Home key button (the middle button). While holding these both buttons, you need to switch ON your device. If you see a screen like the below one then only it means that you have successfully started your device in the download mode. 

<center>
<img src="assets/images/downloading.jpg" alt="downloading" align="center">
</center>

* 4--Now connect Samsung Galaxy S to the computer, after which you will see that first "ID:COM" box as shown below will turn yellow and in the message box you will see that it will show:ADDED.

<center>
<img src="assets/images/odindetect.jpg" alt="odin detected" align="center">
</center>

* 5--Now, after connecting the phone to the computer you will have to add the below parameters as mentioned below, also click on " Re-partition" and hit START.

  * PIT - 8803 PIT File
  * PDA -  PDA_JS7.tar.md5

* 6--It will take some time to complete the flashing and within few minutes your phone will reboot.
* 7--Congos, its half done, Now follow back the same procedure up to step 5 but know add
  * PIT -  803 PIT File
  * PDA -  PDA_JS7.tar.md5
  * Phone -  PHONE_JPY.tar.md5
  * CSC -  CSC_XEE_JS1.tar.md5

From the kernel downloaded and **DO NOT CLICK ON "RE-PARTITION",**  hit Start

* 8--As soon as you click on the Start option, the firmware will start updating in the device, please note that you don't unplug your device and ensure that you have continuous power because if in the between power goes off then your phone will become dead and then again you need to follow the procedure.
* 9--As soon as the installation gets finished, the mobile will be rebooted and will take longer time than the normal reboot as this is the first time after the firmware upgrade the device is getting switched ON.
### BINGO..!!!! You just unbricked your phone 

As soon as the phone reboots, just tap on the Settings > About Phone > Build Number where you will see that you are on XWJS7 Android version. Now, you can restore the backup contents easily. This is it, now you have unbricked your phone as well as installed the Froyo 2.2.1 Android build on your Galaxy S.

Try searching for different CUSTOM ROMs like Darky's ROM or Cyanogen MOD etc. with their respective kernels. If you are not scared of turning your phone into a USELESS BRICK, because it can be resurrected again.

(I found a EUROPE firmware for STABLE GINGERBREAD 2.3.5 to do above steps. Read below to know few unknown codes.)

Build-in Features
Secret Codes
Note: these codes should activate automatically after the last character input * (aka NO WARNING)

<center>
<img src="assets/images/features.png" alt="features" align="center">
</center>

[1]: http://hotfile.com/dl/109160352/b004ded/GT_I9000_XWJS7_XXJPY_XEEJS1.rar.html
[2]: http://androidadvices.com/wp-content/uploads/2011/03/PIT-803.zip
[3]: http://androidadvices.com/wp-content/uploads/2011/03/Odin3-v1.3.zip