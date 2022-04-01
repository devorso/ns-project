set val(chan)       Channel/WirelessChannel
set val(prop)       Propagation/TwoRayGround
set val(netif)      Phy/WirelessPhy
set val(mac)        Mac/802_11
set val(ifq)        CMUPriQueue 
set val(ll)         LL
set val(ant)        Antenna/OmniAntenna
set val(x)          1000   
set val(y)          1000   
set val(ifqlen)     50            
set val(seed)       1
set val(nn)         50           
set val(cp)         "./cbr-50" 
set val(sc)         "./newscen" 
set val(stop)       100        
set val(rp)         DSR                   

# Create a simulator object #Queue/DropTail/PriQueue
set ns_  [new Simulator]
set topo [new Topography]

set tracefd  [open out-50noeuds-50DSR.tr w]      
$ns_ trace-all $tracefd

$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]  

$ns_ node-config -adhocRouting $val(rp) \
                         -llType $val(ll) \
                         -macType $val(mac) \
                         -ifqType $val(ifq) \
                         -ifqLen $val(ifqlen) \
                         -antType $val(ant) \
                         -propType $val(prop) \
                         -phyType $val(netif) \
                         -topoInstance $topo \
                         -channelType $val(chan) \
                         -agentTrace ON \
                         -routerTrace ON \
                         -macTrace ON \
                         -movementTrace ON

for {set j 0} {$j < $val(nn) } {incr j} {
        set node_($j) [$ns_ node]
   	
} 

# 
# Define node movement model
#
puts "Loading connection pattern..."
source $val(cp)

# 
# Define traffic model
#
puts "Loading scenario file..."
source $val(sc)


for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop) "$node_($i) reset";
}

proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}
puts $tracefd "M 0.0 nn $val(nn) x $val(x) y $val(y) rp $val(rp)"
puts $tracefd "M 0.0 sc $val(sc) cp $val(cp) seed $val(seed)"
puts $tracefd "M 0.0 prop $val(prop) ant $val(ant)"
$ns_ at $val(stop) "stop"
$ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"
puts "Start Simulation"
$ns_ run
