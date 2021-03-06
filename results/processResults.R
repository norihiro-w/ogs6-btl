require('ggplot2')
require('plyr')

readBenchmark = function (filename)
{
	df = read.table(
		file = filename,
		header = FALSE,
		col.names = c("size", "mflops"))

	patt = "([^\\/]*)\\/bench_([0-9a-z_]*)_(.*)\\.dat"
	df$arch = factor(gsub(patt, "\\1", filename))
	df$benchmark = factor(gsub(patt, "\\2", filename))
	df$libname = factor(gsub(patt, "\\3", filename))

	return(df)
}

createTable = function (pathname)
{
	files = list.files(
		path=pathname,
		pattern="bench.*.dat",
		recursive=TRUE)
	rbind.fill(lapply(files, readBenchmark))
}

# For duplicate entries except the mflops column select only those with maximum
# mflops.
selectMaxMflops = function (df)
{
    ddply(df, c(names(df)[names(df)!="mflops"]),
            function(x)
            {
                x[which.max(x$mflops),]
            }
         )
}

#
# Specialized plotting routines using ggplot2
#

benchmarkAes = aes(x=size, y=mflops, color=libname)
benchmarkGrid = facet_grid(arch ~ benchmark, scales = "free_y")

allBenchmarksGraph = function (bs)
{
    ggplot(bs, benchmarkAes) + benchmarkGrid
}

selectedBenchmarksGraph = function (bs)
{
    ggplot(
           bs[
              bs$benchmark %in% c("aat","atv","matrix_matrix","matrix_vector")
              & !bs$libname %in% c("eigen2","blitz"),
              ],
           benchmarkAes
          ) + benchmarkGrid
}

# Plot all benchmarks using log-x and log-y scales by default.
plotAllBenchmarks = function (bs, logx = TRUE, logy = TRUE)
{
    allBenchmarksGraph(bs) +
        geom_line(aes(linetype=libname)) +
        (if (logx) { scale_x_log10() }) +
        (if (logy) { scale_y_log10() })
}

# Plot a subset of benchmarks using log-x and log-y scales by default.
plotBenchmarks = function (bs, logx = TRUE, logy = TRUE)
{
    # Select a subset of benchmarks and libraries.
    selectedBenchmarksGraph(bs) +
        geom_line() +
        (if (logx) { scale_x_log10() }) +
        (if (logy) { scale_y_log10() })
}

# Plot a subset of benchmarks constraining size to less or equeal to 100.
# Default x and y scales are linear.
plotSmallSizeBenchmarks = function (bs, x_max=100, logx = FALSE, logy = FALSE)
{
    # Select a subset of benchmarks and libraries.
    selectedBenchmarksGraph(bs[bs$size <= x_max,]) +
        geom_line() +
        (if (logx) { scale_x_log10() }) +
        (if (logy) { scale_y_log10() })
}

plotToPDF = function (bs)
{
    pdf("all_intel.pdf", paper="a4r", width=11.7, height=8.3)
    print(
          ggplot(bs[bs$arch == "intel_core_i5-2430M@2.4GHz" & bs$size <= 3000,],
                 benchmarkAes) +
          facet_wrap(~benchmark, 3) +
          geom_line() +
          scale_x_log10() +
          scale_y_log10()
         )
    dev.off()

    pdf("all_amd.pdf", paper="a4r", width=11.7, height=8.3)
    print(
          ggplot(bs[bs$arch == "amd_quad-core_opteron_8384@0.8GHz" & bs$size <= 3000,],
                 benchmarkAes) +
          facet_wrap(~benchmark, 3) +
          geom_line() +
          scale_x_log10() +
          scale_y_log10()
         )
    dev.off()

    pdf("selected.pdf", paper="a4r", width=11.7, height=8.3)
    print(plotBenchmarks(bs[bs$size <= 3000,]))
    dev.off()

    pdf("small_size.pdf", paper="a4r", width=11.7, height=8.3)
    print(plotSmallSizeBenchmarks(bs[bs$size <= 3000,]))
    dev.off()
}
