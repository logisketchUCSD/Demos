Grouper.exe

Groups labeled strokes together into gates and wires using a very simple algorithm.

Usage: 

Grouper.exe file1.xml [file2.xml file3.xml ... [-f listOfFiles.txt]]

	file1.xml		The first file to be grouped.
	file2.xml etc.		Any number of other files to be grouped
	-f listOfFiles.txt	A list of files to be grouped (one per line)
	-d directory		All files in a directory (ignores filenames containing .grp)

For a processed file name.xml, a new file will be created: name.grp.xml