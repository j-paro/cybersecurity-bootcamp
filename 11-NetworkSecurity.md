## Unit 11 Submission File: Network Security Homework 
### Part 1: Review Questions 
#### Security Control Types
The concept of defense in depth can be broken down into three different security control types. Identify the security control type of each set  of defense tactics.
1. Walls, bollards, fences, guard dogs, cameras, and lighting are what type of security control?
 Answer: **These are physical security controls.**
2. Security awareness programs, BYOD policies, and ethical hiring practices are what type of security control?
 Answer: **These are administrative security controls.**
3. Encryption, biometric fingerprint readers, firewalls, endpoint security, and intrusion detection systems are what type of security control?
 Answer: **These are technical security controls.**
#### Intrusion Detection and Attack indicators
1. What's the difference between an IDS and an IPS?
 Answer: **An IDS is passive. It simply logs, documents, and most likely alerts on potential attacks that either are happening or have happened. An IPS can do everything an IDS can do but it can also respond to an attack. Also, an IPS connects inline with the flow of data on a network while an IDS connects and monitors data via a SPAN or network TAP.** 
2. What's the difference between an Indicator of Attack and an Indicator of Compromise?
 Answer: **The thing mentioned most often is that an IoA is happening while an IoC has already happened. From the class slides on 12/1: an IoA is used in "proactive approaches to intrusion attempts" and it will "focus on revealing the intent and end goal of an attacker..." Also from the class slides on 12/1: an IoC indicates "that an attack has occurred, resulting in a breach," and it's "used to establish an adversary's techniques, tactics, and procedures," among other things.**
#### The Cyber Kill Chain
Name each of the seven stages for the Cyber Kill chain and provide a brief example of each.
1. Stage 1: **Reconnaissance -- harvest email addresses for an entity.**
2. Stage 2: **Weaponization -- develop malware that will attack a specific machine or vulnerable piece of software -- e.g. the Murai botnet that attacked vulnerable Zyxel machines**
3. Stage 3: **Delivery -- malware delivered as a malicious email attachment**
4. Stage 4: **Exploitation -- the host system is comprised by a dropper (software that allows attacker to remotely execute commands) or downloader (downloads additional malware from another online location).**
5. Stage 5: **Installing -- this step involves establishing a more permanent presence within the target host, network, etc.; this might be through the installation of another piece of malicious software with the intent being to bypass security while maintaining access.**
6. Stage 6: **Command and Control -- this is usually a server outside the target infrastructure that the malware is connected to; attackers will usually use this manually to communicate with the malware.** 
7. Stage 7: **Actions on Objectives -- this varies a great deal and depends on what was exploited and why it was exploited; could be data exfiltration, espionage, extortion, destruction, disruption, etc.**

*I got the stages of the Cyber Kill Chain from the following website: https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html. I got the example information for each stage from this website: https://eforensicsmag.com/the-cyber-kill-chain-explained-along-with-some-2020-examples-by-maciej-makowski/.*
#### Snort Rule Analysis
Use the Snort rule to answer the following questions:
Snort Rule #1
```bash
alert tcp $EXTERNAL_NET any -> $HOME_NET 5800:5820 (msg:"ET SCAN Potential VNC Scan 5800-5820"; flags:S,12; threshold: type both, track by_src, count 5, seconds 60; reference:url,doc.emergingthreats.net/2002910; classtype:attempted-recon; sid:2002910; rev:5; metadata:created_at 2010_07_30, updated_at 2010_07_30;)
```
1. Break down the Sort Rule header and explain what is happening.
 Answer: **Here's the Snort rule header: `alert tcp $EXTERNAL_NET any -> $HOME_NET 5800:5820`. This generates an alert when any IP address not defined in `$HOME_NET` sends any TCP packet from any port to an IP address in `$HOME_NET` on any port in the 5800-5820 range.**
2. What stage of the Cyber Kill Chain does this alert violate?
 Answer: **Reconnaissance -- this can help analysts determine if an attacker is attempting to locate a VNC vulnerability.**
3. What kind of attack is indicated?
 Answer: **A Potential VNC Scan**
