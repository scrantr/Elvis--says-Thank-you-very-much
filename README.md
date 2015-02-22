---
title: "README.md"
author: "Richard Scranton"
date: "02/21/2015"
---

Contents of This Repository
---------------------------

This is an R script and its accompanying documentation (a Codebook and Readme file) to allow a researcher to repeat a data scrubbing process with minimal fuss.  It is submitted in partial fulfillment of the requirements of the MOOC Getting and Cleaning Data.

The R program summarizes some acceleration and shock data collected by repurposing the sensors in a commodity Samsung smart phone.  The codebook attempts to describe the output of the R program and the steps performed to arrive at that output.

How the Data is Processed
-------------------------

Raw data was distributed divided into training data and test data.  Training and Test data subsets were merged prior to other processing.   The whole was then written to a work object for further consideration.

Test and Training identity markers for the subjects was then merged, taking care to preserve overall ordering.  Test and Training data for activities was then merged, and subject/activity combined to produce an index.

Mean() and Std-dev() observations were excerpted from the whole and written to another work object.  Original obscure column descriptions were augmented using hints included with the raw data to make them more intuitively descriptive.  Activity ordinals were replaced with textual descriptions, also using information included with the source data.

After being grouped by test subject (major) and activity (minor) order, observations, having already been summarized to mean() and std-dev() values for each of the 6 activities, were extracted (the supplied raw inertial sensor observations were not used) and a mean() was calculated for each of the 6 activities, for each of the 66 collected data points, for each test subject.

The completed extract was written to disk for distribution, and any remaining memory-resident work objects were released.  The scripted processing can be repeated by bursting the .ZIP archive on disk, allowing it to create nested directories as required.  Then place the R script "run_analysis.R" in the top directory of the .ZIP hierarchy.  Execute the R script to create the extract file, **X_mean_std_avg.txt.**

`$Id: README.md,v 1.1 2015/02/22 06:09:58 richard Exp richard $`
