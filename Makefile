ifeq ($(OS),Windows_NT)
SQLITE = sqlite3.exe
else
SQLITE = sqlite3
endif

.PHONY: sqlite listings clean clean2 clean3
default: LockChartSolving.pdf

TIKZ_PLOTS += BaselineSagSkew.tex
TIKZ_PLOTS += SagExactSkew.tex
TIKZ_PLOTS += GreedyExactSkew.tex
TIKZ_PLOTS += SagGreedySkew.tex
TIKZ_PLOTS += N102.tex

TIKZ_STATS += SagExactSkew.txt
TIKZ_STATS += BaselineSagSkew.txt
TIKZ_STATS += SagGreedySkew.txt
TIKZ_STATS += GreedyExactSkew.txt

IPE_GRAPHICS += CompressedLockChart.pdf
IPE_GRAPHICS += DiagonalLockChart.pdf
IPE_GRAPHICS += EigenExtension.pdf
IPE_GRAPHICS += IndependenceGraph.pdf
IPE_GRAPHICS += MiniLockChart.pdf
IPE_GRAPHICS += MiniMaximized.pdf
IPE_GRAPHICS += TumblerLock.pdf
IPE_GRAPHICS += TumblerLockK2D.pdf
IPE_GRAPHICS += MultiLevelLockChart.pdf
IPE_GRAPHICS += ConstraintHierarchy.pdf
IPE_GRAPHICS += KeyToDiff.pdf
IPE_GRAPHICS += MeltedLockChart.pdf
IPE_GRAPHICS += MeltedProfileMap.pdf
IPE_GRAPHICS += LockChartHierarchy.pdf
IPE_GRAPHICS += LockChartHierarchyColored.pdf
IPE_GRAPHICS += IndependentKeysLockChart.pdf
IPE_GRAPHICS += CentralLockLockChart.pdf
IPE_GRAPHICS += UpperBoundIllustration.pdf
IPE_GRAPHICS += PinTumblerLock.pdf

STATISTICS += DiagonalStats.tex
STATISTICS += SatDiagAbs.tex
STATISTICS += SatDiagRel.tex
STATISTICS += DiagonalMaximum.tex
STATISTICS += DiagonalRatio.tex
STATISTICS += MinGvlSuccess.tex
STATISTICS += MinGvlSynthetic.tex
STATISTICS += MinGvlAbsoluteFirstMN.tex
STATISTICS += MinGvlAbsoluteFirstD.tex
STATISTICS += MinGvlPairwiseFirstM.tex
STATISTICS += MinGvlPairwiseFirstD.tex
STATISTICS += MinGvlAbsoluteEnteringsMN.tex
STATISTICS += MinGvlAbsoluteEnteringsD.tex
STATISTICS += MinGvlAbsoluteOptimMN.tex


MIN_GVL_STAT += MinGvlDAllD.txt
MIN_GVL_STAT += MinGvlDImpl10.txt
MIN_GVL_STAT += MinGvlDImpl15.txt
MIN_GVL_STAT += MinGvlDImpl30.txt
MIN_GVL_STAT += MinGvlDImpl50.txt
MIN_GVL_STAT += MinGvlDLawer.txt
MIN_GVL_STAT += MinGvlDSAT2.txt
MIN_GVL_STAT += MinGvlDSAT4.txt
MIN_GVL_STAT += MinGvlMAllD.txt
MIN_GVL_STAT += MinGvlMImpl10.txt
MIN_GVL_STAT += MinGvlMImpl15.txt
MIN_GVL_STAT += MinGvlMImpl30.txt
MIN_GVL_STAT += MinGvlMImpl50.txt
MIN_GVL_STAT += MinGvlMLawer.txt
MIN_GVL_STAT += MinGvlMSAT2.txt
MIN_GVL_STAT += MinGvlMSAT4.txt
MIN_GVL_STAT += MinGvlNAllD.txt
MIN_GVL_STAT += MinGvlNImpl10.txt
MIN_GVL_STAT += MinGvlNImpl15.txt
MIN_GVL_STAT += MinGvlNImpl30.txt
MIN_GVL_STAT += MinGvlNImpl50.txt
MIN_GVL_STAT += MinGvlNLawer.txt
MIN_GVL_STAT += MinGvlNSAT2.txt
MIN_GVL_STAT += MinGvlNSAT4.txt

LUA_FILES += gnuplot-lua-tikz.sty
LUA_FILES += gnuplot-lua-tikz.tex
LUA_FILES += gnuplot-lua-tikz-common.tex

LISTINGS += listings-acm.prf
LISTINGS += listings-bash.prf
LISTINGS += listings-fortran.prf
LISTINGS += listings-lua.prf
LISTINGS += listings-python.prf
LISTINGS += listings.sty
LISTINGS += lstdoc.sty
LISTINGS += lstlang1.sty
LISTINGS += lstlang2.sty
LISTINGS += lstlang3.sty
LISTINGS += lstmisc.sty

