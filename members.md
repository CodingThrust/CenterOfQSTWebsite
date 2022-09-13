@def title = "Franklin Example"
@def tags = ["syntax", "code"]

# Members
## Faculties
~~~
<table>
{{for (cname, ename, title, tel, office, email, docs, home, bio, interest, avatar) in members_faculty}}
    <tr>
      <td>
      <img src="/assets/avatars/{{ename}}.png" style="object-fit: cover; width: 100px; height: 120px">
      </td>
      <td>
        <p>
        <a href="{{home}}">{{ename}} ({{cname}})</a><br>
        <small>
          {{title}}
          <br>
          Email: <a href="mailto:{{email}}">{{email}}</a>
          <br>
          Office: {{office}}</a>
        </small>
        </p>
      </td>
    </tr>
{{end}}
</table>
~~~