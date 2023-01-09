# AutomatedDataCurationPNNL
Part 1: In one group of sample files (Greg has 3 groups: control,
infect, blank), this code reads each csv file and change the format
based on user's needs. In Greg's case, the columns ‘Calibrated m/z’,
‘m/z Error Score’, and‘Isotopologue Similarity’are removed. Since the
4 quantitative values‘Peak Height’, ‘Resolving Power’, ‘m/z error
(ppm)’, and‘Confidence Score’are important, I moved them to the most
right side in the feature table.

Then the code aligns each file one by one based on the
"Molecular.Formula" while summarizing the Number of peaks per file,
Percentage of peaks assigned for each file, Range, mean, and standard
deviation for percentage of peaks assigned per sample type. It
generates csv files containing the aligned features and summary of all
the relevant values.

Then the code removed the features that do not appear in 50% or
greater of the files per sample type (≥18 for infected, ≥18 for
control, ≥12 for blank media) and puts the total number of assigned
peaks that occur in 50% or greater of the files per sample type into
the abovementioned summary csv file.

In the end, the code generates csv file reporting averages and
standard deviation of Peak Height’, ‘Resolving Power’, ‘m/z error
(ppm)’, and‘Confidence Score’.

The code is run 3 times to get the results for 3 sample groups
(control, infect, and blank)

Part 2: This code creates blank (media) subtracted files for each
sample group (control and infected in this case). The subtraction has
two varieties: one that removes samples features that are also present
in the blank, and one that removes sample features if their averaged
peak heights are less than 3x greater than that of the blank. The code
then generates csv containing features after subtraction for both
control and infect groups.

This code is run 2 times to get the blank subtracted files for both
control and infect.

Part 3: This code aligns the background subtracted control and
infected feature tables. The final aligned feature table contains
features common to both group and list the averages and standard
deviation values including 'Peak Height’, ‘Resolving Power’, ‘m/z
error (ppm)’, and‘Confidence Score’for both groups (control and
infect). The code also generates one csv file for unique infected, and
one csv file for unique control (This is done for both varieties of
blank subtracted files).

The code is run 2 times to get the final feature tables for both 
kinds of blank subtraction.
