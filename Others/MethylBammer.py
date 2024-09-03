#This script converts measures methylation values for each read in a SAM file produced by BS-Seeker2
#SAM FILE MUST BE SORTED
#It ignores parts of reads that don't overlap with a specified region of interest
#This script also removes PCR duplicates, defined as reads with precisely the same positions and methylation calls
#Not necessary, but much faster to use BEDTools intersect or Samtools view first to get subset of reads in the right region.

##########################################################################################################
#USER INPUT 
##########################################################################################################

#directory of input files
directory = '/scratch/gent/single-reads'
 
#input file endings
ending = 'PME_up600.sam'

#desired region (1-based, inclusive)
region = '5:152375079-152375678'

#minimum C counts in reads to be included
minCGs = 4
minCHGs = 4
minCHHs = 5

##########################################################################################################
#initialize variables and open files
##########################################################################################################
regionChr = region.split(':')[0]
regionStart = int(region.split(':')[1].split('-')[0])
regionEnd = int(region.split(':')[1].split('-')[1])

print('region: ' + regionChr + ':' + str(regionStart) + '-' + str(regionEnd))

import glob
import os
os.chdir(directory) 

for fileName in glob.glob(directory + '/*' + ending):
	inFile = open(fileName, 'rt')
	outFile = open(fileName[:-3] + 'meth', 'w')
	
	includedReads = 0
	totalReads = 0
	PCRdups = 0
	oldMappedRead = ''
	outFile.write('mCG' + '\t' + 'mCHG' + '\t' + 'mCHH' + '\t' + 'CG count' + '\t' + 'CHG count' + '\t' + 'CHH count' + '\t' + 'read start' + '\t' + 'read end' + '\t' + 'read orientation' + '\t' +'read call' + '\n')

	
	##########################################################################################################
	#Run through input file line by line and get numbers from each read
	##########################################################################################################
	
	#get next mapped read position, check if it is on the right chromosome, and reset some variables
	for newLine in inFile:
		cols = newLine.strip().split('\t')
		if cols[0][0] != '@': #skip header lines
			if cols[2] == regionChr: #check whether read maps to same chromosome as region of interest
				mappedLength = len(cols[9])
				mappedStart = int(cols[3])
				mappedEnd = mappedStart + mappedLength - 1
				leftTrim = 0
				rightTrim = 0

				#Determine what part of read, if any, overlaps region of interest
				if  mappedEnd >= regionStart:  #check whether read mapping position is large enough to be in region of interest	
					leftTrim = max(regionStart - mappedStart, 0)
					if leftTrim < mappedLength: #only continue if trimmed read overlaps region of interest
						rightTrim = max(mappedEnd - regionEnd, 0)
						if rightTrim < mappedLength: #only continue if right part of mapped read overlaps region of interest
							untrimmedMappedRead = cols[14].split(':')[-1:][0]
							if untrimmedMappedRead != oldMappedRead: #ignore PCR duplicates
								oldMappedRead = untrimmedMappedRead #and save read to compare with next line

								#Trim reads
								if '+' in cols[11]: #get mapped orientation
									orientation = '+'
													
									#left trim read
									leftTrimmedMappedRead = untrimmedMappedRead[leftTrim:]
									
									#right trim read 
									if rightTrim > 0:
										trimmedMappedRead = leftTrimmedMappedRead[:-rightTrim] #right trim read
									else:
										trimmedMappedRead = leftTrimmedMappedRead
									
								else:
									orientation = '-'
									
									#left trim read 
									if leftTrim > 0:
										leftTrimmedMappedRead = untrimmedMappedRead[:-leftTrim] #right trim read
									else:
										leftTrimmedMappedRead = untrimmedMappedRead
										
									#right trim read
									trimmedMappedRead = leftTrimmedMappedRead[rightTrim:]
									
											
								#Calculate frequency of each methylation context in trimmed reads
								CG_count = trimmedMappedRead.count('X')
								mCG_count = trimmedMappedRead.count('x')
								CHG_count = trimmedMappedRead.count('Y')
								mCHG_count = trimmedMappedRead.count('y')
								CHH_count = trimmedMappedRead.count('Z')
								mCHH_count = trimmedMappedRead.count('z')
								
								if mCG_count + CG_count >= minCGs:
									mCG_freq = float(CG_count/(mCG_count + CG_count))
								else:
									mCG_freq = ''
								if mCHG_count + CHG_count >= minCHGs:
									mCHG_freq = float(CHG_count/(mCHG_count + CHG_count))
								else:
									mCHG_freq = ''
								if mCHH_count + CHH_count >= minCHHs:
									mCHH_freq = float(CHH_count/(mCHH_count + CHH_count))
								else:
									mCHH_freq = ''
								
								
								#write methylation frequencies to new file
								outFile.write(str(mCG_freq) + '\t' + str(mCHG_freq) + '\t' + str(mCHH_freq) \
								+ '\t' + str(mCG_count + CG_count) + '\t' + str(mCHG_count + CHG_count) + '\t' + str(mCHH_count + CHH_count) \
								+ '\t' + str(mappedStart + leftTrim ) + '\t' + str(mappedEnd - rightTrim) + '\t' + orientation + '\t ' + trimmedMappedRead + '\n')
							
							else: #count PCR duplicates
								PCRdups += 1
							includedReads += 1 #keep track of number of reads
		totalReads +=1
	excludedReads = totalReads - includedReads

	print(fileName)
	print('Reads overlapping region: ' + str(includedReads))
	print('Reads overlapping region excluding PCR duplicates: ' + str(includedReads-PCRdups))	
	print('Reads not overlapping region: ' + str(excludedReads))
	##########################################################################################################
	#close files
	##########################################################################################################
		
	inFile.close()
	outFile.close()