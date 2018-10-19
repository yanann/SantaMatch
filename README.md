# SantaMatch
Entry to Kaggle's Santa Match Competition in 2017: https://www.kaggle.com/c/santa-gift-matching

## Problem
Per Kaggle's challenge description: In this playground competition, you’re challenged to build a toy matching algorithm that 
maximizes happiness by pairing kids with toys they want. In the dataset, each kid has 10 preferences for their gift (from 1000) 
and Santa has 1000 preferred kids for every gift available. What makes this extra difficult is that 0.4% of the kids are twins, and by their parents’ request, require the same gift.

## Overview of Approach

1. We calculated the Happiness Score of all possible combinations of gift to child (happiness_matrix_gen file). 
This information was stored as a matrix in a csv file.

2. We next allocated gift to child based on optimized Happiness Score using the matrix (HMatrix_Optimizer). 
We first allocated gifts to triplets and twins since they had the highest combined scores

3. Then, we allocated to the remaining children who had a Happiness Score above 0

4. For the remaining children with a Happiness Score of 0, we randomly assigned them to a gift

## Results

We achieved 85% match rate with this algorithm. We had high scores on the child happiness dimension but low scores on the Santa/gift opmitization dimension

If I could redo the challenge, I would explore prioritizing the gift score first vs. using the mixed Happiness Score

