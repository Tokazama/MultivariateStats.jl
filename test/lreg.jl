using MultivariateStats
using Test
using LinearAlgebra
import Random

@testset "Ridge Regression" begin

    Random.seed!(34568)

    ## data

    m = 9
    n = 6
    n2 = 3

    X = randn(m, n)
    A = randn(n, n2)
    Xt = X'

    b = randn(1, n2)

    E = randn(m, n2) * 0.1
    Y0 = X * A + E
    Y1 = X * A .+ b + E

    y0 = Y0[:,1]
    y1 = Y1[:,1]

    ## llsq

    A = llsq(X, Y0; trans=false, bias=false)
    A_r = copy(A)
    @test size(A) == (n, n2)
    @test X'Y0 ≈ X'X * A

    a = llsq(X, y0; trans=false, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    A = llsq(Xt, Y0; trans=true, bias=false)
    @test size(A) == (n, n2)
    @test A ≈ A_r

    a = llsq(Xt, y0; trans=true, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    Aa = llsq(X, Y1; trans=false, bias=true)
    Aa_r = copy(Aa)
    @test size(Aa) == (n+1, n2)
    A, b = Aa[1:end-1,:], Aa[end:end,:]
    @test X' * (Y1 .- b) ≈ X'X * A

    aa = llsq(X, y1; trans=false, bias=true)
    @test aa ≈ Aa[:,1]

    Aa = llsq(Xt, Y1; trans=true, bias=true)
    @test Aa ≈ Aa_r

    aa = llsq(Xt, y1; trans=true, bias=true)
    @test aa ≈ Aa[:,1]


    ## ridge (with Real r)

    r = 0.1

    A = ridge(X, Y0, r; trans=false, bias=false)
    A_r = copy(A)
    @test size(A) == (n, n2)
    @test X'Y0 ≈ (X'X + r * I) * A

    a = ridge(X, y0, r; trans=false, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    A = ridge(Xt, Y0, r; trans=true, bias=false)
    @test size(A) == (n, n2)
    @test A ≈ A_r

    a = ridge(Xt, y0, r; trans=true, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    Aa = ridge(X, Y1, r; trans=false, bias=true)
    Aa_r = copy(Aa)
    @test size(Aa) == (n+1, n2)
    A, b = Aa[1:end-1,:], Aa[end:end,:]
    @test X' * (Y1 .- b) ≈ (X'X + r * I) * A

    aa = ridge(X, y1, r; trans=false, bias=true)
    @test aa ≈ Aa[:,1]

    Aa = ridge(Xt, Y1, r; trans=true, bias=true)
    @test Aa ≈ Aa_r

    aa = ridge(Xt, y1, r; trans=true, bias=true)
    @test aa ≈ Aa[:,1]


    ## ridge (with diagonal r)

    r = 0.05 .+ 0.1 .* rand(n)

    A = ridge(X, Y0, r; trans=false, bias=false)
    A_r = copy(A)
    @test size(A) == (n, n2)
    @test X'Y0 ≈ (X'X + diagm(0=>r)) * A

    a = ridge(X, y0, r; trans=false, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    A = ridge(Xt, Y0, r; trans=true, bias=false)
    @test size(A) == (n, n2)
    @test A ≈ A_r

    a = ridge(Xt, y0, r; trans=true, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    Aa = ridge(X, Y1, r; trans=false, bias=true)
    Aa_r = copy(Aa)
    @test size(Aa) == (n+1, n2)
    A, b = Aa[1:end-1,:], Aa[end:end,:]
    @test X' * (Y1 .- b) ≈ (X'X + diagm(0=>r)) * A

    aa = ridge(X, y1, r; trans=false, bias=true)
    @test aa ≈ Aa[:,1]

    Aa = ridge(Xt, Y1, r; trans=true, bias=true)
    @test Aa ≈ Aa_r

    aa = ridge(Xt, y1, r; trans=true, bias=true)
    @test aa ≈ Aa[:,1]


    ## ridge (with qudratic r matrix)

    Q = qr(randn(n, n)).Q
    r = Q' * diagm(0=>r) * Q

    A = ridge(X, Y0, r; trans=false, bias=false)
    A_r = copy(A)
    @test size(A) == (n, n2)
    @test X'Y0 ≈ (X'X + r) * A

    a = ridge(X, y0, r; trans=false, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    A = ridge(Xt, Y0, r; trans=true, bias=false)
    @test size(A) == (n, n2)
    @test A ≈ A_r

    a = ridge(Xt, y0, r; trans=true, bias=false)
    @test size(a) == (n,)
    @test a ≈ A[:,1]

    Aa = ridge(X, Y1, r; trans=false, bias=true)
    Aa_r = copy(Aa)
    @test size(Aa) == (n+1, n2)
    A, b = Aa[1:end-1,:], Aa[end:end,:]
    @test X' * (Y1 .- b) ≈ (X'X + r) * A

    aa = ridge(X, y1, r; trans=false, bias=true)
    @test aa ≈ Aa[:,1]

    Aa = ridge(Xt, Y1, r; trans=true, bias=true)
    @test Aa ≈ Aa_r

    aa = ridge(Xt, y1, r; trans=true, bias=true)
    @test aa ≈ Aa[:,1]

end
