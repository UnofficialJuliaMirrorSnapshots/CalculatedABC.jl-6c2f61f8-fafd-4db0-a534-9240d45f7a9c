# Copyright 2019 Tobias Frilling
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

abstract type ABCanalysis end

"""
    ABCanalysis4Curve(curve::ABCcurve) <: ABCanalysis

Calculate an ABC analysis for the given curve.

# Fields
- `pareto`: Nearest point to a theoretically ideal Break Even point.
- `break_even`: Point on the curve where the gain (``dABC``) is 1.
- `demark_AB` Point on the curve at which most of the yield is already obtained; the smaller of the Pareto and Break Even points. Demarkation between *A* and *B*.
- `submarginal`: Point on the curve after which the gain can be considered trivial. Demarkation between *B* and *C*.
- `curve`: The given curve. Used for plotting.
"""
struct ABCanalysis4Curve <: ABCanalysis
    pareto     ::Tuple{Float64, Float64}
    break_even ::Tuple{Float64, Float64}
    demark_AB  ::Tuple{Float64, Float64}
    submarginal::Tuple{Float64, Float64}
    curve::ABCcurve

    function ABCanalysis4Curve(curve::ABCcurve)
        # euclidean distance (without sqrt)
        dist(p1,p2) = (p1 .- p2).^2 |> sum
        zipped_curve = zip(curve.effort, curve.yield)
        # detemines the index of the closest point to p
        index_min_dist_point(p) = map(x -> dist(p,x), zipped_curve) |> argmin

        abc_ideal = (0,1)
        pareto_index = index_min_dist_point(abc_ideal)

        gradients = map(i->Interpolations.gradient(curve.interpolation, i)[1], curve.effort)
        break_even_index =  abs.(gradients .- 1) |> argmin

        demark_AB_index = min(pareto_index, break_even_index)

        break_even_ideal = (curve.effort[max(pareto_index, break_even_index)], 1)
        submarginal_index = index_min_dist_point(break_even_ideal)

        (effort, yield) = (curve.effort, curve.yield)
        point(indx) = (effort[indx], yield[indx])

        new(point(pareto_index),
            point(break_even_index),
            point(demark_AB_index),
            point(submarginal_index),
            curve)
    end
end

"""
    ABCanalysis(curve::ABCcurve)

Convenience function for `ABCanalysis4Curve(curve)`
"""
ABCanalysis(curve::ABCcurve) = ABCanalysis4Curve(curve)


"""
    ABCanalysis4Data(data::Vector{<:Real}) <: ABCanalysis

Calculate an ABC analysis for the given data.

# Fields
Extends `ABCanalysis4Curve` with:
- `a_indices`: Indices of elements in the *A* set.
- `b_indices`: Indices of elements in the *B* set.
- `c_indices`: Indices of elements in the *C* set.
"""
struct ABCanalysis4Data <: ABCanalysis
    pareto     ::Tuple{Float64, Float64}
    break_even ::Tuple{Float64, Float64}
    demark_AB  ::Tuple{Float64, Float64}
    submarginal::Tuple{Float64, Float64}

    a_indices::Vector{Int64}
    b_indices::Vector{Int64}
    c_indices::Vector{Int64}

    curve::ABCcurve

    function ABCanalysis4Data(data::Vector{<:Real})
        curve = ABCcurve(data)
        ana = ABCanalysis4Curve(curve)
        perm = sortperm(data, rev=true)

        # have to subtract 1 because we added (0,0) to the curve data
        point2index(p) = findfirst(isequal(p[1]), curve.effort) - 1
        threshold_a = point2index(ana.demark_AB)
        threshold_b = point2index(ana.submarginal)

        new(ana.pareto,
            ana.break_even,
            ana.demark_AB,
            ana.submarginal,
            perm[1:threshold_a],
            perm[threshold_a+1:threshold_b],
            perm[threshold_b+1:end],
            curve)
    end
end

"""
    ABCanalysis(data::Vector{<:Real})

Convenience function for `ABCanalysis4Data(data)`
"""
ABCanalysis(data::Vector{<:Real}) = ABCanalysis4Data(data)


# text representation for REPL or Jupyter
function show_points(io::IO, analysis::ABCanalysis)
    println(io, "Pareto:          ", analysis.pareto)
    println(io, "Break Even:      ", analysis.break_even)
    println(io, "Demarkation A|B: ", analysis.demark_AB)
    print(io,   "Submarginal:     ", analysis.submarginal)
end

function Base.show(io::IO, ::MIME"text/plain", analysis::ABCanalysis)
    show_points(io, analysis)
end

function Base.show(io::IO, ::MIME"text/plain", analysis::ABCanalysis4Data)
    show_points(io, analysis)
    println(io)
    println(io, "A: $(analysis.a_indices |> length) elements")
    println(io, "B: $(analysis.b_indices |> length) elements")
    print(io, "C: $(analysis.c_indices |> length) elements")
end


# plotting
@recipe function f(ana::ABCanalysis; comparison=true, annotate=true)
    xlims --> (0,1)
    ylims --> (0,1)
    legend --> :bottomright
    ratio --> 1
    markersize --> 5

    if annotate
        # plot annotations
        fontsize = 8
        # these are the 'n = ???' in the plot
        a_size = findfirst(isequal(ana.demark_AB[1]), ana.curve.effort)
        b_size = findfirst(isequal(ana.submarginal[1]), ana.curve.effort) - a_size
        c_size = length(ana.curve.effort) - a_size - b_size

        # position for A and B is centred between set boundaries
        offset_y = 0.1
        a_xpos = ana.demark_AB[1] / 2
        b_xpos = ana.demark_AB[1] + (ana.submarginal[1] - ana.demark_AB[1])/2
        c_xpos = ana.submarginal[1] + 0.1

        annotations := [
                        # a_size - 1 because we added (0,0) in Curve
                        (a_xpos, offset_y, text("A\nn = $(a_size-1)", fontsize))
                        (b_xpos, offset_y, text("B\nn = $(b_size)", fontsize))
                        (c_xpos, offset_y, text("C\nn = $(c_size)", fontsize))
                       ]
    end

    @series begin
        comparison := comparison
        ana.curve
    end

    @series begin
        # set boundaries
        label := ""
        linecolor := :red
        seriestype := :path
        markershape := :none
        # path for the boundary lines. NaN starts a new line
        path = [
                0                  ana.demark_AB[2]
                ana.demark_AB[1]   ana.demark_AB[2]
                ana.demark_AB[1]   0
                NaN                NaN
                0                  ana.submarginal[2]
                ana.submarginal[1] ana.submarginal[2]
                ana.submarginal[1] 0
               ]
        path[:,1], path[:,2]
    end

    @series begin
        # marker for the analysis points
        label := ""
        seriestype := :scatter
        markercolors --> [:red, :green, :blue]
        [ana.break_even, ana.pareto, ana.submarginal]
    end
end
