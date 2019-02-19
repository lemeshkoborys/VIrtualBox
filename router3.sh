bash <<EOF2
sed -i 's/ubuntu/router3/g' /etc/hostname
sed -i 's/ubuntu/router3/g' /etc/hosts
hostname router3
apt-get update
apt-get install quagga quagga-doc traceroute
cp /usr/share/doc/quagga/examples/zebra.conf.sample /etc/quagga/zebra.conf
cp /usr/share/doc/quagga/examples/ospfd.conf.sample /etc/quagga/ospfd.conf
chown quagga.quaggavty /etc/quagga/*.conf
chmod 640 /etc/quagga/*.conf
sed -i s'/zebra=no/zebra=yes/' /etc/quagga/daemons
sed -i s'/ospfd=no/ospfd=yes/' /etc/quagga/daemons
echo 'VTYSH_PAGER=more' >>/etc/environment 
echo 'export VTYSH_PAGER=more' >>/etc/bash.bashrc
cat >> /etc/quagga/ospfd.conf << EOF
interface enp0s8
interface enp0s9
interface enp0s10
interface lo
router ospf
 passive-interface enp0s8
 network 192.168.3.0/24 area 0.0.0.0
 network 192.168.101.0/24 area 0.0.0.0
 network 192.168.102.0/24 area 0.0.0.0
line vty
EOF
cat > /etc/quagga/zebra.conf << EOF
interface enp0s8
 ip address 192.168.3.254/24
 ipv6 nd suppress-ra
interface enp0s9
 ip address 192.168.101.1/24
 ipv6 nd suppress-ra
interface enp0s10
 ip address 192.168.102.1/24
 ipv6 nd suppress-ra
interface lo
ip forwarding
line vty
EOF
/etc/init.d/quagga start
exit
EOF2 
