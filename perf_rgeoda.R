# Usage:
# Rscript perf_rgeoda.R ./data/natregimes.shp HR60 999 brutal-force 1
# Rscript perf_rgeoda.R ./data/natregimes.shp HR60 999 lookup-table 8
#
library(rgeoda)
library(sf)
library(rbenchmark)
options(digits.secs = 6)
args = commandArgs(trailingOnly=TRUE)
file_path <- args[1]
variable_name <- args[2]
perms <- as.integer(args[3])
perm_method <- args[4]
cpu_threads <- as.integer(args[5])

dt <- st_read(file_path)
if (file_path=='./data/Chicago_parcels_points.shp') {
    if (cpu_threads==1) { 
        system.time(w <- knn_weights(dt, 10))
    } else {
        w <- knn_weights(dt, 10)
    }
} else {
    if (cpu_threads==1) { 
        tm0 <- system.time(w <- queen_weights(dt))
        tm0
    } else {
        w <- queen_weights(dt)
    }
}
args
# run the local_moran() 3 times 
tm <- system.time(lm<-local_moran(w, dt[variable_name], permutations=perms, permutation_method=perm_method, cpu_threads=cpu_threads))
tm
