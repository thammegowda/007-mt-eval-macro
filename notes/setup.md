# Setup


# Get WMT data

1. Metrics task has system level human assessment; normalized
2. WMT submissions has system outputs submitted by performers


```bash

root=$PWD
metrics=$root/wmt/metrics-task
submissions=$root/wmt/submissions

mkdir -p $metrics $submissions

# Step1: download metrics  
cd $metrics  
for year in 19 18 17; do
    wget http://ufallab.ms.mff.cuni.cz/~bojar/wmt${year}-metrics-task-package.tgz
done

tar xf wmt19-metrics-task-package.tgz
tar xf wmt18-metrics-task-package.tgz
# wmt17 doesnt have top level dir inside archive
tar xf wmt17-metrics-task-package.tgz -C wmt17-metrics-task-package


# Step 2: Download submissions 
cd $submissions
wget http://data.statmt.org/wmt19/translation-task/wmt19-submitted-data-v3.tgz
wget http://data.statmt.org/wmt18/translation-task/wmt18-submitted-data-v1.0.1.tgz
wget http://data.statmt.org/wmt17/translation-task/wmt17-submitted-data-v1.0.tgz
# Extract
for i in *.tgz; do tar xf $i ; done

```


