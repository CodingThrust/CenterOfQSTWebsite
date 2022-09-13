@def title = "Franklin Example"
@def tags = ["syntax", "code"]

# Events

\tableofcontents <!-- you can use \toc as well -->

## Invited Talks

~~~
{{for (name, datetime, location, zoom, bio, title, abstract, cv, email, invitedby, googlescholar, meet, link) in talks_list}}
<h3> {{title}} </h3>
{{name}}
<p><small>
{{abstract}}
<table>
<tr>
<td><strong>Time</strong></td><td>{{datetime}}</td>
</tr>
<tr>
<td><strong>Location</strong></td> <td>{{location}}</td>
</tr>
<tr>
<td><strong>Zoom</strong></td> <td><a href="{{zoom}}">{{zoom}}</a></td>
</tr>
</table>
</small>
</p>
{{end}}
~~~