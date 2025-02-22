import CPUSummary
# Increasing the number of threads must be done before importing Octavian
if Threads.nthreads() > 1 && Sys.CPU_THREADS > 1 && CPUSummary.num_cores() == 1
    CPUSummary.num_cores() = CPUSummary.static(2)
end

import Octavian

import Aqua
import BenchmarkTools
import ForwardDiff
import InteractiveUtils
import LinearAlgebra
import LoopVectorization
import Random
import Test
import VectorizationBase

using Test: @testset, @test, @test_throws, @inferred

include("test_suite_preamble.jl")

@info("VectorizationBase.num_cores() is $(VectorizationBase.num_cores())")
@info("Octavian.OCTAVIAN_NUM_TASKS[] is $(Octavian.OCTAVIAN_NUM_TASKS[]) tasks")

Random.seed!(123)
Octavian.debug() = true

include("block_sizes.jl")
include("init.jl")
include("integer_division.jl")
include("macrokernels.jl")
include("_matmul.jl")
coverage || include("matmul_main.jl")
include("matmul_coverage.jl")
include("utils.jl")
if sizeof(Int) >= 8 || !Sys.iswindows()
  include("forward_diff.jl")
end

include("aqua.jl") # run the Aqua.jl tests last
