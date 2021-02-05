# This whole directory is a kludge to support merging licenses
# from a lot of previous scans.  We should generate a separate
# sheet that keeps track of which repos were scanned when,
# but I'm hoping this whole approach goes entirely away ASAP.

all_csvs := $(wildcard *.csv)
outputs = merged_licenses.csv
inputs = $(filter-out $(outputs), $(all_csvs))

$(outputs): $(inputs)
	cat $(inputs) | sort -u >merged_licenses.csv
