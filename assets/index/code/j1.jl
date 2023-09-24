# This file was generated, do not modify it. # hide
using DiffEqGPU, StaticArrays, OrdinaryDiffEq
using StaticTools
using JSServe

# tres = MallocVector{Float64}(undef,)
# u0 = MallocVector{Float64}
# u1 = MallocVector{Float64}
# u2 = MallocVector{Float64}

function lorenz(u, p, t)
    σ = p[1]
    ρ = p[2]
    β = p[3]
    du1 = σ * (u[2] - u[1])
    du2 = u[1] * (ρ - u[3]) - u[2]
    du3 = u[1] * u[2] - β * u[3]
    return SVector{3}(du1, du2, du3)
end

u0 = @SVector [1.0; 0.0; 0.0]
tspan = (0.0, 20.0)
p = @SVector [10.0, 28.0, 8 / 3.0]
prob = ODEProblem{false}(lorenz, u0, tspan, p)

integ = DiffEqGPU.init(GPUTsit5(), prob.f, false, u0, 0.0, 0.005, p, nothing, CallbackSet(nothing), true, false)


function first_order_sys!(x, p, t)
    τ = p[1]

    dx = (1. - x[1]) / τ

    return SVector{1}(dx)
end

X0 = @SVector [0.0]
tspan = (0.0, 20.0)
p2 = @SVector [0.2]
prob2 = ODEProblem{false}(first_order_sys!, X0, tspan, p2)

integ2 = DiffEqGPU.init(GPUTsit5(), prob2.f, false, X0, 0.0, 0.005, p2, nothing, CallbackSet(nothing), true, false)