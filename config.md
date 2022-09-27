<!--
Add here global page variables to use throughout your website.
-->
+++
using DelimitedFiles

author = "Center for Quantum Science and Technology"
mintoclevel = 2

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "Center for Quantum Science and Technology"
website_descr = "A theme lab about quantum devices, quantum control, quantum software and quantum material at Advanced Material Thrust, Function Hub, Hong Kong University of Science and Technology (Guangzhou)"
prepath = get(ENV, "PREVIEW_FRANKLIN_PREPATH", "CenterOfQSTWebsite") # In the third argument put the prepath you normally use
website_url = get(ENV, "PREVIEW_FRANKLIN_WEBSITE_URL", "codingthrust.github.io") # Just put the website name

# Database and team page
include("_libs/notion.jl")

# global constants
update_dbs = get(ENV, "UPDATEDATABASE", "false") == "true"
db_research = load_or_write_db(id_research; update=update_dbs, secret=ENV["NOTIONDATABASE"])
db_talk = load_or_write_db(id_talk; update=update_dbs, secret=ENV["NOTIONDATABASE"])
db_team = load_or_write_db(id_team; update=update_dbs, secret=ENV["NOTIONDATABASE"])
db_lab = load_or_write_db(id_lab; update=update_dbs, secret=ENV["NOTIONDATABASE"])

extract_single(image) = isempty(image) ? "" : chop(image[1]; head=6, tail=0)

# genreate member pages
generate_team_pages()
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
