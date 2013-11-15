if {[info exists env(GSI_BUILD_TYPE)]} {
  set build_type $env(GSI_BUILD_TYPE)
} else {
  set build_type "developer preview"
}

set build_date [ clock format [ clock seconds ] -format "%a %b %d %H:%M:%S %Z %Y" ]

set user [open "| git config user.name" "r"]
gets $user username
close $user

set user [open "| git config user.email" "r"]
gets $user email
close $user

if {$tcl_platform(os) == "Linux"} {
  set lsb [open "| lsb_release -d" "r"]
  gets $lsb desc
  set build_os "[lindex [split $desc "\t"] 1], kernel $tcl_platform(osVersion)"
  close $lsb
} else {
  set build_os "$tcl_platform(os) $tcl_platform(osVersion)"
}

set output [list]

lappend output "Project     : [lindex $quartus(args) 1]"
lappend output "Platform    : $platform"
lappend output "FPGA model  : [get_global_assignment -name FAMILY] ([get_global_assignment -name DEVICE])"
lappend output "Build type  : $build_type"
lappend output "Build date  : $build_date"
lappend output "Prepared by : $username <$email>"
lappend output "Perpared on : [info hostname]"
lappend output "OS version  : $build_os"
lappend output "Quartus     : $quartus(version)"
lappend output ""

set gitlog [open "| git log --oneline --decorate=no -n 5" "r"]
while {[gets $gitlog line] >= 0} { lappend output "  $line" }
close $gitlog

post_message "Build-ID ROM will contain:"
foreach row $output { post_message "  $row" }

set bytes [list]
foreach row $output {
  foreach byte [split $row ""] {
    scan $byte "%c" ascii
    lappend bytes "[format %02X $ascii]"
  }
  lappend bytes "0A"
}

set length 1024
set data [llength $bytes]

for {set i $data} {$i < $length} {incr i} {
  lappend bytes "00"
}

if {$data > $length} {
  set bytes [lreplace $bytes $length $data]
}

set outputFile [open "build_id.mif" "w"]
puts $outputFile "-- Build ID Memory Initialization File"
puts $outputFile "--"
foreach row $output { puts $outputFile "-- $row" }
puts $outputFile ""
puts $outputFile "DEPTH = 256;"
puts $outputFile "WIDTH = 32;"
puts $outputFile "ADDRESS_RADIX = HEX;"  
puts $outputFile "DATA_RADIX = HEX;"
puts $outputFile ""
puts $outputFile "CONTENT"
puts $outputFile "BEGIN"
puts $outputFile ""

set i 0
foreach {a b c d} $bytes {
  puts $outputFile "[format %x $i] : $a$b$c$d;"
  incr i
}

puts $outputFile "END;"
close $outputFile
