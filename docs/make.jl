using UniversalDecimalTime
using Documenter

DocMeta.setdocmeta!(UniversalDecimalTime, :DocTestSetup, :(using UniversalDecimalTime); recursive=true)

makedocs(;
    modules=[UniversalDecimalTime],
    checkdocs = :exports,
    authors="imohag9 <souidi.hamza90@gmail.com> and contributors",
    sitename="UniversalDecimalTime.jl",
    format=Documenter.HTML(;
        canonical="https://imohag9.github.io/UniversalDecimalTime.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Decimal Time History" => "decimal_time_history.md",
        "Quick Start" => "quick_start.md",
        "Constructors" => "constructors.md",
        "Conversions" => "conversions.md",
        "Range Support" => "ranges.md", 
        "API Reference" => "api.md",

    ],
)

deploydocs(;
    repo="github.com/imohag9/UniversalDecimalTime.jl",
    devbranch="main",
)
