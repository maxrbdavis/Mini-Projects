# This mini-project is based on the K-Means exercise from 'R in Action'
# Go here for the original blog post and solutions
# http://www.r-bloggers.com/k-means-clustering-from-r-in-action/

# Exercise 0: Install these packages if you don't have them already

# 
install.packages(c("cluster", "rattle.data","NbClust"))

# Now load the data and look at the first few rows
data(wine, package="rattle.data")
head(wine)

# Exercise 1: Remove the first column from the data and scale
# it using the scale() function

df <- scale(wine[-1])
head(df)

# Now we'd like to cluster the data using K-Means. 
# How do we decide how many clusters to use if you don't know that already?
# We'll try two methods.

# Method 1: A plot of the total within-groups sums of squares against the 
# number of clusters in a K-means solution can be helpful. A bend in the 
# graph can suggest the appropriate number of clusters. 

wssplot <- function(data, nc=15, seed=1234){
	              wss <- (nrow(data)-1)*sum(apply(data,2,var))
               	      for (i in 2:nc){
		        set.seed(seed)
	                wss[i] <- sum(kmeans(data, centers=i)$withinss)}
	                
		      plot(1:nc, wss, type="b", xlab="Number of Clusters",
	                        ylab="Within groups sum of squares")
	   }

wssplot(df)

# Exercise 2:
#   * How many clusters does this method suggest? At 3 clusters the sum of squares within groups has dropped significantly from 2, and as clusters increase, 
#     we dont see as sharp a decline in the sum of squares within groups. 
#   * Why does this method work? What's the intuition behind it? It produces a datapoint for each number of cluster in the range,
#     showing the relationship between that number of clusters and the sum of squares within each group. A low within group sum would mean the clusters are close together,
#     therefore it is lowest in the highest number of clusters.
#   * Look at the code for wssplot() and figure out how it works
#      It creates the best distribution of clusters for each number of clusters specified. 

# Method 2: Use the NbClust library, which runs many experiments
# and gives a distribution of potential number of clusters.

library(NbClust)
set.seed(1234)
nc <- NbClust(df, min.nc=2, max.nc=15, method="kmeans")
barplot(table(nc$Best.n[1,]),
	          xlab="Number of Clusters", ylab="Number of Criteria",
		            main="Number of Clusters Chosen by 26 Criteria")


# Exercise 3: How many clusters does this method suggest?
# Looks like also 3.

# Exercise 4: Once you've picked the number of clusters, run k-means 
# using this number of clusters. Output the result of calling kmeans()
# into a variable fit.km
set.seed(1234)
fit.km <- kmeans(df, 3, nstart = 25)
fit.km$size
fit.km$centers

# Now we want to evaluate how well this clustering does.

# Exercise 5: using the table() function, show how the clusters in fit.km$clusters
# compares to the actual wine types in wine$Type. Would you consider this a good
# clustering? Roughly three equally sized clusters, I think thats a good result but we need to learn more.

ct.km <- table(wine$Type, fit.km$cluster)
ct.km

# Exercise 6:
# * Visualize these clusters using  function clusplot() from the cluster library
# * Would you consider this a good clustering?
library(cluster)
clusplot(pam(df,3))

# It seems to be a fairly good clustering. The clusters are mostly distinct, with only a small amount of crossover. 
