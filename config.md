<!--
Add here global page variables to use throughout your website.
-->
+++
using DelimitedFiles

author = "Center of Quantum Science and Technology"
mintoclevel = 2

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "Center of Quantum Science and Technology"
website_descr = "A theme lab about quantum devices, quantum control, quantum software and quantum material at Advanced Material Thrust, Function Hub, Hong Kong University of Science and Technology (Guangzhou)"
website_url   = "https://tlienart.github.io/FranklinTemplates.jl/"
members_faculty = eachrow(readdlm("_assets/faculty.csv", ',', skipstart=1))
talks_list = eachrow(readdlm("_assets/talks.csv", ',', skipstart=1))
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
