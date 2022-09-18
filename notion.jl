using HTTP, JSON

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
            if !isempty(content) && download_files
                fnames = String[]
                for file in content
                    fname = joinpath(datafolder, file["name"])
                    if overwrite || !isfile(fname)
                        HTTP.download(file["file"]["url"], fname)
                    end
                    push!(fnames, fname)
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
        (keys, data) = dbread(id; download_files=true, overwrite=false, secret=secret)
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

