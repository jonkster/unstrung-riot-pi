#!/usr/bin/expect --

#
# $Id: localswitches.tcl,v 1.5 2004/04/03 19:44:52 ken Exp $
#

source $env(OPENSWANSRCDIR)/testing/utils/GetOpts.tcl
source $env(OPENSWANSRCDIR)/testing/utils/netjig.tcl

global env

set netjig_prog $env(OPENSWANSRCDIR)/testing/utils/uml_netjig/uml_netjig

set arpreply ""
set umlid(extra_hosts) ""

set env(NETJIGVERBOSE) 1

set netjig1 [netjigstart]

# do this to create the expect_out set of variables.
expect *

netjigsetup $netjig1

foreach net $managednets {
    process_net $net
}

foreach net $managednets {
    calc_net $net
}

foreach net $managednets {
    newswitch $netjig1 "$net"
}

set switchvars [open [file join $env(POOLSPACE) ".switches.sh"] "w"]
foreach net $managednets {
    set var "UML_${net}_CTL"
    puts $switchvars "$var=$env($var)\n"
}
close $switchvars

#foreach host $argv {
#    system "$host single &"
#}

foreach net $managednets {
    if {[info exists umlid(net$net,play)] } {
	puts "Will play pcap file $umlid(net$net,play) to network '$net'\r\n"
	setupplay $netjig1 $net $umlid(net$net,play) "--rate=ontick"
    }
}

puts "\r\nExit the netjig when you are done\r\n"

system "stty onlcr echo icrnl opost"

set timeout -1
interact {
    -i $netjig1
    "exit"  {
        send_user "QUITING"
        send "quit\n"
    }
    "*\n" {
        send_user "\r\nENTER\r\n"
        send "${interact_out(1,string)}\n"
    }
    $      {send_user "The date is [exec date]."}

    -o "\n" { send_user "\r\n" }
       "\r" { send_user "\r\n" }
}

foreach host $argv {
    system "uml_mconsole $host halt"
}






