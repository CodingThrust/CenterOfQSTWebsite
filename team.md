@def title = "Team"
@def tags = ["team", "faculty", "QST", "Quantum Science and Technology"]

# Team
## Faculties
~~~
<table>
{{for (cname, ename, title, tel, office, email, docs, home, bio, interest, avatar) in members_faculty}}
    <tr>
      <td style="border-bottom:0px">
      <img src="/assets/avatars/{{ename}}.png" style="object-fit: cover; width: 100px; height: 120px">
      </td>
      <td style="border-bottom:0px">
        <p>
        <a href="/team/{{ename}}/">{{ename}} ({{cname}})</a><br>
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