Base.isapprox(x::Tuple, y::Tuple; kws...) = isapprox(collect(x), collect(y); kws...)

@testset "Analysis struct" begin
@testset "Uniformly distributed values" begin
    n = 20
    data = rand(Uniform(0,10), n)
    curve = CalculatedABC.ABCcurve(data)

    analysis1 = CalculatedABC.ABCanalysis(curve)
    @test isapprox(analysis1.pareto,      (0.4, 0.6192318028485929))
    @test isapprox(analysis1.break_even,  (0.5, 0.7210686469145638))
    @test isapprox(analysis1.demark_AB,   (0.4, 0.6192318028485929))
    @test isapprox(analysis1.submarginal, (0.6, 0.8125961014234772))

    analysis2 = CalculatedABC.ABCanalysis(data)
    @test isapprox(analysis2.pareto,      (0.4, 0.6192318028485929))
    @test isapprox(analysis2.break_even,  (0.5, 0.7210686469145638))
    @test isapprox(analysis2.demark_AB,   (0.4, 0.6192318028485929))
    @test isapprox(analysis2.submarginal, (0.6, 0.8125961014234772))
    @test analysis2.a_indices == [2, 13, 1, 3, 6, 14, 7, 19]
    @test analysis2.b_indices == [12, 16, 18, 4]
    @test analysis2.c_indices == [5, 15, 17, 9, 20, 11, 10, 8]
end

@testset "Exponentially distributed values" begin
    n = 20
    data = rand(Exponential(1), n)
    curve = CalculatedABC.ABCcurve(data)

    analysis1 = CalculatedABC.ABCanalysis(curve)
    @test isapprox(analysis1.pareto,      (0.35, 0.6503414525690906))
    @test isapprox(analysis1.break_even,  (0.35, 0.6503414525690906))
    @test isapprox(analysis1.demark_AB,   (0.35, 0.6503414525690906))
    @test isapprox(analysis1.submarginal, (0.5, 0.7704643555492489))

    analysis2 = CalculatedABC.ABCanalysis(data)
    @test isapprox(analysis2.pareto,      (0.35, 0.6503414525690906))
    @test isapprox(analysis2.break_even,  (0.35, 0.6503414525690906))
    @test isapprox(analysis2.demark_AB,   (0.35, 0.6503414525690906))
    @test isapprox(analysis2.submarginal, (0.5, 0.7704643555492489))
    @test analysis2.a_indices == [2, 19, 13, 20, 6, 4, 5]
    @test analysis2.b_indices == [15, 3, 12]
    @test analysis2.c_indices == [16, 7, 17, 9, 11, 14, 18, 8, 1, 10]
end

@testset "SwissInhabitants data" begin
    data = readdlm("swissinhabitants")[:,1]
    curve = CalculatedABC.ABCcurve(data)

    analysis1 = CalculatedABC.ABCanalysis(curve)
    @test isapprox(analysis1.pareto,      (0.25379834254143646, 0.7219586074342286))
    @test isapprox(analysis1.break_even,  (0.22168508287292818, 0.6913764432243525))
    @test isapprox(analysis1.demark_AB,   (0.22168508287292818, 0.6913764432243525))
    @test isapprox(analysis1.submarginal, (0.3715469613259669, 0.810278191608252))

    analysis2 = CalculatedABC.ABCanalysis(data)
    @test isapprox(analysis2.pareto,      (0.25379834254143646, 0.7219586074342286))
    @test isapprox(analysis2.break_even,  (0.22168508287292818, 0.6913764432243525))
    @test isapprox(analysis2.demark_AB,   (0.22168508287292818, 0.6913764432243525))
    @test isapprox(analysis2.submarginal, (0.3715469613259669, 0.810278191608252))
    # too many to test directly
    @test (analysis2.a_indices |> length) == 642
    @test (analysis2.b_indices |> length) == 434
    @test (analysis2.c_indices |> length) == 1820
    @test minimum(data[analysis2.a_indices]) >= maximum(data[analysis2.b_indices])
    @test minimum(data[analysis2.b_indices]) >= maximum(data[analysis2.c_indices])
end
end
