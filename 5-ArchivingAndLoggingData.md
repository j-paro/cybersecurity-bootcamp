# Week 5 Homework Submission File: Archiving and Logging Data

## Recommendations on Viewing this File
I would definitely recommend viewing this file in "HackMD" or some other Markdown viewer. Here's the link to my submission on HackMD: https://hackmd.io/@BizTheDad/SJ53iPurY

---

### Step 1: Create, Extract, Compress, and Manage tar Backup Archives

1. Command to **extract** the `TarDocs.tar` archive to the current directory:
**`tar -xf TarDocs.tar`**

2. Command to **create** the `Javaless_Doc.tar` archive from the `TarDocs/` directory, while excluding the `TarDocs/Documents/Java` directory:
**`tar --exclude='TarDocs/Documents/Java' -cf Javaless_Doc.tar TarDocs/`**
**I was a bit surprised by this in my testing. I would have thought that I should have excluded the "TarDocs" from the pattern.**

3. Command to ensure `Java/` is not in the new `Javaless_Docs.tar` archive:
**`tar -tf Javaless_Docs.tar 'TarDocs/Documents/Java/'`**
**or**
**`tar -tf Javaless_Docs.tar --wildcards '*/Java/'`**
**I did the following just to make sure**
**`tar -tf Javaless_Docs.tar 'TarDocs/Documents/'`**

**Bonus** 
- Command to create an incremental archive called `logs_backup_tar.gz` with only changed files to `snapshot.file` for the `/var/log` directory:
    - **`sudo tar cvvg var_log.snar -f logs_backup-2.tar.gz -z /var/log`**
        - **I spaced the options like I did because man, calling `tar` with options is finicky.**

#### Critical Analysis Question

- Why wouldn't you use the options `-x` and `-c` at the same time with `tar`?
  - **We use 'x' option to extract from a given archive and we use the '-c' option to create a given archive.**

---

### Step 2: Create, Manage, and Automate Cron Jobs

1. Cron job for backing up the `/var/log/auth.log` file:
**`0 6 * * 3 tar czf /auth_backup.tgz /var/log/auth.log >> /dev/null 2>&1`**
**So, the above command specifies the "/" directory for the backup. I put that in the above command because that's what the README's instructions specified. I think that's wrong in this case as my user doesn't have access to write to "/". I think the following is a better solution given I'm writing to a directory I have write permissions on.**
**`0 6 * * 3 tar czf ~/backups/auth/auth_backup.tgz /var/log/auth.log >> /dev/null 2>&1`**
**Both commands will redirect standard out to "/dev/null" which discards the output. The "2>&1" essentially merges standard out and standard error. This effectively discards standard error as well.**

---

### Step 3: Write Basic Bash Scripts

1. Brace expansion command to create the four subdirectories:
**After creating the `~/backups` directory, I ran the following command:**
**`mkdir backups/{freemem,diskuse,openlist,freedisk}`**

2. Paste your `system.sh` script edits below:

    ```bash
    #!/usr/bin/env bash
    #
    # The following prints the free memory to the specified file.
    #
    free -m | grep Mem | awk -v timestamp="$(date)" '{print timestamp,"-->",$4,"MB"}' >> ~/backups/freemem/free_mem.txt
    
    #
    # The following logs the average of five reports of the "mpstat" command
    # with one second intervals between reports
    #
    mpstat 1 5 | awk -v timestamp="$(date)" 'END{print timestamp,"-->",100-$NF"%"}' >> ~/backups/diskuse/disk_usage.txt

    #
    # The following logs both the number of open files and the open files. I
    # that was more interesting than simply all the open files.
    #
    echo "$(date) --> $(lsof | wc -l)" >> ~/backups/openlist/open_list_count.txt
    echo "$(date) --> all open files:" >> ~/backups/openlist/open_list.txt
    lsof >> ~/backups/openlist/open_list.txt
    
    #
    # The following logs the disk statistics for the disk mounted on "/".
    #
    echo "$(date) --> disk stats for filesystem mounted on '/':" >> ~/backups/freedisk/free_disk.txt
    df -h / >> ~/backups/freedisk/free_disk.txt
    ```

3. Command to make the `system.sh` script executable:
**`chmod u+x system.sh`**

**Optional**
- Commands to test the script and confirm its execution:
    - **I used `./system.sh` to run the script.**
    - **I used `find ~/backups -name *.txt -type f | xargs cat` to check the output.**

