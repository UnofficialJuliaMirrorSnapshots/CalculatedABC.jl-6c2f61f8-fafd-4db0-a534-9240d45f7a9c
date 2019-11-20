@testset "Curve struct" begin
@testset "Uniformly distributed values" begin
    n = 20
    data = rand(Uniform(0,10), n)
    curve = CalculatedABC.ABCcurve(data)
    @test curve.effort == 0:0.05:1.0
    expected_yield = [0,
                      0.10223370412290836,
                      0.19630374973228518,
                      0.2798337861487627,
                      0.35309289814499817,
                      0.4251124119444249,
                      0.49223359866263033,
                      0.5559340313195282,
                      0.6192318028485928,
                      0.6706485917196718,
                      0.7210686469145637,
                      0.7696104643520768,
                      0.812596101423477,
                      0.8466456273448749,
                      0.8777009051387628,
                      0.9076823618805581,
                      0.9368834040175215,
                      0.9647084964342312,
                      0.9824989229044542,
                      0.994333140487581,
                      1.0000000000000002]
    @test isapprox(curve.yield, expected_yield)
end

@testset "Exponentially distributed values" begin
    n = 20
    data = rand(Exponential(1), n)
    curve = CalculatedABC.ABCcurve(data)
    @test curve.effort == 0:0.05:1.0
    expected_yield = [0.0,
                      0.1559704817922999,
                      0.259107787045309,
                      0.36017085915674457,
                      0.4567531613173713,
                      0.530483819367366,
                      0.5905820392527759,
                      0.6503414525690904,
                      0.6912925133668514,
                      0.7318440937106174,
                      0.7704643555492486,
                      0.8031964684921609,
                      0.8353247928350085,
                      0.8670259991394021,
                      0.8976554662905372,
                      0.9212877248856802,
                      0.9431001183934831,
                      0.964704167187443,
                      0.9810003669812493,
                      0.9911110632975999,
                      1.0]
    @test isapprox(curve.yield, expected_yield)
end

@testset "SwissInhabitants data" begin
    data = readdlm("swissinhabitants")[:,1]
    curve = CalculatedABC.ABCcurve(data)
    @test curve.effort == 0:0.0003453038674033149:1.0
    expected_yield = readdlm("expected_yield")[:,1]
    @test isapprox(curve.yield, expected_yield)
end
end
