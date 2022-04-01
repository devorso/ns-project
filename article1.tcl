set val(chan)       Channel/WirelessChannel
set val(prop)       Propagation/TwoRayGround
set val(netif)      Phy/WirelessPhy
set val(mac)        Mac/802_11
set val(ifq)        Queue/DropTail/PriQueue
set val(ll)         LL
set val(ant)        Antenna/OmniAntenna
set val(x)          1000   
set val(y)          1000   
set val(ifqlen)     50            
set val(seed)       1.0
set val(nn)         100           
set val(cp)         "./cbr-50" 
set val(sc)         "./newscen" 
set val(stop)       200        
set val(rp)         AODV                   

# Create a simulator object
set ns_  [new Simulator]
set topo [new Topography]

set tracefd  [open out-100noeuds-50AODV.tr w]      
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
   	$node_($j) random-motion 0
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

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} {incr i} {

        # 20 defines the node size in nam, must adjust it according to your
        # scenario size.
        # The function must be called after mobility model is defined
        $ns_ initial_node_pos $node_($i) 20
}  
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
