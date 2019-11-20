@testset "Gini coefficient" begin
@testset "random data" begin
    n = 20
    data = rand(n)
    curve = CalculatedABC.ABCcurve(data)

    answer = 0.3008352645541903
    @test isapprox(CalculatedABC.gini_coeff(data), answer)
    @test isapprox(CalculatedABC.gini_coeff(curve), answer)
end

@testset "SwissInhabitants data" begin
    data = readdlm("swissinhabitants")[:,1]
    curve = CalculatedABC.ABCcurve(data)

    answer = 0.6294073840902157
    @test isapprox(CalculatedABC.gini_coeff(data), answer)
    @test isapprox(CalculatedABC.gini_coeff(curve), answer)
end
end
