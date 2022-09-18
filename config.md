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
prepath = get(ENV, "PREVIEW_FRANKLIN_PREPATH", "CenterOfQSTWebsite") # In the third argument put the prepath you normally use
website_url = get(ENV, "PREVIEW_FRANKLIN_WEBSITE_URL", "codingthrust.github.io") # Just put the website name

# Database and team page
include("notion.jl")

# global constants
update_dbs = get(ENV, "UPDATEDATABASE", "false") == "true"
id_research = "003d7922fb114b159c1a8323e9324ee2"
id_talk = "d7fd2fd0f11e48dbb13e1018682d6219"
id_team = "eb1998c2a7c54c649aa88ca82acc101d"

db_research = load_or_write_db(id_research; update=update_dbs, secret=ENV["NOTIONDATABASE"])
db_talk = load_or_write_db(id_talk; update=update_dbs, secret=ENV["NOTIONDATABASE"])
db_team = load_or_write_db(id_team; update=update_dbs, secret=ENV["NOTIONDATABASE"])

extract_single(image) = isempty(image) ? "" : chop(image[1]; head=6, tail=0)

# generate faculty web pages
function render_html_member(row)
    cname, ename, affiliation, office, email, avatar, interest, bio, home = row["中文名"], row["English name"], row["Titles"], row["Office"], row["Email"], row["Avatar"], row["Interest"], row["Bio"], row["Home page"]
    img = extract_single(avatar)
    return """# $ename ($cname)
~~~
        <table>
        <tr>
      <td style="border-bottom-width:0px">
      <img src="$img" style="object-fit: cover; width: 100px; height: 120px; padding-left:0px; max-width: none">
      </td>
      <td style="border-bottom-width:0px; padding-left:20px">
        <p>
          $affiliation<br>
        home page: <a href="$(home)">$home</a>
          <br>
          Email: <a href="mailto:$email">$email</a>
          <br>
          Office: $office</a>
        </p>
      </td>
    </tr>
    </table>
~~~
## Biography
$bio
## Research Interest
$interest
    """
end

# genreate member pages
function generate_team_pages()
    mkpath("team")
    keys = db_team["keys"]
    for rowdata in db_team["data"]
        row = Dict(zip(keys, rowdata))
        ename = row["English name"]
        filename = joinpath("team", "$ename.md")
        open(filename, "w") do f
            write(f, render_html_member(row))
        end
    end
end
generate_team_pages()
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