Snort Rule #2
```bash
alert tcp $EXTERNAL_NET $HTTP_PORTS -> $HOME_NET any (msg:"ET POLICY PE EXE or DLL Windows file download HTTP"; flow:established,to_client; flowbits:isnotset,ET.http.binary; flowbits:isnotset,ET.INFO.WindowsUpdate; file_data; content:"MZ"; within:2; byte_jump:4,58,relative,little; content:"PE|00 00|"; distance:-64; within:4; flowbits:set,ET.http.binary; metadata: former_category POLICY; reference:url,doc.emergingthreats.net/bin/view/Main/2018959; classtype:policy-violation; sid:2018959; rev:4; metadata:created_at 2014_08_19, updated_at 2017_02_01;)
```
1. Break down the Sort Rule header and explain what is happening.
 Answer: **Here's the Snort rule header: `alert tcp $EXTERNAL_NET $HTTP_PORTS -> $HOME_NET any`. This generates an alert when any IP address not defined in `$HOME_NET` sends any TCP packet from any HTTP port (this is a list of ports defined in `$HTTP_PORTS`) to any IP address in `$HOME_NET` on any port.**
2. What layer of the Defense in Depth model does this alert violate?
 Answer: **Assuming a valid user (not an attacker with system control) downloaded the EXE or DLL, then this would violate Policies, Procedures, and Awareness layer since users shouldn't be downloading these types of files.** *I used the following picture: https://miro.medium.com/max/1200/1\*063OWN4gLacDPZX74RCEUw.jpeg*
3. What kind of attack is indicated?
 Answer: **Potential PE (Portable Executable) or DLL Windows file download**
Snort Rule #3
- Your turn! Write a Snort rule that alerts when traffic is detected inbound on port 4444 to the local network on any port. Be sure to include the `msg` in the Rule Option.
 Answer: `alert tcp $EXTERNAL_NET 4444 -> $HOME_NET any {msg:"Inbound traffic on 4444 detected!"}`
### Part 2: "Drop Zone" Lab
#### Log into the Azure `firewalld` machine
Log in using the following credentials:
- Username: `sysadmin`
- Password: `cybersecurity`
#### Uninstall `ufw`
Before getting started, you should verify that you do not have any instances of `ufw` running. This will avoid conflicts with your `firewalld` service. This also ensures that `firewalld` will be your default firewall.
- Run the command that removes any running instance of `ufw`.
 ```bash
 $ sudo ufw disable
 ```
