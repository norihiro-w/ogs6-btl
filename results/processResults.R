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
