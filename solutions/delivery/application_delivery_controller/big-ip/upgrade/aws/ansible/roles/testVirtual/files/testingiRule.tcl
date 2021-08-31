when HTTP_REQUEST {
   if { [active_members [LB::server pool]] == 0 } {
     HTTP::respond 200 content "
      <html>
         <head>
            <title>Testing Page</title>
         </head>
         <body>
            <br>
            The big-ip upgrade environment is ready!<br>
            <br>
            [virtual name] is available<br>
            <br>
            Thanks for visiting from [IP::client_addr] to virtual address [IP::local_addr]
         </body>
      </html>
      "
   }
}
