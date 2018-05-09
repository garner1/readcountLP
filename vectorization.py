
# coding: utf-8

# Given a bam file containing unique mapped reads, we build a statistics taking into account the frequency of co-occurrences of each read locations. In computational linguistic terminology, for each chromosome, the location is the word and the document can be a given genomic region (entire chromosome, the genome, or a bin).  

import sys
import csv
import numpy as np
import pandas as pd
import os.path
import pickle
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt
import gensim, logging
from os import listdir
from os.path import isfile, join
import sklearn
from sklearn import datasets
from sklearn.feature_extraction.text import CountVectorizer
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

filename = sys.argv[1]          # chr#.tsv file
rank = int(sys.argv[2])              # rank of the SVD

# We build a document-term matrix from chromosomes data:
vectorizer = CountVectorizer(min_df=1) # set the min numb of times a word can occur
corpus = open(filename)
dtm = vectorizer.fit_transform(corpus) # get document-term matrix         
vocab = vectorizer.get_feature_names() # a list                                              

# Since the word co-occurrence matrix is by definition W=D^T*D, from the singular value decomposition of D=USV^T it follows W=D^T*D=VSU^T*USV^T=V*S^2*V^T. Since SVD of W is computationally expensive (even memory wise 128G of RAM are not enough) it is necessary to perform SVD on D.

from scipy.sparse.linalg import svds, eigs

u, s, vt = svds(dtm.asfptype(), k=rank)

np.save(filename + '_u', u)
np.save(filename + '_s', s)
np.save(filename + '_vt', vt)


