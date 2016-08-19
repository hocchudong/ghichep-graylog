cat << EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
        address 172.17.77.100
        netmask 255.255.255.0
        gateway 172.17.77.254
        dns-nameservers 8.8.8.8        
EOF