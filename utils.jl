include("_libs/notion.jl")

# global constants
db_research = load_or_write_db(id_research; update=false, secret="")
db_talk = load_or_write_db(id_talk; update=false, secret="")
db_team = load_or_write_db(id_team; update=false, secret="")
db_lab = load_or_write_db(id_lab; update=false, secret="")

extract_single(image) = isempty(image) ? "" : chop(image[1]; head=6, tail=0)

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

function hfun_render_talks()
    keys = db_talk["keys"]
    timeid = findfirst(==("Date and Time"), keys)
    vals = filter(x->!isempty(x[timeid]), db_talk["data"])
    vals = sort(vals, by=v->parse_time(v[timeid]), rev=true)
    join(filter(!isempty, [render_talk(Dict(zip(keys, row))) for row in vals]), "\n")
end

function render_talk(row::Dict)
    name, datetime, title, abstract, link = row["Name"], row["Date and Time"], row["Title"], row["Abstract"], row["HKUST Poster"]
    any(isempty, (title, name, abstract, datetime)) &&  return ""
    return """<h3> <a href="$link">$title</a></h3>
$name
<p><small>
$abstract
<table>
<tr>
<td><strong>Time</strong></td><td>$(render_time(parse_time(datetime)))</td>
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
$(join(abs, "\n"))
"""
end

function render_member(row::Dict)
    cname, ename, titles, office, email, avatar = row["中文名"], row["English name"], row["Titles"], row["Office"], row["Email"], row["Avatar"]
    title = join(titles, "<br>")
    img = extract_single(avatar)
    return """
    <div style="display:block; vertical-align: top; margin-top:20px;">
      <div>
      <a href="/team/$ename/"><img src="$img" style="object-fit: cover; width:25%; min-width: 130px; min-height: 180px; padding:10px; max-width:none"></a>
      </div>
      <div style="padding:10px">
        <p style="margin-top:0">
        <a href="/team/$ename/">$ename ($cname)</a><br>
        <small>
          $title
          <br>
          Email: <a href="mailto:$email">$email</a>
          <br>
          Office: $office</a>
        </small>
        </p>
      </div>
    </div>"""
end

function hfun_render_research()
    abs = String[]
    keys = db_research["keys"]
    timeid = findfirst(==("Date"), keys)
    vals = filter(x->!isempty(x[timeid]), db_research["data"])
    vals = sort(vals, by=v->parse_date(v[timeid]), rev=true)
    for rowdata in vals
        row = Dict(zip(keys, rowdata))
        push!(abs, render_research(row))
    end
    return """$(join(filter(!isempty, abs), "\n"))
"""
end

function render_research(row::Dict)
    title, person, abstract, image, date = row["Name"], row["Person"], row["Abstract"], row["Image"], row["Date"]
    any(isempty, (title, person, abstract, image)) &&  return ""
    img = extract_single(image)
    return """
    <div style="margin-bottom:30px; margin-top: 30px">
      <figure>
        <img src="$img" style="object-fit: cover; max-width: 95%; padding-left:0px; width:500px; margin:auto;">
        <figcaption>
        <h3 style="margin-top:10px">$title</h3>
        <p>$abstract</p>
        <p align="right" rel="author">$(render_date(parse_date(date))), <a href="/team/$person">$person</a></p>
        </figcaption>
      </figure>
    </div>
    """
end

function hfun_render_lab()
    abs = String[]
    keys = db_lab["keys"]
    vals = db_lab["data"]
    for rowdata in vals
        row = Dict(zip(keys, rowdata))
        push!(abs, render_lab(row))
    end
    return join(filter(!isempty, abs), "\n")
end

function render_lab(row::Dict)
    title, abstract, image, people = row["Name"], row["Description"], row["Image"], row["Proposed by"]
    any(isempty, (title, abstract, image)) &&  return ""
    img = extract_single(image)
    return """
        <div class="feature__item">
        <div class="archive__item">
            <div class="archive__item-teaser">
            <img src="$img" alt="$title" />
            </div>
            <div class="archive__item-body">
            <h2 class="archive__item-title">$title</h2>
            <div class="archive__item-excerpt">
                <p>$abstract</p>
            </div>
            </div>
        </div>
        </div>
    """
end