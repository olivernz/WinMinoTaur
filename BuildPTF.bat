@echo off

:: WinTaurus - Performance Test Harness Build Script
:: -------------------------------------------------
::
:: This is the main executable for the framework. It will do all processing
:: needed to run the JMeter script.
::
::   Copyright 2016 Oliver Erlewein
::
::   Licensed under the Apache License, Version 2.0 (the "License");
::   you may not use this file except in compliance with the License.
::   You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
::   Unless required by applicable law or agreed to in writing, software
::   distributed under the License is distributed on an "AS IS" BASIS,
::   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
::   See the License for the specific language governing permissions and
::   limitations under the License.

echo Build script start

SET mainDir=\Performance

:: Create directory tree
mkdir %mainDir%
mkdir %mainDir%\jmeter
mkdir %mainDir%\scripts
mkdir %mainDir%\config
mkdir %mainDir%\config\exampleEnv
mkdir %mainDir%\data
mkdir %mainDir%\data\exampleEnv
mkdir %mainDir%\commands
mkdir %mainDir%\results

:: Copy example files
copy runPerfTest.sh		%mainDir%\commands
copy exampleEnv.cnf		%mainDir%\config\exampleEnv
copy exampleBalance.cnf	%mainDir%\config\exampleEnv
copy exampleScript.JMX	%mainDir%\scripts
copy exampleData.csv	%mainDir%\data\exampleEnv

echo Build script done. PTF under %mainDir%
