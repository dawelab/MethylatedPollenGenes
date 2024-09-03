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
ending = 'mMPGs.upflank100.sam'

#minimum C counts in reads to be included
minCGs = 4
minCHGs = 4
minCHHs = 5

#minimum CG for UM read
minCGmeth = 0.2

##########################################################################################################
#initialize variables and open files
##########################################################################################################

import glob
import os
os.chdir(directory) 

outFileSummary = open(ending + '.summary.txt', 'w')
outFileSummary.write('file' + '\t' + 'unmethylated reads' + '\n')

for fileName in glob.glob(directory + '/*' + ending):
	inFile = open(fileName, 'rt')
	outFile = open(fileName[:-3] + 'meth', 'w')
	UMreads = 0
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
		if cols[0][0] != '@': #skip headerlines

			untrimmedMappedRead = cols[14].split(':')[-1:][0]
		
			if untrimmedMappedRead != oldMappedRead: #ignore PCR duplicates
				oldMappedRead = untrimmedMappedRead #and save read to compare with next line
				
				#Get read coordinates
				mappedLength = len(cols[9])
				mappedStart = int(cols[3])
				mappedEnd = mappedStart + mappedLength - 1
				if '-' in cols[11]: 
					orientation = '-'
				else:
					orientation = '+'
					
				#Calculate frequency of each methylation context in trimmed reads
				CG_count = untrimmedMappedRead.count('X')
				mCG_count = untrimmedMappedRead.count('x')
				CHG_count = untrimmedMappedRead.count('Y')
				mCHG_count = untrimmedMappedRead.count('y')
				CHH_count = untrimmedMappedRead.count('Z')
				mCHH_count = untrimmedMappedRead.count('z')
				
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
										
				#Count unmethylated reads
				try:
					if mCG_freq <= minCGmeth:
						UMreads += 1
				except TypeError:
					pass
				#write methylation frequencies to new file
				outFile.write(str(mCG_freq) + '\t' + str(mCHG_freq) + '\t' + str(mCHH_freq) \
				+ '\t' + str(mCG_count + CG_count) + '\t' + str(mCHG_count + CHG_count) + '\t' + str(mCHH_count + CHH_count) \
				+ '\t' + str(mappedStart) + '\t' + str(mappedEnd) + '\t' + orientation + '\t ' + untrimmedMappedRead + '\n')
								
								
			else: #count PCR duplicates
				PCRdups += 1		
			
			totalReads +=1

	print(fileName)
	print('total reads: ' + str(totalReads))	
	print('total reads excluding PCR duplicates: ' + str(totalReads - PCRdups))	
	print('unmethylated reads excluding PCR duplicates: ' + str(UMreads))
	print('proportion unmethylated reads: ' + str(UMreads/(totalReads - PCRdups)))
	outFileSummary.write(fileName + '\t' + str(UMreads/(totalReads - PCRdups)) + '\n')
	##########################################################################################################
	#close files
	##########################################################################################################
		
	inFile.close()
	outFile.close()