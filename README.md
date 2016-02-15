# WinoTaurus
Windows Performance Test Framework for JMeter

This Performance Test Framework (PTF) is a hugely simplified version of the PTF that exists for linux (not open source ...yet). The following features are why the PTF is useful:

	* Standardise the running of tests
	* Have a common repository for results
	* Automated generation of results after the test
	* Command line so can be added to CI/CD environments
	* Multi environment capable by config
	* Multi data capable by environment
	* Can be easily customised for your tests

There are severe limitations for the Windows version (which do exist in the linux version though):

	* No provision for multi load generators (can be easily added though)
	* No provision for AWS/RackSpace/... auto provisioning
	* No PHP UI for running tests
	* No GMX file support (JMeter group tests)
	
There are also pre requisites:
	
	* JMeter must be installed under /Performance/jmeter/apache... 
	* JMeter-plugins must be installed too (Standard Set and Extras Set, http://jmeter-plugins.org )
	* Windows 7 or later
	
On GitHub you will see default directory structure needed by the Performance Test Framework. Please
do not change (only if you know what you are doing!). In the directories are some example files change 
to you hearts content.

If you are using this and find it useful I'd be happy to hear about feedback or changes you have made
or want. Email me at WinoTaurus(at)erlewein.org.

Oliver
