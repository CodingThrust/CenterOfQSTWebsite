using Test

include("utils.jl")

@testset "dbread" begin
    secret = ENV["NOTIONDATABASE"]
    # read the test database
    ks, vs = dbread("d07aa4ffee0c49db996cb25cfea6a56b"; download_files=true, overwrite=false, secret)
    @show ks
    @show vs
    d1 = Dict(zip(ks, vs[1]))
    d2 = Dict(zip(ks, vs[2]))
    @test d1 == Dict("Files & media" => String[],
        "Date" => "",
        "Checkbox" => false,
        "Text" => "",
        "Person" => "",
        "Tags" => String[],
        "Phone" => "",
        "Status" => "",
        "Email" => "",
        "URL" => "",
        "Number" => nothing,
        "Select" => "",
        "Name" => "Empty")

    @test isfile(d2["Files & media"][1])
    @test d2 == Dict("Files & media" => String["_assets/databases/d07aa4ffee0c49db996cb25cfea6a56b/Jinguo Liu.png"],
        "Date" => "2022-09-27",
        "Checkbox" => true,
        "Text" => "asdf",
        "Person" => "",
        "Tags" => String["test", "haha"],
        "Phone" => "1234566",
        "Status" => "In progress",
        "Email" => "cacate0129@gmail.com",
        "URL" => "www.google.com",
        "Number" => 2,
        "Select" => "sf",
        "Name" => "Jinguo")
end