#### Enable and start `firewalld`
By default, these service should be running. If not, then run the following commands:
- Run the commands that enable and start `firewalld` upon boots and reboots.
 ```bash
 $ sudo systemctl enable firewalld`
 $ sudo /etc/init.d/firewalld start
 ```
 Note: This will ensure that `firewalld` remains active after each reboot.
#### Confirm that the service is running.
- Run the command that checks whether or not the `firewalld` service is up and running.
 ```bash
 $ systemctl status firewalld
 ```
#### List all firewall rules currently configured.
Next, lists all currently configured firewall rules. This will give you a good idea of what's currently configured and save you time in the long run by not doing double work.
- Run the command that lists all currently configured firewall rules:
 ```bash
 $ firewall-cmd --list-all-zones
 ```
- Take note of what Zones and settings are configured. You many need to remove unneeded services and settings.
#### List all supported service types that can be enabled.
- Run the command that lists all currently supported services to see if the service you need is available
 ```bash
 $ firewall-cmd --get-services
 ```
- We can see that the `Home` and `Drop` Zones are created by default.
#### Zone Views
- Run the command that lists all currently configured zones.
 ```bash
 $ sudo firewall-cmd --get-active-zones
 ```
- We can see that the `Public` and `Drop` Zones are created by default. Therefore, we will need to create Zones for `Web`, `Sales`, and `Mail`.
#### Create Zones for `Web`, `Sales` and `Mail`.
- Run the commands that creates Web, Sales and Mail zones.
 ```bash
 $ sudo firewall-cmd --permanent --new-zone=Web
 $ sudo firewall-cmd --permanent --new-zone=Sales
 $ sudo firewall-cmd --permanent --new-zone=Mail
 ```
#### Set the zones to their designated interfaces:
- Run the commands that sets your `eth` interfaces to your zones.
 ```bash
 $ sudo firewall-cmd --zone=public --change-interface=etho0
 $ sudo firewall-cmd --zone=Web --change-interface=eth1
 $ sudo firewall-cmd --zone=Sales --change-interface=eth2
 $ sudo firewall-cmd --zone=Mail --change-interface=eth3
 ```
#### Add services to the active zones:
- Run the commands that add services to the **public** zone, the **web** zone, the **sales** zone, and the **mail** zone.
- Public:
 ```bash
 $ sudo firewall-cmd --zone=public --add-service=http
 $ sudo firewall-cmd --zone=public --add-service=https
 $ sudo firewall-cmd --zone=public --add-service=pop3
 $ sudo firewall-cmd --zone=public --add-service=smtp
 ```
- Web:
 ```bash
 $ sudo firewall-cmd --zone=Web --add-service=http
 ```
- Sales
 ```bash
 $ sudo firewall-cmd --zone=Sales --add-service=https
 ```
- Mail
 ```bash
 $ sudo firewall-cmd --zone=Mail --add-service=smtp
 $ sudo firewall-cmd --zone=Mail --add-service=pop3
 ```
- What is the status of `http`, `https`, `smtp` and `pop3`?
#### Add your adversaries to the Drop Zone.
- Run the command that will add all current and any future blacklisted IPs to the Drop Zone.
 ```bash
 $ sudo firewall-cmd --permanent --zone=drop --add-source=10.208.56.23
 $ sudo firewall-cmd --permanent --zone=drop --add-source=135.95.103.76
 $ sudo firewall-cmd --permanent --zone=drop --add-source=76.34.169.118
 ```
#### Make rules permanent then reload them:
It's good practice to ensure that your `firewalld` installation remains nailed up and retains its services across reboots. This ensure that the network remains secured after unplanned outages such as power failures.
- Run the command that reloads the `firewalld` configurations and writes it to memory
 ```bash
 $ sudo firewall-cmd --reload
 ```
#### View active Zones
Now, we'll want to provide truncated listings of all currently **active** zones. This a good time to verify your zone settings.
- Run the command that displays all zone services.
 ```bash
 $ sudo firewall-cmd --list-all-zones
 ```
 *The above seems like a duplicate of a question in listing the firewall rules. Also, the "active" sentence doesn't have any bearing on the question asked. On a general note, this whole section is at times ambiguous and difficult to understand.*
#### Block an IP address
- Use a rich-rule that blocks the IP address `138.138.0.3`.
 ```bash
 $ sudo firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='138.138.0.3' reject"
 ```
#### Block Ping/ICMP Requests
Harden your network against `ping` scans by blocking `icmp ehco` replies.
- Run the command that blocks `pings` and `icmp` requests in your `public` zone.
 ```bash
 $ sudo firewall-cmd --zone=public --add-icmp-block=echo-reply --add-icmp-block=echo-request
 ```
#### Rule Check
Now that you've set up your brand new `firewalld` installation, it's time to verify that all of the settings have taken effect.
- Run the command that lists all  of the rule settings. Do one command at a time for each zone.
 ```bash
 $ sudo firewall-cmd --zone=public --list-all
 $ sudo firewall-cmd --zone=drop --list-all
 $ sudo firewall-cmd --zone=Web --list-all
 $ sudo firewall-cmd --zone=Sales --list-all
 $ sudo firewall-cmd --zone=Mail --list-all
 ```
- Are all of our rules in place? If not, then go back and make the necessary modifications before checking again.
Congratulations! You have successfully configured and deployed a fully comprehensive `firewalld` installation.
---
### Part 3: IDS, IPS, DiD and Firewalls
Now, we will work on another lab. Before you start, complete the following review questions.
#### IDS vs. IPS Systems
1. Name and define two ways an IDS connects to a network.
 Answer 1: **Network TAP -- This is a hardware device that provides access to a network. Network taps transit both inbound and outbound data streams on separate channels at the same time, so all data will arrive at the monitoring device in real time.** *(Taken from the class slides)*
 Answer 2: **SPAN -- This is also known as port mirroring. It sends a mirror image of all network data to another physical port, where the packets can be captured and analyzed.** *(Taken from the class slides)*
2. Describe how an IPS connects to a network.
 Answer: **It connects "inline" with the flow of data. This typically means it's located between the firewall and the switch.**
3. What type of IDS compares patterns of traffic to predefined signatures and is unable to detect Zero-Day attacks?
 Answer: **Signature-based IDS**
4. Which type of IDS is beneficial for detecting all suspicious traffic that deviates from the well-known baseline and is excellent at detecting when an attacker probes or sweeps a network?
 Answer: **Anomaly-based IDS**
#### Defense in Depth
*I used the following picture: https://miro.medium.com/max/1200/1\*063OWN4gLacDPZX74RCEUw.jpeg*
1. For each of the following scenarios, provide the layer of Defense in Depth that applies:
	 1.  A criminal hacker tailgates an employee through an exterior door into a secured facility, explaining that they forgot their badge at home.
 Answer: **Physical**
	 2. A zero-day goes undetected by antivirus software.
 Answer: **Host**
	 3. A criminal successfully gains access to HR’s database.
	 Answer: **Data**
	 4. A criminal hacker exploits a vulnerability within an operating system.
	 Answer: **Application**
	 5. A hacktivist organization successfully performs a DDoS attack, taking down a government website.
	 Answer: **Network**
	 6. Data is classified at the wrong classification level.
	 Answer: **Policy, Procedures, and Awareness**
	 7. A state sponsored hacker group successfully firewalked an organization to produce a list of active services on an email server.
	 Answer: **Perimeter**
2. Name one method of protecting data-at-rest from being readable on hard drive.
 Answer: **Data Encryption -- the data is stored in an encrypted state.**
3. Name one method to protect data-in-transit.
 Answer: **Encrypted Connection -- the two parties exchanging data establish a secure connection prior to exchanging data; SSL is an example of this.**
4. What technology could provide law enforcement with the ability to track and recover a stolen laptop.
 Answer: **If the laptop runs Microsoft Windows, then "Find My Device" can help locate a stolen laptop. However, this assumes it's turned on and the thieves haven't turned it off.**
5. How could you prevent an attacker from booting a stolen laptop using an external hard drive?
 Answer: **Firmware Password**
#### Firewall Architectures and Methodologies
1. Which type of firewall verifies the three-way TCP handshake? TCP handshake checks are designed to ensure that session packets are from legitimate sources.
 Answer: **Circuit-Level Firewall**
2. Which type of firewall considers the connection as a whole? Meaning, instead of looking at only individual packets, these firewalls look at whole streams of packets at one time.
 Answer: **Packet-Filtering Firewalls (Stateful)**
3. Which type of firewall intercepts all traffic prior to being forwarded to its final destination. In a sense, these firewalls act on behalf of the recipient by ensuring the traffic is safe prior to forwarding it?
 Answer: **Application (Proxy) Firewalls**
4. Which type of firewall examines data within a packet as it progresses through a network interface by examining source and destination IP address, port number, and packet type- all without opening the packet to inspect its contents?
 Answer: **Packet-Filtering Firewalls (Stateless)**
5. Which type of firewall filters based solely on source and destination MAC address?
 Answer: **MAC Layer Firewall**
### Bonus Lab: "Green Eggs & SPAM"
*I chose not to do the bonus lab.*

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE2NDc5NzE5NTYsNjEyMzMyMjgsNTY2Nz
E0OTUyLC0xNTM3Njg3MjcwLC03MTc3MTE3MDksLTIzMjY2MjUx
MCwxNDQ2ODc2NzgyLC0xMjY4MDYzODg0LDE4NTE3MTMwNDksLT
gyNjQ3MTIsMTM3NTQ5OTcyLDI3NTgwOTg2OSwyMDAyNzg1MDA5
LDEwOTMyMzEyODcsMTI3NjI0MDcyOSwtMjczOTk3NTI4LC0yMT
E2NDI5MTAsLTE4NjUzMDY4NTMsNzMxODM4NTU2LC0yMDg2MDA5
NDg4XX0=
-->