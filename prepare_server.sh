# run the following (adapting "eth0" to the interface name) on the server being tested against
for i in {1..100..1}
do
    ip address add 10.5.10.$i/24 dev eth0
done

# and then install and run "iperf" as a server:
iperf -s

