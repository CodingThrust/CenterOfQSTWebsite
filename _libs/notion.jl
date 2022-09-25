using HTTP, JSON, Dates

function dbread(token; download_files, overwrite, secret)
    headers = [
        "Authorization" => "Bearer $(secret)",
        "Notion-Version" => "2022-06-28",
        "Content-Type"=> "application/json"
        ]
    # get database information
    url = "https://api.notion.com/v1/databases/$token"
    res = HTTP.get(url; headers)
    keys = db2keys(JSON.parse(String(res.body)))

    # get data
    url = "https://api.notion.com/v1/databases/$token/query"
    res = HTTP.post(url; headers)
    return keys, db2plaintext(keys, JSON.parse(String(res.body)); download_files, overwrite)
end

function db2keys(dict)
    return collect(String, keys(dict["properties"]))
end

function db2plaintext(keys, dict; download_files, overwrite)
    rows = Vector{Any}[]
    lst = dict["results"]
    for item in lst
        push!(rows, dbrow2plaintext(keys, item; download_files, overwrite))
    end
    return rows
end

function dbrow2plaintext(keys, row; download_files, overwrite)
    dbid = join(split(row["parent"]["database_id"], "-"), "")
    datafolder = joinpath("__site", "assets", "databases", dbid)
    res = Any[]
    for k in keys
        v = row["properties"][k]
        type = v["type"]
        content = v[type]
        data = if type ∈ ["phone_number", "email", "url"]
            content === nothing ? "" : strip(content)
        elseif type ∈ ["rich_text", "title"]
            # NOTE: convert rich text to plain text
            join(String[item["plain_text"] for item in content], "\n")
        elseif type == "files"  # NOTE: only gets the first file! returns the file path
            if !isempty(content)
                fnames = String[]
                for file in content
                    if any(sub->endswith(lowercase(file["name"]), sub), download_files)
                        fname = joinpath(datafolder, file["name"])
                        if overwrite || !isfile(fname)
                            HTTP.download(file["file"]["url"], fname)
                        end
                        push!(fnames, fname)
                    end
                end
                fnames
            else
                String[]
            end
        elseif type == "select"
            content === nothing ? "" : content["name"]
        elseif type ∈ ["checkbox", "number"]
            content
        elseif type == "people"
            # NOTE: people is not allowed to access!
            ""
        elseif type == "status"
            content === nothing ? "" : content["name"]
        elseif type == "date"
            content === nothing ? "" : content["start"]
        elseif type == "multi_select"
            String[c["name"] for c in content]
        else
            error("field type: $type not handled properly!")
        end
        push!(res, data)
    end
    return res
end

function load_or_write_db(id; update, secret)
    folder = joinpath("__site", "assets", "databases", "$id")
    mkpath(folder)
    fname = joinpath(folder, "db.json")
    if update
        (keys, data) = dbread(id; download_files=["png", "jpg", "jpeg"], overwrite=false, secret=secret)
        db = Dict("keys"=>keys, "data"=>data)
        # save to files
        open(fname, "w") do f
            write(f, JSON.json(db))  # parse and transform data
        end
        return db
    else
        return JSON.parsefile(fname)
    end
end

function render_html_member(row)
    cname, ename, affiliations, office, email, avatar, interest, bio, home = row["中文名"], row["English name"], row["Titles"], row["Office"], row["Email"], row["Avatar"], row["Interest"], row["Bio"], row["Home page"]
    affiliation = join(affiliations, raw"<br>")
    img = extract_single(avatar)
    return """# $ename ($cname)
~~~
    <div class="div-row">
      <div class="div-first">
      <a href="$img"><img src="$img"></a>
      </div>
      <div class="div-second">
        <p style="margin-top:0">
          <a href="$(home)">University home page</a>
          <br>
          <strong>Email:</strong> <a href="mailto:$email">$email</a>
          <br>
          <strong>Office:</strong> $office</a>
        </p>
      </div>
    </div>
~~~
## Biography
$bio
## Research Interest
$interest
    """
end

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

function parse_time(time)
    #res = match(r"(\d+)-(\d+)-(\d+)T(\d+):(\d+):\d+.\d+\+\d+:00", time)
    #return DateTime(parse.(Int, getindex.(Ref(res), 1:5))...)
    return DateTime(time, dateformat"y-m-dTH:M:S.s+08:00")
end

function render_time(time)
    return Dates.format(time, dateformat"I:MM p, u dd, YYYY")
end

function parse_date(date)
    return Date(date, dateformat"y-m-d")
end

function render_date(date)
    return Dates.format(date, dateformat"u d, Y")
end

const id_research = "003d7922fb114b159c1a8323e9324ee2"
const id_talk = "d7fd2fd0f11e48dbb13e1018682d6219"
const id_team = "eb1998c2a7c54c649aa88ca82acc101d"
const id_lab = "dcbb0aa27be6422d986506c9db8a69e0"