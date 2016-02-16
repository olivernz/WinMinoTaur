@echo off

:: WinTaurus - Performance Test Harness 
:: -------------------------------------
::
:: This is the main executable for the framework. It will do all processing
:: needed to run the JMeter script.
::
:: USAGE: runPerformanceTest.bat <Environment> <TestName> <Prefix> <LoadTime> <LoadShape> [ <Note> ]
::
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

SET mainDir=\Performance
:: Update the below link to point to your jmeter install
SET jmeterDir=%mainDir%\jmeter\apache-jmeter-2.13
SET scriptDir=%mainDir%\scripts
SET configDir=%mainDir%\config
SET dataDir=%mainDir%\data
SET commandsDir=%mainDir%\commands
SET jmeterCommand=jmeter.bat

:: From the command line
SET Environment=%1
SET TestName=%2
SET Prefix=%3
SET LoadTime=%4
SET LoadShape=%5
SET Note=%6
:: Below can be used to add a user name to the results directory.
SET User=

:: If you want to shorten the prefix given to a certain length. In
:: this case 6 characters.
SET Prefix=%Prefix:~0,6%

:: Only set the below to true if you want to test this script!
SET DryRun=false

:: Set current date & time
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set datetime=%%G

SET resultsDir=%mainDir%\results\%datetime:~0,4%\%datetime:~4,2%\%datetime:~6,2%
SET CMDrunner=%jmeterDir%\lib\ext\CMDRunner.jar
SET TDF=TestDetails.txt
SET ResultsSubDir=TestResults

:: Check if command was started with arguments
IF NOT "%Environment%" == "" GOTO :ContinueNormally 
    echo Usageo WinTaurus: runPerfTest.bat [Environment] [TestName] [Prefix] [LoadTime] [LoadShape]
	echo        [Environment] name of cfg file in config directory (no extension)
	echo        [TestName] the name of the test (no extension)
	echo        [Prefix] that the test results will have
	echo        [LoadTime] in seconds
	echo        [LoadShape] name of cfg file in config directory (no extension)
	echo        [Note] Any note you need to pass with the test (OPTIONAL)
	EXIT /B

:ContinueNormally

:: Make daily directory if it doesn't exist
mkdir %resultsDir%
cd %resultsDir%

:: Set the start time
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set datetime=%%G
SET TestStartTime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%.000

:: Create results directory
:: Format of  dir is HH-MM-SS_XXXX_XXXXXXXXXXXXXX...
set resultsDir=%resultsDir%\%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%_%Prefix%_%TestName%_%User%
mkdir %resultsDir%
cd %resultsDir%

:: Write file with some details for the test
(
  @echo ----------------------- Performance Test Details ------------------------
  @echo Execution Start       : %TestStartTime%
  @echo Environment           : %Environment%
  @echo Test Name             : %TestName%
  @echo Test Duration         : %LoadTime%
  @echo Load Shape            : %LoadShape%
  @echo Prefix                : %Prefix%
  @echo Results Directory     : %resultsDir%
  @echo Note                  : %Note%
) > %TDF%
  

:: Copy files needed for test execution
copy %scriptDir%\%TestName%.jmx %resultsDir%
copy %configDir%\%Environment%\%Environment%.cfg %resultsDir%
copy %configDir%\%Environment%\%LoadShape%.cfg %resultsDir%
:: If you want to copy relevant data for the test too uncomment the below
:: copy %dataDir%\%Environment%\*.* %resultsDir%

SET /p JMeterGlobalDefaults=<%configDir%\global.txt
SET JMeterEnvironmentVariables=%configDir%\%Environment%.cfg
SET JMeter=<%configDir%\global.txt
SET jmCMD=%jmeterDir%\bin\%jmeterCommand% -n -t %TestName%.jmx -l results.jtl -j jmeter.log -JLoadTime=%LoadTime% -JresultsDir=%resultsDir% -JPrefix=%Prefix% -JLoadBalanceVariables=%LoadShape%

