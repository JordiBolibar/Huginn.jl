
function clean()
    atexit() do
        run(`$(Base.julia_cmd())`)
    end
    exit()
 end

 function enable_multiprocessing(params::Sleipnir.Parameters)
    procs = params.simulation.workers
    if procs > 0 && params.simulation.multiprocessing
        if nprocs() < procs
            @eval begin
            addprocs($procs - nprocs(); exeflags="--project")
            @info "Number of cores: $(nprocs())"
            @info "Number of workers: $(nworkers())"
            @everywhere using Reexport
            @everywhere @reexport using Huginn
            end # @eval
        elseif nprocs() != procs && procs == 1 && !params.simulation.test_mode
            @eval begin
            rmprocs(workers(), waitfor=0)
            @info "Number of cores: $(nprocs())"
            @info "Number of workers: $(nworkers())"
            end # @eval
        end
    end
    return nworkers()
end
