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

# Plot all benchmarks using log-x and log-y scales.
plotAllBenchmarks = function (bs)
{
    p = ggplot(bs, aes(x=size, y=mflops, color=libname)) + facet_grid(arch ~ benchmark)
    p + geom_line(aes(linetype=libname)) + scale_x_log10() + scale_y_log10()
}

# Plot a subset of benchmarks using log-x and log-y scales.
plotBenchmarks = function (bs)
{
    # Select a subset of benchmarks and libraries.
    b = bs[bs$benchmark %in% c("aat","atv","matrix_matrix","matrix_vector") &
           !bs$libname %in% c("eigen2","blitz"),]
    p = ggplot(b, aes(x=size, y=mflops, color=libname)) + facet_grid(arch ~ benchmark)
    p + geom_line() + scale_x_log10() + scale_y_log10()
}

# Plot a subset of benchmarks using linear x and y scales constraining size to
# less or equeal to 100.
plotSmallSizeBenchmarks = function (bs)
{
    # Select a subset of benchmarks and libraries.
    b = bs[bs$benchmark %in% c("aat","atv","matrix_matrix","matrix_vector") &
           !bs$libname %in% c("eigen2","blitz") &
           bs$size <= 100,]
    p = ggplot(b, aes(x=size, y=mflops, color=libname)) + facet_grid(arch ~ benchmark)
    p + geom_line()
}
