This file contains minimal documentation for the demos in this directory.

Despite all of the directories and Files here, there are actually only three main
demos to run here:
1. Labeler: Program to label Sketch data in MIT SketchML (XML) format.  Found in the Labeler subdirectory.
2. ProcessJNT, LabelAndGroupXML, GroupXML: Batch files for recognizing and/or grouping
	data that starts in either XML or JNT format.  See documentation below.  You probably want ProcessJNT,
	as it's the most commplete.
3. SketchPanel: A demo app that allows you to draw and recognize your strokes.  Right now it only
	supports single shape recognition of digital logic gates, so if you want to use the recognize
	feature, you have to erase the panel between each stroke.  See below for more documentation.

IF YOU CAN'T GET SOMETHING TO RUN, you may be missing the JournalReader Component, available
from Microsoft.  You need to install that component (in addition to the Tablet PC SDK) to run this software.

***************************

ProcessJNT.bat:

ProcessJNT targetFile [crfFile]
	targetFile - a Windows Journal sketch file (*.jnt) that you want to
		     process.
	crfFile    - a specific, trained conditional random field (*.tcrf) to be
		     used during recognition (optional)

This batch file must be executed from the command-line.

Given a .jnt file, does the following:
	* Converts it to a .xml file
	* Labels the converted file using one of two methods
	* Displays the labeled file with OldLabeler
	* Groups the labeled strokes
	* Displays the grouped file

Stores the intermediate files created during this process in the intermediate folder.

The two labeling methods are:
	* InferFromJnt (currently enabled)
	* JntToXml and then RunCRF

*NOTE* There is a bug in the display that links strokes when they shouldn't be linked, so the
recognized drawing will look a little funny.

**************************
LabelAndGroupXML.bat:

LabelAndGroupXML targetFile [crfFile]
  targetFile - an MIT XML sketch file
  crfFile    - A specific, trained conditional random field (*.tcrf) to be used
               during recognition

Given a .xml file, does the following:
    * Labels the sketch
    * Displays the labeled file with OldLabeler
    * Groups the labeled strokes
    * Displayes the grouped file
    
**************************
GroupXML.bat:

GroupXML targetFile
  targetFile - a labeled MIT XML file that you want to process.
  
Given a labeled .xml file, groups the labeled strokes and displays the grouped file

**************************

InferFromJnt (Command Line):

InferFromJnt.exe -crf <crffile>.tcrf <labelfile>.txt -d <directory of jnt files>


***************************

InferFromJnt (Wire-Gate Auto):

Just double click on the .exe after adding .jnt files into the InferFilesHere folder. They are then automatically converted and .xmls are placed into the InferredJnt folder. You can then use the labeler to view them.


***************************

RunCRF:

I don't recommend running this training since it doesn't always work and takes a (relatively) long time. But if you must...

RunCRF -t -n <# labels> -l <label file>.txt -o <output file>.tcrf -d <directory of training .xml>


Just use this command (in the \RunCRF directory through Windows CMD):

RunCRF.exe -t -n 2 -l wire-gate-labels.txt -o wgTest.tcrf -d "TrainingFolder"


***************************

Labeler:

This is the prototype of the new Labeler. A default domain is loaded when you start, and this domain is the more specific individual gates domain. There's also a WireGateDomain.txt file located in the same directory as the Labeler for when you want to show off wire v. gate xmls.

Also, you can load .jnts directly from the labeler (although they of course are not labeled and have no stroke colors/grouping/etc, unlike some of the .xmls you can load in).

ToolTips are enabled in this version, but be warned that the "probabilities" are still not too accurate.


***************************

E85 Data:

A sample of some E85 sketches. Sorted into folders by *.Jnt, *.xml, *.fragged.xml, and *.fragged.labeled.xml files.


***************************

Circuit Survey Data:

Data collected over the summer. A subset of this data was used to train the Wire-Gate CRF used in InferFromJnt.


***************************

SketchPanel:

The SketchPanel example program, called SketchJournal, is a vanilla, Windows-Journal-like 
drawing application that records Ink and runs an example recognizer on drawn symbols.  

Currently the example recognizer(s) will recognize digital logic gates with confidence levels.
The confidence levels are displayed at the bottom of the window, and the gate changes color
to indicate the best recognized symbol. 
However, only single strokes can be recognized, so you have to erase each gate you draw if you want
to recognize another gate. 


