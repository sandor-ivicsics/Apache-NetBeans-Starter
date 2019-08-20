# Apache-NetBeans-Starter

macOS application to start Apache NetBeans using binary package.  
Prior version 11.1 the Apache NetBeans did not have macOS launcher.  
Using this application you can set JDK and Apache NetBeans home directories and start Apache NetBeans from Launchpad.

Prerequirements:  
Download and install JDK  
Download and extract Apache NetBeans 9/10/11/11.1

Usage:  
Download and extract Apache NetBeans Starter  
Launch the application  
Select JDK and Apache NetBeans home directories

How to change JDK home?  
Just run the following in terminal:  
defaults delete hu.accassist.Apache-NetBeans-Starter netbeans_jdkhome  

How to change Apache NetBeans home?  
Just run the following in terminal:  
defaults delete hu.accassist.Apache-NetBeans-Starter netbeans_home
