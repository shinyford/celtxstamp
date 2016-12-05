<% @users.all do |user| %>
  <%= user.email %>:<br/>
  <% user.stamps do |stamp| %>
    <%= stamp.filename %><br/>
  <% end %>
  <br/>
<% end %>