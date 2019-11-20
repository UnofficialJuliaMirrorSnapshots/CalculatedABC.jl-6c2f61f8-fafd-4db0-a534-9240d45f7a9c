# Gini coefficient
The [Gini coefficient](https://en.wikipedia.org/wiki/Gini_coefficient) is a single number aimed at measuring the degree of inequality in a distribution. It is usually defined mathematically based on the Lorenz curve. A Gini coefficient of zero expresses perfect equality, where all values are the same, whereas a coefficient of 1 expresses maximal inequality among values.

```@docs
gini_coeff(data::Vector{<:Real})
gini_coeff(curve::ABCcurve)
```
