# CalculatedABC.jl

A Julia port of the [ABCanalysis R package](https://cran.r-project.org/web/packages/ABCanalysis/).

---

From the documentation of the R package:

> For a given data set, the package provides a novel method of computing
> precise limits to acquire subsets which are easily interpreted. Closely
> related to the Lorenz curve, the ABC curve visualizes the data by
> graphically representing the cumulative distribution function. Based on
> an ABC analysis the algorithm calculates, with the help of the ABC curve,
> the optimal limits by exploiting the mathematical properties pertaining
> to distribution of analyzed items. The data containing positive values is
> divided into three disjoint subsets A, B and C, with subset A comprising
> very profitable values, i.e. largest data values ("the important few"),
> subset B comprising values where the yield equals to the effort required
> to obtain it, and the subset C comprising of non-profitable values,
> i.e., the smallest data sets ("the trivial many").

### Installation

CalculatedABC.jl is registered in the official registry of general Julia packages.

To install the *development version* from a Julia REPL type `]` to enter Pkg REPL mode and run
```julia
pkg> add https://github.com/ckafi/CalculatedABC.jl
```

### License

CalculatedABC.jl is licensed under the Apache License v2.0.
For the full license text see [LICENSE](https://github.com/ckafi/CalculatedABC.jl/blob/master/LICENSE).

### Acknowledgments

This package is based on the paper [Computed ABC Analysis for Rational Selection of Most Informative Variables in Multivariate Data](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0129767) by Ultsch A, Lötsch J (2015).