echo ----Starting Performance Test %TestName% - %date% %time%
IF "%DryRun%"=="true" ( 
	:: we first need to start this loop that makes sure the JMeter test exits. Had issues with that. It splits off a CMD window. 
	START CMD /C CALL "%jmeterDir%\bin\StopTestFramework.cmd" 5
	echo %jmCMD% 
) ELSE (
    :: we first need to start this loop that makes sure the JMeter test exits. Had issues with that. It splits off a CMD window. 
	START CMD /C CALL "%jmeterDir%\bin\StopTestFramework.cmd" %LoadTime%
	:: Execute JMeter
	call %jmCMD%
	find /v "EXCLUDE" < results.jtl > results_clean.jtl
	:: If you need to keep the full results then change this logic
	move results_clean.jtl results.jtl
)
echo ----Ended Performance Test - %TestName% - %date% %time%

:: Update Test Details file
@echo Execution End         : %date% %time% >> %TDF%

:: Wait 5 seconds before results calculation
timeout 5

:: Run extraction and calculation of data
mkdir %resultsDir%\%ResultsSubDir%
cd %resultsDir%\%ResultsSubDir%

:: Results calculation and saving of Graphs is here
IF "%DryRun%"=="true" (
	echo Normally Graph calculation is executed here!
) ELSE (
	SET ExcludeLabels=
	SET GraphDefaultsScatter=--tool Reporter --input-jtl ..\results.jtl --width 1024 --height 768 --granulation 100 --paint-gradient no --paint-zeroing no --paint-markers yes --line-weight 0 %ExcludeLabels%
	SET GraphDefaultsGraph=--tool Reporter --input-jtl ..\results.jtl --width 1024 --height 768 --granulation 100 --paint-gradient no --paint-zeroing no --paint-markers no --line-weight 2 %ExcludeLabels%
	java -jar %CMDRunner% --tool Reporter --input-jtl ..\results.jtl --plugin-type AggregateReport --generate-csv AggregateReport.csv %ExcludeLabels%
	::java -jar %CMDRunner% --tool Reporter --input-jtl results.jtl --plugin-type SynthesisReport --generate-csv SynthesisReport.csv %ExcludeLabels%
	java -jar %CMDRunner% --plugin-type ResponseTimesOverTime --generate-png ResponseTimesOverTime.png %GraphDefaultsScatter%
	java -jar %CMDRunner% --plugin-type LatenciesOverTime --generate-png LatenciesOverTime.png %GraphDefaultsScatter%
	java -jar %CMDRunner% --plugin-type HitsPerSecond --generate-png HitsPerSecond.png %GraphDefaultsGraph%
	java -jar %CMDRunner% --plugin-type ResponseTimesOverTime --generate-png ErrorResponseTimesOverTime.png --success-filter false %GraphDefaultsScatter%
	java -jar %CMDRunner% --plugin-type ResponseTimesPercentiles --generate-png ResponseTimesPercentiles.png %GraphDefaultsGraph%
	java -jar %CMDRunner% --plugin-type TransactionsPerSecond --generate-png TransactionsPerSecond.png %GraphDefaultsGraph%
	java -jar %CMDRunner% --plugin-type ThreadsStateOverTime --generate-png ThreadsStateOverTime.png %GraphDefaultsGraph%
)
cd %resultsDir%

:: Update Test Details file
(
  @echo Results Calculation   : %date% %time%
  @echo -------------------------------------------------------------------------
  @echo Results Files Created during Test:
  @echo.
  dir /B /A-D .\%ResultsSubDir%
  @echo -------------------------------------------------------------------------
) >> %TDF%

:: Move files into right folders
copy %TDF% %resultsDir%\%ResultsSubDir%

:: Post Processing (e.g. SQL extracts) can be placed here


:: Cleanup ZIP files not needed anymore

:: Remove files that are not needed anymore
:: del %ResultsDir%/*.jtl
:: del %TestName%.jmx

:: Return to the main commands directory
cd %commandsDir%
