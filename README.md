# Apache-NetBeans-Starter

macOS application to start Apache NetBeans using binary package.  
Prior version 11.1 the Apache NetBeans did not have macOS launcher.  
Using this application you can set JDK and Apache NetBeans home directories and start Apache NetBeans from Launchpad.

How to change JDK home?  
Just run the following in terminal:  
defaults delete hu.accassist.Apache-NetBeans-Starter netbeans_jdkhome  

How to change Apache NetBeans home?  
Just run the following in terminal:  
defaults delete hu.accassist.Apache-NetBeans-Starter netbeans_home
