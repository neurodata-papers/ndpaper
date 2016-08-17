#!/usr/bin/env python

import sys
import numpy as np


truth_file = sys.argv[1]
test_file = sys.argv[2]


d = []
import csv
with open(test_file, 'rU') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
        #print ', '.join(row)
        d.append(row)
d = np.asarray(d,'int')
d = d[:,1]

data = np.load(truth_file)
tvec = data['tvec']

t = np.asarray(tvec[:,2],'int')
tdata = np.load(truth_file)

print('***********************************************************************')
print('Test Run: ' + str(data['name']))
print('Test Description: ' + str(data['description']))
print('Accuracy: '+ str(1.0*np.sum(t==d)/len(d)*100) + '%')
print('Total Samples: ' + str(len(d)))
print('True Positives: ' + str(np.sum((t==d) & (d==1))))
print('True Negatives: ' + str(np.sum((t==d) & (d==0))))
print('False Positives: ' + str(np.sum((t!=d) & (t==0))))
print('False Negatives: ' + str(np.sum((t!=d) & (t==1))))
print('***********************************************************************')