**Bonus**
- Command to copy `system` to system-wide `weekly` cron directory:
    - **`sudo cp ~/system.sh /etc/cron.weekly/`**
---

### Step 4. Manage Log File Sizes
 
1. Run `sudo nano /etc/logrotate.conf` to edit the `logrotate` configuration file. 

    Configure a log rotation scheme that backs up authentication messages to the `/var/log/auth.log`.

    - Add your config file edits below:

    ```bash
    /var/log/auth.log {
        weekly
        rotate 7
        notifempty
        compress
        delaycompress
        missingok
    }
    ```
---

### Bonus: Check for Policy and File Violations

1. Command to verify `auditd` is active:
**`systemctl status auditd`**

2. Command to set number of retained logs and maximum log file size:

    - Add the edits made to the configuration file below:

    ```bash
    num_logs = 7
    ...
    max_log_file = 35
    
    ```

3. Command using `auditd` to set rules for `/etc/shadow`, `/etc/passwd` and `/var/log/auth.log`:


    - Add the edits made to the `rules` file below:

    ```bash
    -w /etc/shadow -p wra -k hashpass_audit
    -w /etc/passwd -p wra -k userpass_audit
    -w /var/log/auth.log -p wra -k authlog_audit
    ```

4. Command to restart `auditd`:
**`sudo systemctl restart auditd`**

5. Command to list all `auditd` rules:
**`sudo auditctl -l`**

6. Command to produce an audit report:
**`sudo aureport -au`**

7. Create a user with `sudo useradd attacker` and produce an audit report that lists account modifications:
**`sudo aureport -m`**
**The above command produces the following output:**
    ```
    Account Modifications Report
    =================================================
    # date time auid addr term exe acct success event
    =================================================
    1. 10/17/2021 13:39:45 -1 ? ? /usr/sbin/useradd vboxadd no 234
    2. 10/17/2021 13:39:45 -1 ? ? /usr/sbin/useradd vboxadd no 235
    3. 10/17/2021 13:39:45 -1 ? ? /usr/sbin/useradd vboxadd no 236
    4. 10/17/2021 13:39:45 -1 ? ? /usr/sbin/useradd vboxadd no 237
    5. 10/18/2021 01:15:29 1000 UbuntuDesktop pts/0 /usr/sbin/useradd attacker yes 9286
    6. 10/18/2021 01:15:29 1000 UbuntuDesktop pts/0 /usr/sbin/useradd ? yes 9290
    ```

8. Command to use `auditd` to watch `/var/log/cron`:
**`sudo auditctl -w /var/log/cron -p wra -k cron_log`**

9. Command to verify `auditd` rules:
**`sudo auditctl -l`**

---

### Bonus (Research Activity): Perform Various Log Filtering Techniques

1. Command to return `journalctl` messages with priorities from emergency to error:
**`sudo journalctl -b 0 -p 0..7`**

2. Command to check the disk usage of the system journal unit since the most recent boot:
**`sudo journalctl -b 0 --unit=systemd-journald`**

3. Command to remove all archived journal files except the most recent two:
**`sudo journalctl --vacuum-files=2`**


4. Command to filter all log messages with priority levels between zero and two, and save output to `/home/sysadmin/Priority_High.txt`:
**`sudo bash -c 'journalctl -p 0..2 > /home/student/Priority_High.txt'`**
**In order to get the file to write I needed superuser permissions. I used "sudo bash -c" here because that will run all commands under the superuser umbrella. Without that the redirect fails due to a permissions error.**

6. Command to automate the last command in a daily cronjob. Add the edits made to the crontab file below:
**The following edits are made to the root user's crontab using "sudo crontab -e". We have to run the crontab as root because the commands inside the crontab file require a superuser. Also, the instructions didn't say whether to write over the file or append. So, I simply appended.**
    ```bash
    @daily journalctl -p 0..2 >> /home/student/Priority_High.txt 2> /dev/null
    ```

---
© 2020 Trilogy Education Services, a 2U, Inc. brand. All Rights Reserved.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTE3OTc2NTc5NiwtNDkzMzc3OTksLTEyNj
M5NDQ1NCwtMTM5MTQ5MjU5NiwxOTQ3NzUyMjExLDk3MzYzODg3
NiwtMzIxOTYzODIxLC0xMjIxMDA1NjU5XX0=
-->