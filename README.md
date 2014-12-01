docker-metasploit
=================

A dockerized install of the metasploit framework checked out freshly from github.

How to use
==========
You don't have to do this, but it is highly encouraged that you use the metasploit framework with postgres. This will take a few extra steps.

**Step 1** Clone this repo:
`git clone https://github.com/ZedCode/docker-msf.git docker-msf`

**Step 2** Build the image:
`cd docker-msf`
`sudo docker build -t="[your user]/docker-msf" .`

**Step 3** Mount the msf-postgres directory and copy the contents to the mount via the firstRun.sh script:
`mkdir msf-postgres`

then

`sudo docker run -t -i -v [path to current dir]/msf-postgres:/var/lib/postgresql/9.3/main-save [your user]/docker-msf /bin/bash /firstRun.sh`

NOTE: it is important that you use the exact path above as other things have this path hard coded!

**Step 4** Re-launch with the correct volume mounted:
`sudo docker run -t -i -v [path to current dir]/msf-postgres:/var/lib/postgresql/9.3/main [your user]/docker-msf /bin/bash`

Once again, this path must be identical!

**Step 5** Run the startup script inside the container:
`/bin/bash /startUp.sh`

**Step 6** Become the correct user and launch msfconsole:
`sudo -u mallory /msf/msfconsole -L`

If you really don't want to use postgres, you can build the image and then just do step 6.

**FAQ**

*Why Mallory?* In information security, the name Mallory is typically used to describe the malicious user. For more see http://en.wikipedia.org/wiki/Alice_and_Bob under cast of characters.
