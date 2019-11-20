# ABC Analysis
## Curve
The basis for the ABC analysis is the `ABCcurve` struct. This curve is similar to the [Lorenz curve](https://en.wikipedia.org/wiki/Lorenz_curve) and represents the *effort* of an element and its its relative cumulative *yield* in decreasing order of gain.
```@docs
ABCcurve
```

## Analysis
An `ABCanalysis` struct takes either a data array or a previously calculated `ABCcurve`. It determines three points important for further analysis, the *Pareto point*, *Break Even point* and the *Submarginal point*. If you provide the raw data, it also gives back the indices of the elements in the sets *A*, *B* and *C*. For both curve and data input there are also convenience constructors `ABCanalysis`. 

```@docs
ABCanalysis4Curve
ABCanalysis4Data
```
