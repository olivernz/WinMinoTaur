# WinMinoTaur
Windows Performance Test Framework for JMeter

## Introduction
This Performance Test Framework (PTF) is a hugely simplified version of the PTF that exists for linux (not open source ...yet). The following features are why the PTF is useful:

	* Standardise the running of tests
	* Have a common repository for results
	* Automated generation of results after the test
	* Command line so can be added to CI/CD environments
	* Multi environment capable by config
	* Multi data capable by environment
	* Can be easily customised for your tests

There are severe limitations for the Windows version (which do not exist in the Linux version though):

	* No provision for multi load generators (can be easily added though)
	* No provision for AWS/RackSpace/... auto provisioning
	* No PHP UI for running tests
	* No GMX file support (JMeter group tests)
	* No HTML reports
	* No interfacing to external 3rd party applications like Splunk, PRTG, Nagios,...
	
There are also pre requisites:
	
	* Windows 7 or later
	* Java JRE 7 or later
	* JMeter must be installed under /Performance/jmeter/apache... (after installation as per below)
	* JMeter-plugins must be installed too (Standard Set and Extras Set, http://jmeter-plugins.org, after install )

	
##Installation
Download all files in this GitHub project and place them in a temporary directory on the drive you would like to install the PTF. Then execute BuildPTF.bat

This will generate the default directory structure needed by the Performance Test Framework under <drive>:\Performance. Please
do not change (only if you know what you are doing!). It will then copy all files to the right directories. 

Now manually unzip JMeter and JMeter-plugins to <drive>:\Performance\jmeter\. Then copy the file StopTestFramework.cmd to the jmeter\bin directory.

Now load your JMX files to the scripts directory and set up your environment configs and balance configs. Then you are free to execute.

If you are using this and find it useful I'd be happy to hear about feedback or changes you have made
or want. Email me at WinoTaurus(at)erlewein.org.

Oliver Erlewein
