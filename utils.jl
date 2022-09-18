using DelimitedFiles

include("notion.jl")

# global constants
update_dbs = get(ENV, "UPDATEDATABASE", "false") == "true"
id_research = "003d7922fb114b159c1a8323e9324ee2"
id_talk = "d7fd2fd0f11e48dbb13e1018682d6219"
id_team = "eb1998c2a7c54c649aa88ca82acc101d"

db_research = load_or_write_db(id_research; update=update_dbs, secret=ENV["NOTIONDATABASE"])
db_talk = load_or_write_db(id_talk; update=update_dbs, secret=ENV["NOTIONDATABASE"])
db_team = load_or_write_db(id_team; update=update_dbs, secret=ENV["NOTIONDATABASE"])

function hfun_bar(vname)
    val = Meta.parse(vname[1])
    return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
    var = vname[1]
    return pagevar("index", var)
end

function lx_baz(com, _)
    # keep this first line
    brace_content = Franklin.content(com.braces[1]) # input string
    # do whatever you want here
    return uppercase(brace_content)
end

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

function hfun_render_talks()
    keys = db_talk["keys"]
    join(filter(!isempty, [render_talk(Dict(zip(keys, row))) for row in db_talk["data"]]), "\n")
end

function render_talk(row::Dict)
    name, datetime, title, abstract = row["Name"], row["Date and Time"], row["Title"], row["Abstract"]
    any(isempty, (title, name, abstract, datetime)) &&  return ""
    return """<h3> $title </h3>
$name
<p><small>
$abstract
<table>
<tr>
<td><strong>Time</strong></td><td>$datetime</td>
</tr>
</table>
</small>
</p>"""

# NOTE: if want location information.
#<tr>
#<td><strong>Location</strong></td> <td>$location</td>
#</tr>
#<tr>
#<td><strong>Zoom</strong></td> <td><a href="$zoom">$zoom</a></td>
#</tr>
end

function hfun_render_team()
    names = String[]
    abs = String[]
    keys = db_team["keys"]
    for rowdata in db_team["data"]
        row = Dict(zip(keys, rowdata))
        ename = row["English name"]
        cname = row["中文名"]
        push!(names, """<a href="/team/$ename/">$ename ($cname)</a>""")
        push!(abs, render_member(row))
    end
    return """<p>$(join(names, "&nbsp;"^4))</p>
<table>$(join(abs, "\n"))</table>
"""
end

function render_member(row::Dict)
    cname, ename, title, office, email, avatar = row["中文名"], row["English name"], row["Titles"], row["Office"], row["Email"], row["Avatar"]
    img = extract_single(avatar)
    return """<tr>
      <td style="border-bottom:0px">
      <img src="$img" style="object-fit: cover; width: 100px; height: 120px; padding-left:0px; max-width:none">
      </td>
      <td style="border-bottom:0px">
        <p>
        <a href="/team/$ename/">$ename ($cname)</a><br>
        <small>
          $title
          <br>
          Email: <a href="mailto:$email">$email</a>
          <br>
          Office: $office</a>
        </small>
        </p>
      </td>
    </tr>"""
end

function hfun_render_research()
    abs = String[]
    keys = db_research["keys"]
    for rowdata in db_research["data"]
        row = Dict(zip(keys, rowdata))
        push!(abs, render_research(row))
    end
    return """$(join(filter(!isempty, abs), "\n"))
"""
end

function render_research(row::Dict)
    title, person, abstract, image = row["Name"], row["Person"], row["Abstract"], row["Image"]
    any(isempty, (title, person, abstract, image)) &&  return ""
    img = extract_single(image)
    return """<h3>$title</h3>
    <table>
    <tr><td style="border-bottom:0px">
    <img src="$img" style="object-fit: cover; width: 200px; height: 240px; padding-left:0px">
    </td>
    <td style="border-bottom:0px; vertical-align:top">
    <p>$abstract</p>
    <p align="right" rel="author"><a href="/team/$person">$person</a></p>
    </td>
    </tr>
    </table>
    """
end

