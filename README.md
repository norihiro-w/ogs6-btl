# ogs6-btl

OGS6 matrix benchmarking copy from Eigen3-BTL


## Compilation
It is better to compile the code outside the source tree. In the `ogs6-btl/`
directory create build directory
```sh
mkdir build
cd build
```
Call cmake to prepare makefiles
```sh
cmake ../btl
```
And, finally, compile benchmarks executing
```sh
make
```

### Extra libraries
To create benchmarks for any of the interfaces present in `btl/libs/`
corresponding libraries has to be found in "usual" system directories like
`/usr/lib/`, or environment variables for specific library location has to be
provided to cmake. To create benchmarks for ATLAS libraries installed in
`$HOME/local/lib/`, for example, call cmake as:
```sh
ATLASDIR=$HOME/local/lib cmake ../btl
```

## Running benchmarks
To run the benchmarks use ctest: In the `build/` directory
```sh
ctest -V
```

See further documentation in btl's [README](btl/README) file in the
`ogs6-btl/btl/` directory.


## Postprocessing
After the benchmarks are done the results are written into the `build/` directory
in `libs/<library interface>/bench_.*.dat` files.
In the `results/` directory create another directory corresponding to your cpu
(on linux you can find out cpu information with `cat /proc/cpuinfo`) like
[intel_core_i5-2430M@2.4GHz/](results/intel_core_i5-2430M\@2.4GHz/). Copy the
above `bench_.*.dat` files there
```sh
cp build/libs/*/bench_*.dat results/<your_cpuinfo>/
```

## Visualization
There is an R-script in `results/` directory, which reads all benchmarks into a
data frame. It provides simple plotting functions using the
[ggplot2](ggplot2.org) package for visualisation.

A typical R-session could be:
```R
source('processResults.R')  # Assuming you are in the results/ directory.
bs = createTable(".")       # Use different path pointing to the results.
b = selectMaxMflops(bb)     # Remove duplicate entries.

# Use one of plotXXX functions for plotting, e.g.:
plotAllBenchmarks(b)
plotBenchmarks(b, logy = TRUE)
plotSmallSizeBenchmarks(b)
```
