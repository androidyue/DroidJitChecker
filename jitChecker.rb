#!/usr/bin/env ruby
require 'inifile'
require 'csv'

$OUTPUT_DIR = '/tmp/DroidJitChecker/output/'
$outputHtmlString = ''
$jarScan = ''
$jarTask = ''
$jarRelPath = ''
$itemHashSet = Hash.new
$maxMethodSize = 325
$projectDir = ''

def fillupItemData(packageName, className, methodName, parameters, byteSize) 
	shouldSkip = (packageName.nil? || className.nil? || methodName.nil?)
	if (shouldSkip) 
		return
	end

	itemData = "<h2>#{className}.#{methodName}<h2><ul><li>Package:#{packageName}</li>"
	if !parameters.empty? 
		itemData = itemData + "<li>Parameters:#{parameters}</li>";
	end
	itemData = itemData + "<li>ByteSize:#{byteSize}</li></ul><br/>"

	$outputHtmlString = $outputHtmlString + itemData;
end

def writeStringToFile(outputHtmlFile, content) 
	File.write(outputHtmlFile, content)
end

def generateOutputFileName() 
	time = Time.new
	return $OUTPUT_DIR +  "#{$jarTask}_#{time.year}-#{time.month}-#{time.day}_#{time.hour}-#{time.min}-#{time.sec}.html"
end


def generateReadableHtml(csvContent)
	CSV.parse(csvContent) do |row|
  		byteSize = row[4]
  		$itemHashSet[row] = byteSize
	end
	
	Hash[$itemHashSet.sort.reverse]

	$itemHashSet.each do |key, value|
		packageName = key[0]
		className = key[1]
		methodName = key[2]
		parameters = key[3]
		byteSize = key[4]
		fillupItemData(packageName, className, methodName, parameters, byteSize)
	end
	outputFileName = generateOutputFileName()
	puts "Writing results into #{outputFileName}"
	writeStringToFile(outputFileName, $outputHtmlString)
end

def setup()
	$projectDir = ARGV[0]
	$jarTask = ARGV[1]
	scriptDir = File.dirname(__FILE__)
	configs = IniFile.load("#{scriptDir}/config.ini")
	setup = configs['setup']
	$jarScan = setup['jarscan']
	$OUTPUT_DIR = setup['output_dir']
	checkValidConfig()
	system "mkdir -p #{$OUTPUT_DIR}"
end

def checkValidConfig()
	throwException('Project Dir is not set correctly') if !File.exist?($projectDir)
	throwException('JarScan file is not found ') if !File.exist?($jarScan)
	throwException('Jar Task is not set ') if checkTextIsEmpty($jarTask)
end

def checkTextIsEmpty(text)
	return text.nil? || text.empty?
end


def throwException(message)
	raise "#{message}, please correct and retry"
end

def analyze()
	puts "Clean and Compile"
	system "cd #{$projectDir} && ./gradlew clean #{$jarTask}"

	outputJarFile = `find #{$projectDir} -name "*.jar" | grep "intermediates/packaged"`.strip()
	puts "Analyzing jar file #{outputJarFile}"
	scannedResult = `bash #{$jarScan} --mode=maxMethodSize --limit=#{$maxMethodSize}  #{outputJarFile}`.strip()
	generateReadableHtml(scannedResult) if !checkTextIsEmpty(scannedResult)
end

setup()
analyze()
