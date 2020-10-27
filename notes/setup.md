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



# Step 3: Prepare WMT sys scores
cd $metrics
for f in $PWD/wmt*-metrics-task-package/results/combine-scores-sys-DA.py; do
 cd $(dirname $f) && pwd && python2 combine-scores-sys-DA.py
done




# Step 4: Collect all sys level scores to one dir

cd $root
mkdir wmt-sys-scores
cp $metrics/wmt*-metrics-task-package/results/out/DA-*-sys-nohy-scores.csv wmt-sys-scores 



# Step 5: Collect all submissions

cd $root
mkdir wmt-submissions/{references,sources,system-outputs}
for i in references sources system-outputs; do
  for j in submissions/wmt*-submitted-data/txt/$i; do
     cp -r $j/* wmt-submissions/$i;
  done
done
du -sh wmt-submissions 


# Step 6:: 2019 ENZH references are bad; fix them 


cat wmt-submissions/references/newstest2019-enzh-ref.zh | sed 's/([a-zA-Z\., ]*)//g; s/ [ ]*//g' > wmt-submissions/references/newstest2019-enzh-ref.zh.cln

```
------


