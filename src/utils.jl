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
    remove_small_yields(data, threshold=0.005)

Removes the smallest values from `data` whose cumulative yield is less than `threshold`.
"""
function remove_small_yields(data::Vector{<:Real}, threshold::Real = 0.005)
    perm = sortperm(data)
    sorted_data = data[perm]
    yield = cumsum(sorted_data) / sum(sorted_data)
    threshold_index = findfirst(x -> x > threshold, yield)
    indices = perm[threshold_index:length(data)]
    data[sort(indices)]
end
