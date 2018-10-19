
# coding: utf-8

# In[2]:


# This Python 3 environment comes with many helpful analytics libraries installed
# It is defined by the kaggle/python docker image: https://github.com/kaggle/docker-python
# For example, here's several helpful packages to load in 

import numpy as np # linear algebra
import pandas as pd
from sklearn.utils.linear_assignment_ import linear_assignment
import math
from numba import jit

# Any results you write to the current directory are saved as output.


# In[3]:


#import datasets
wishList = pd.read_csv("child_wishlist_v2.csv",header=None).values
santaList = pd.read_csv("gift_goodkids_v2.csv",header=None).values

#constants for calc from average normalized happiness kernel
n_children = 1000000 # n children to give
n_gift_type = 1000 # n types of gifts available
ratio_gift_happiness = 2
ratio_child_happiness = 2
n_gift_pref = 100 # number of gifts a child ranks
n_child_pref = 1000 # number of children a gift ranks
twinMax = 45000 #maxID for twin
tripletMax = 5000 #maxID for triplet


# In[4]:


#examine dataset
print(wishList.shape)
print(santaList.shape)


# In[5]:


#record matching twin and triplets
tri_twinID = np.zeros((n_children,1), dtype=np.int64)
tri_twinID[0 : twinMax] = 1

wishList = np.append(wishList, tri_twinID, axis = 1)


# In[6]:


#add tag for goodKids
goodKids = np.unique(santaList)
print(goodKids.shape)

goodKid_tag = np.zeros((n_children,1), dtype=np.int64)
wishList_v2 = np.append(wishList, goodKid_tag, axis = 1)
wishList_v2[goodKids,n_gift_pref+1] = 1


# In[7]:


#trim list to just the good kids and then twins and triplets
mask = np.logical_or(wishList_v2[:,n_gift_pref]==1, wishList_v2[:,n_gift_pref+1]==1)
wishList_trim = wishList_v2[mask]

#verify trim wroked
print(wishList_trim.shape)


# In[8]:


#calculation for individual happiness score
def happyCalc(matrix, childID, giftID):
    #calc child happiness
    child_happiness = np.where(matrix[childID]==giftID)[0]
    if (len(child_happiness) == 0):
        tmp_child_happiness = -1
    else:
        tmp_child_happiness = (n_gift_pref - child_happiness[0])*2
            
    #calc gift happiness
    gift_happiness = np.where(matrix[giftID]==childID)[0]
    if (len(gift_happiness) == 0):
        tmp_gift_happiness = -1
    else:
        tmp_gift_happiness = (n_child_pref - gift_happiness[0])*2
        
    return float(tmp_child_happiness/(n_gift_pref*2) + tmp_gift_happiness/(n_child_pref*2))


# In[11]:
#calculate happiness for each gift
def happiness_matrix(matrix, x1, x2, y):
    costM = np.zeros(((x2-x1),y))
    #calc average happiness
    for i in range(x1, x2):
        for j in range(0, y):
            cost = happyCalc(matrix, i,j)
            costM[i,j] = cost
        if i%10000 == 0: print(i)
    return costM   

happiness_M = happiness_matrix(wishList, 0, n_children, n_gift_type)

#write to csv
np.savetxt("happinessMatrix.txt", happiness_M, delimiter=",")

