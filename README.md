# DroidJitChecker

## What's it
  * It's a tool that checks whether your java methods is jit-friendly or not
  * It will output a html file that represents the result.

## Requirement
  * Your Android project should be able to be built via Gradle
  *  jitwatch suits
  * Ruby Runtime

##Setup
###Install jitWatch
####Get the source  
```
git clone git@github.com:AdoptOpenJDK/jitwatch.git
```

####Build  
Use **only one** of the following three methods. 

Method 1:ant  
```
ant clean compile test run
```

Method 2:maven  
```
mvn clean compile test exec:java
```
Method 3:gradle  
```
gradlew clean build run
```

###Configure the tool
Clone the current repo and then configure the `config.ini` file  
```
[setup]
jarScan = "/Users/androidyue/github/jitwatch/jarScan.sh"
maxMethodSize = 325
outputDir = "/tmp/DroidJitChecker/output_new/"
```

Some explanations

  * jarScan Must modified, Use your jitwatch path instead
  * maxMethodSize No need to modify. Please be careful if you want to change this
  * outputDir  can be modified as any valid directory path.



##How to use it
Open your terminal and input the commend like the following

```
ruby jitChecker.rb your_android_project jarTask
```

Note: the jarTask is a task that will create a jar file for the analysis. You can find the jar tasks by performing `./gradlew tasks`. And select one of the tasks starting with jar


##View the results
  * After the execution of the above command, It will automatically open the result file in a browser.
  * You can still see the result file path in the console
  * The result file name is related to the jarTask.
  * The result is sorted by byteSize and in a descending order.

The content of the result may like this
```
MD4.mdfour64

Package:com.app.utils
Parameters:int[]
ByteSize:1129
```

  * `MD4.mdfour64` indicates the methods and its belonging class
  * `Package:com.app.utils` indicates where the  `MD4` class is placed
  * `Parameters:int[]` indicates what parameters the method `mdfour64` receives
  * `ByteSize:1129` indicates how much bytes the method `mdfour64` holds

##How to correct
Write straight, simple code  
Write straight, simple code  
Write straight, simple code  

##Contribute
Any ideas and helpful codes will be appreciated.

The following contribution(s) is(are) welcomed

  * Make the result appearance beautiful(using CSS files)