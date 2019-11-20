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

"""
    gini_coeff(data::Vector{<:Real})

Calculates the Gini coefficient for the given data.
"""
function gini_coeff(data::Vector{<:Real})
    @assert all(x->x >= 0, data)
    y = sort(data)
    n = length(y)
    # cargo-culted from Wikipedia
    2 * sum([i * y[i] for i in 1:n]) / (n * sum(y)) - (n + 1) / n
end

"""
    gini_coeff(curve::ABCcurve)

Calculates the Gini coefficient for the given ABC curve.
"""
function gini_coeff(curve::ABCcurve)
    yield = curve.yield
    step::Float64 = curve.effort.step
    # simplified trapezoidal rule. The '- 1/2 * 2' is for the gini coefficient
    # this only works for equidistant steps
    ((sum(yield) - yield[end] / 2) * step - 1/2) * 2
end

