using Test
using CalculatedABC

using DelimitedFiles
using Random, Distributions
Random.seed!(123)

include("test_curve.jl")
include("test_analysis.jl")
include("test_gini.jl")
