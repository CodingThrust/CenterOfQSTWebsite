using DelimitedFiles

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


function hfun_isemptystring(vname)
    val = Meta.parse(vname[1])
    return "isempty($val)"
end

function hfun_render_talks()
    filename = "_assets/talks.csv"
    join(filter(!isempty, [render_talk(row) for row in eachrow(readdlm(filename, ',', skipstart=1))]), "\n")
end

function render_talk(row)
    (name, datetime, location, zoom, bio, title, abstract, cv, email, invitedby, googlescholar, meet, posterlink, recording) = row
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

#members_faculty = eachrow(readdlm("_assets/faculty.csv", ',', skipstart=1))