# The final PDF
LockChartSolving.pdf: LockChartSolving.tex LockChartSolving.bbl LockChartSolving1-blx.bbl LockChartSolving2-blx.bbl LockChartSolving3-blx.bbl
	xelatex -shell-escape $<
	xelatex -shell-escape $<
%.bbl: %.aux
	bibtex8 $<
LockChartSolving.aux: LockChartSolving.tex
	rm -f LockChartSolving.aux
	xelatex -shell-escape $<
LockChartSolving.tex: LockChartSolving.lyx\
	$(LUA_FILES) $(LISTINGS) $(TIKZ_PLOTS) $(TIKZ_STATS)\
	$(IPE_GRAPHICS) $(STATISTICS) $(MIN_GVL_STAT)\
	EigenHeatCont.tikz
	lyx $< -E xetex $@

# Images produced by matlab-tikz 
ifeq ($(OS),Windows_NT)
EigenHeatCont.tikz: EigenHeatMap.m
	matlab /nodisplay /nosplash /r "addpath('matlab2tikz/src');EigenHeatMap;quit"
else
EigenHeatCont.tikz: EigenHeatMap.m
	matlab -nodisplay -nosplash -r "addpath('matlab2tikz/src');EigenHeatMap;quit"
endif

# All IPE graphics produce a PDF 
%.pdf: %.ipe
	ipetoipe -pdf $< $@

# Graphs from GNUplot need support files
$(LUA_FILES): gnuplot-tikz.lua
	lua $< style
	rm -f t-gnuplot-lua-tikz.tex

# Update listings TeX package on Ubuntu 16.04
$(LISTINGS):
	rm -rf listings
	unzip listings.zip
	$(MAKE) -C listings
	cp listings/*.sty listings/*.prf ./

# The main SQL database
Diagonal.sqlite: FeedTheSQL.sh PolyDiag.csv SatDiag.csv MinGvlPredefined.csv MinGvlSynthetic.csv SQLite/$(SQLITE)
	bash $<
SQLite/$(SQLITE):
	$(MAKE) -C SQLite
# Some statistical properties computed by BASH (slow!!!)
DiagonalStats.tex: DiagonalStats.sh Diagonal.sqlite
	bash $< $* > $@
# Tables and statistics
SatDiag%.tex: SatDiag%.sh Diagonal.sqlite
	bash $< > $@
DiagonalMaximum.tex: DiagonalMaximum.sh Diagonal.sqlite
	bash $< > $@
DiagonalRatio.tex: DiagonalRatio.sh Diagonal.sqlite
	bash $< > $@
$(MIN_GVL_STAT): MinGvlStats.sh Diagonal.sqlite
	bash $<
MinGvl%.tex: MinGvl%.sh MinGvlLib.sh Diagonal.sqlite
	bash $< > $@
MinGvlAbsolute%.tex: MinGvlAbsolute.sh MinGvlLib.sh Diagonal.sqlite
	bash $< $* > $@
MinGvlPairwise%.tex: MinGvlPairwise.sh MinGvlLib.sh Diagonal.sqlite
	bash $< $* > $@

# Plot various scatterplots
%.tex: %.plt %.dat
	gnuplot $<
BaselineSag%.dat: DiagonalBenchmark.csv CSVtoGNUplot.sh
	bash CSVtoGNUplot.sh $* 17,20 < $< > $@
SagExact%.dat: DiagonalBenchmark.csv CSVtoGNUplot.sh
	bash CSVtoGNUplot.sh $* 20,26 < $< > $@
GreedyExact%.dat: DiagonalBenchmark.csv CSVtoGNUplot.sh
	bash CSVtoGNUplot.sh $* 23,26 < $< > $@
SagGreedy%.dat: DiagonalBenchmark.csv CSVtoGNUplot.sh
	bash CSVtoGNUplot.sh $* 20,23 < $< > $@
# and histograms
GreedyExactHist.tex: GreedyExactHist.plt GreedyExactSkew.dat
	gnuplot $<
# statistics from plots
%.txt: %.plt %.dat
	gnuplot $<

# Clean files
clean:
	rm -f *.log *.aux *.bbl *.blg *.out *.synctex.gz *.auxlock *.lyx.emergency *~
	rm -f *.toc *.idx *-blx.bib LockChartSolving.lo* *.nlo LockChartSolving.run.xml
	rm -f LockChartSolving.tex LockChartSolving-figure*
	rm -f Diagonal.sqlite $(STATISTICS) $(MIN_GVL_STAT)
	rm -f $(TIKZ_PLOTS) $(TIKZ_STATS)
	rm -rf listings $(LISTINGS)
	$(MAKE) -C SQLite clean
clean2: clean
	rm -f $(LUA_FILES) $(IPE_GRAPHICS)
	rm -f LockChartSolving-figure*
clean3: clean2
	rm -f EigenHeatCont.tikz LockChartSolving.pdf
