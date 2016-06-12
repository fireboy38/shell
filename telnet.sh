#!/usr/bin/expect
set time 10
set user "admin"
set password "admin@123"
spawn telnet 10.4.2.26
expect "Username"
send "$user\r"
expect "Password:"
send "$password\r"
expect ">"
send "sys\r"
expect "return"
send_user  "Now you can do some operation on this terminal\r"
send "\r"
interact
exit
